//
//  FavouritesViewController.swift
//  Breedify
//
//  Created by Ebubechukwu Dimobi on 08.08.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import UIKit
import RealmSwift

class FavouritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private  var breedCategories: Results<BreedsSavedData>?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "BreedsTableViewCell", bundle: nil),
                           forCellReuseIdentifier: Constants.CellIdentifiers.forAllTableViews)
        loadDataFromCache()
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loadDataFromCache()
        tableView.tableFooterView = UIView()
    }
    
    private func loadDataFromCache(){
        
        let realm = try! Realm()
        self.breedCategories = realm.objects(BreedsSavedData.self)
        tableView.reloadData()
    }
}



//MARK: - UITableViewDataSource Methods
extension FavouritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breedCategories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.forAllTableViews, for: indexPath) as! BreedsTableViewCell
        cell.infoLabel.text = "photos"
        cell.breedNameLabel.text = breedCategories?[indexPath.row].breedName
        cell.subbreedNumLabel.text = String(breedCategories?[indexPath.row].images.count ?? 0)
        
        return cell
    }
}

//MARK: - UITableViewDelegate Methods
extension FavouritesViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: Constants.Segue.FavsToImages, sender: self)
    }
    //MARK: - swipe gestures
    //swipe from right
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let trash = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions:[trash])
    }
    
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            
            if let breedForDeletion = self.breedCategories?[indexPath.row].breedName{
                let saveManager = SaveManager()
                saveManager.deleteBreed(breedName: breedForDeletion)
                self.tableView.reloadData()
            }
            
        }
        action.image = UIImage(systemName: "trash")
        action.backgroundColor = .red
        
        return action
        
    }
    
}

//MARK: - Segues and Navigation
extension FavouritesViewController{
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.FavsToImages{
            
            let ImagesVC = segue.destination as! ImagesViewController
            
            if let indexPath = tableView.indexPathForSelectedRow{
                
                ImagesVC.breedName = self.breedCategories?[indexPath.row].breedName
                let imageLinks = getImagesFromCache(through: indexPath)
                let imagesData = ImagesData(imageLinks: imageLinks)
                ImagesVC.imagesData = imagesData
                tableView.deselectRow(at: indexPath, animated: true)
            }
            
        }
        
    }
    
    private func getImagesFromCache(through indexPath: IndexPath) -> [String]{
        
        var imageLinks = [String]()
        
        if self.breedCategories != nil{
            for images in self.breedCategories![indexPath.row].images{
                imageLinks.append(images.imageLink)
            }
        }
        return imageLinks
    }
}
