//
//  ImagesSavedData.swift
//  Breedify
//
//  Created by Ebubechukwu Dimobi on 09.08.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import Foundation
import RealmSwift


class ImagesSavedData: Object {
    
    @objc dynamic var imageLink: String = ""
    var parentCategory = LinkingObjects(fromType: BreedsSavedData.self, property: "images")
    
    
}
