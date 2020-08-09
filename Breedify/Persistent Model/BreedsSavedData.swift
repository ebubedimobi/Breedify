//
//  BreedsSaveData.swift
//  Breedify
//
//  Created by Ebubechukwu Dimobi on 09.08.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import Foundation
import RealmSwift

class BreedsSavedData: Object {
    
    @objc dynamic var breedName: String = ""
    let images = List<ImagesSavedData>()
    
    
}
