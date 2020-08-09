//
//  ImagesCollectionViewCell.swift
//  Breedify
//
//  Created by Ebubechukwu Dimobi on 08.08.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import UIKit

protocol ImagesCollectionViewCellDelegate {
    func likeButtonTapped(index: Int, on likeButtonOutlet: UIButton)
}

class ImagesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dogImage: UIImageView!
    @IBOutlet weak var likeButtonOutlet: UIButton!
    var delegate: ImagesCollectionViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }


    @IBAction func likeButtonPressed(_ sender: UIButton) {
        
        delegate?.likeButtonTapped(index: sender.tag, on: likeButtonOutlet)
    }
    
    
}
