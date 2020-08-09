//
//  SaveCahceManager.swift
//  Breedify
//
//  Created by Ebubechukwu Dimobi on 09.08.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import Foundation
import RealmSwift


struct SavedManager {
    
    func saveToDataBase(imageLink: String, breedsCategory: String){
        
        if checkIfImageAlreadyExists(with: imageLink){
            return
        }else{
            checkIfBreedCategoryAlreadyExists(with: breedsCategory)
            saveImageLink(with: imageLink, and: breedsCategory)
        }
        
    }
    
    
    private func checkIfBreedCategoryAlreadyExists(with breedsCategory: String){
        
        let realm = try! Realm()
        
        if realm.objects(BreedsSavedData.self).filter("breedName CONTAINS %@", breedsCategory).isEmpty{
            let breedsSavedData = BreedsSavedData()
            breedsSavedData.breedName = breedsCategory
            do{
                try realm.write{
                    realm.add(breedsSavedData)
                }
            }catch{
                print("error while saving Category\(error)")
            }
            
        }
    }
    
    func checkIfImageAlreadyExists(with imageLink: String) -> Bool {
        let realm = try! Realm()
        if realm.objects(ImagesSavedData.self).filter("imageLink CONTAINS %@", imageLink).isEmpty{
            
            return false
        }else{
            return true
        }
    }
    
    private func saveImageLink(with imageLink: String, and breedsName: String){
        let realm = try! Realm()
        let imagesSavedData = ImagesSavedData()
        imagesSavedData.imageLink = imageLink
        let breedCategory = realm.objects(BreedsSavedData.self).filter("breedName CONTAINS %@", breedsName).first
        do{
            try realm.write{
                breedCategory?.images.append(imagesSavedData)
                
            }
        }catch {
            print("error while saving image\(error)")
        }
        
    }
    
    func deleteImage(with imageLink: String){
        let realm = try! Realm()
        
        do{
             try realm.write{
                
                 realm.delete(realm.objects(ImagesSavedData.self).filter("imageLink CONTAINS %@", imageLink))
             }
         }catch{
             print("error while deleting\(error)")
         }
        
    }
}

