//
//  ViewController.swift
//  Breedify
//
//  Created by Ebubechukwu Dimobi on 08.08.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import UIKit
import RxSwift

class BreedsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    var breedsData: BreedsData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "BreedsTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CellIdentifiers.forAllTableViews)
        self.getBreeds()
        
    }
    
    private func getBreeds(){
        
        let getBreedsService = GetBreedsService()
        getBreedsService.fetchBreeds().observeOn(MainScheduler.instance).subscribe(onNext: { (breeds) in
            self.breedsData = breeds
            self.tableView.reloadData()
        }, onError: { (_) in
            print("Network Error")
        } ).disposed(by: disposeBag)
    }
    
    
}

//MARK: - UITableViewDataSource Methods
extension BreedsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breedsData?.breeds.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.forAllTableViews, for: indexPath) as! BreedsTableViewCell
        
        if let key = breedsData?.mainBreeds[indexPath.row]{
            cell.breedNameLabel.text = key
            
            if breedsData?.breeds[key]?.isEmpty ?? true{
                cell.subbreedNumLabel.isHidden = true
                cell.infoLabel.isHidden = true
            }else{
                cell.subbreedNumLabel.isHidden = false
                cell.infoLabel.isHidden = false
                cell.subbreedNumLabel.text = String(breedsData?.breeds[key]?.count ?? 0)
            }
            
        }
        
        return cell
        
    }
}

//MARK: - UITableViewDelegateMethods
extension BreedsViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let key = breedsData?.mainBreeds[indexPath.row]{
            if breedsData?.breeds[key]?.isEmpty ?? true{
                performSegue(withIdentifier: Constants.Segue.breedsToImages, sender: self)
            }else{
                performSegue(withIdentifier: Constants.Segue.breedsToSubs, sender: self)
            }
        }
        
    }
}

//MARK: - Segues and Navigation
extension BreedsViewController{
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.breedsToSubs{
            
            let subVC = segue.destination as! SubBreedsViewController
            
            if let indexPath = tableView.indexPathForSelectedRow{
                guard let breedName = breedsData?.mainBreeds[indexPath.row] else {return}
                subVC.breed = breedName
                subVC.subBreeds = breedsData?.breeds[breedName]
                tableView.deselectRow(at: indexPath, animated: true)
            }
            
        }else if segue.identifier == Constants.Segue.breedsToImages {
            let ImagesVC = segue.destination as! ImagesViewController
            if let indexPath = tableView.indexPathForSelectedRow{
                ImagesVC.breedName = breedsData?.mainBreeds[indexPath.row]
                tableView.deselectRow(at: indexPath, animated: true)
            }
            
        }
        
    }
    
    
    
}
