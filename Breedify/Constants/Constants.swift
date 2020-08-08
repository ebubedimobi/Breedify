//
//  Constants.swift
//  Breedify
//
//  Created by Ebubechukwu Dimobi on 08.08.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import Foundation


struct Constants {
    
    struct CellIdentifiers {
        static let forAllTableViews = "breedsCell"
        static let forImages = "ImagesCell"
    }
    
    
    struct Segue {
        static let breedsToSubs = "goToSubFromMain"
        static let breedsToImages = "goToImagesFromMain"
        static let SubsToImages = "goToImagesFromSub"
        static let FavsToImages = "goToImagesFromFavs"
    }
}
