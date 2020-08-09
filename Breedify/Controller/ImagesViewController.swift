//
//  ImagesViewController.swift
//  Breedify
//
//  Created by Ebubechukwu Dimobi on 08.08.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import UIKit
import RxSwift
import Kingfisher

class ImagesViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    let disposeBag = DisposeBag()
    var breedName: String?
    var subBreedName: String?
    var imagesData: ImagesData?
    // var selectedBreed: BreedsSavedData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "ImagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constants.CellIdentifiers.forImages)
        setNavigationItemTitle()
        GetImages()
    }
    
    func GetImages(){
        let getImagesService = GetImagesService()
        var subUrl = String()
        
        if self.subBreedName != nil && self.breedName != nil{
            subUrl = ("\(self.breedName!)/\(subBreedName!)")
        }else {
            subUrl = ("\(self.breedName!)")
        }
        getImagesService.fetchImages(using: subUrl).observeOn(MainScheduler.instance).subscribe(onNext: { (imagesData) in
            self.imagesData = imagesData
            self.collectionView.reloadData()
        }, onError: { (_) in
            print("Network Error")
        } ).disposed(by: disposeBag)
        
        
    }
    
    func setNavigationItemTitle(){
        if subBreedName != nil{
            navigationItem.title = subBreedName
        }else{
            navigationItem.title = breedName
        }
    }
    
    
    func setCollectionViewCellBounds()->CGSize{
        let screenBounds = UIScreen.main.bounds
        let width = screenBounds.width
        let height = screenBounds.height / 2
        return CGSize(width: width, height: height)
    }
    
    
    @IBAction func shareButtonTapped(_ sender: UIBarButtonItem) {
        
    }
    
}

//MARK: - UICollectionViewDataSource Methods
extension ImagesViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesData?.imageLinks.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.forImages, for: indexPath) as! ImagesCollectionViewCell
        cell.delegate = self
        if let imageUrl = URL(string: imagesData?.imageLinks[indexPath.row] ?? ""  ){
            cell.dogImage.kf.indicatorType = .activity
            cell.dogImage.kf.setImage(
                with: imageUrl,
                options: [
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(0.5)),
                    .cacheOriginalImage
            ])
            
        }
        cell.likeButtonOutlet.tag = indexPath.row
        
        let saveManager = SavedManager()
        if saveManager.checkIfImageAlreadyExists(with: imagesData?.imageLinks[indexPath.row] ?? ""){
            cell.likeButtonOutlet.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else{
            cell.likeButtonOutlet.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        return cell
    }
    
}

extension ImagesViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.setCollectionViewCellBounds()
    }
    
}

//MARK: - Custom ImagesCollectionViewCellDelegate
extension ImagesViewController: ImagesCollectionViewCellDelegate {
    
    func likeButtonTapped(index: Int, on likeButtonOutlet: UIButton) {
        
        var breedCategory = String()
        
        if self.subBreedName != nil {
            breedCategory = self.subBreedName!
        }else{
            breedCategory = self.breedName!
        }
        
        let saveManager = SavedManager()
        if saveManager.checkIfImageAlreadyExists(with: imagesData?.imageLinks[index] ?? ""){
            saveManager.deleteImage(with: imagesData?.imageLinks[index] ?? "")
            likeButtonOutlet.setImage(UIImage(systemName: "heart"), for: .normal)
        }else{
            saveManager.saveToDataBase(imageLink: imagesData?.imageLinks[index] ?? "", breedsCategory: breedCategory)
            likeButtonOutlet.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        
        
    }
    
    
    
    
    
}
