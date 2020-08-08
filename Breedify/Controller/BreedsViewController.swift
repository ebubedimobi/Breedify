//
//  ViewController.swift
//  Breedify
//
//  Created by Ebubechukwu Dimobi on 08.08.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import UIKit

class BreedsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "BreedsTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CellIdentifiers.forAllTableViews)
  
    }


}

//MARK: - UITableViewDataSource Methods
extension BreedsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.forAllTableViews, for: indexPath) as! BreedsTableViewCell
        
        return cell
    }
    
    
    
    
    
}

