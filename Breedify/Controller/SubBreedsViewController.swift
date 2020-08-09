//
//  SubBreedsViewController.swift
//  Breedify
//
//  Created by Ebubechukwu Dimobi on 08.08.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import UIKit

class SubBreedsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var breed: String?
    var subBreeds: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "BreedsTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CellIdentifiers.forAllTableViews)
        navigationItem.title = breed
        tableView.tableFooterView = UIView()
    }
}

//MARK: - UITableViewDataSource Methods
extension SubBreedsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subBreeds?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.forAllTableViews, for: indexPath) as! BreedsTableViewCell
        cell.infoLabel.isHidden = true
        cell.subbreedNumLabel.isHidden = true
        cell.openBracket.isHidden = true
        cell.closeBracket.isHidden = true
        if subBreeds != nil{
            cell.breedNameLabel.text = subBreeds![indexPath.row]
        }
        
        return cell
    }
}

//MARK: - UITableViewDelegate Methods
extension SubBreedsViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: Constants.Segue.SubsToImages, sender: self)
    }
    
}

//MARK: - Segues and Navigation
extension SubBreedsViewController{
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.SubsToImages{
            
            let ImagesVC = segue.destination as! ImagesViewController
            
            if let indexPath = tableView.indexPathForSelectedRow{
                
                ImagesVC.breedName = self.breed
                ImagesVC.subBreedName = self.subBreeds?[indexPath.row]
                tableView.deselectRow(at: indexPath, animated: true)
            }
            
        }
        
    }
}
