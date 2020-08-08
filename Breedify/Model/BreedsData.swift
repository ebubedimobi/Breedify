//
//  BreedsData.swift
//  Breedify
//
//  Created by Ebubechukwu Dimobi on 08.08.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import Foundation

struct BreedsData {
    let breeds: [String:[String]]
    
    var mainBreeds : [String]{
        
        var breedNames = [String]()
        for (key, _) in breeds.sorted(by: {$0.0 < $1.0}){
            breedNames.append(key)
        }
        return breedNames
        
    }
}
