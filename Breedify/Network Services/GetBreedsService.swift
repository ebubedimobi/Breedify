//
//  GetBreedsService.swift
//  Breedify
//
//  Created by Ebubechukwu Dimobi on 08.08.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import Foundation
import RxSwift

struct GetBreedsService {
    
    func fetchBreeds()-> Observable<BreedsData>{
        
        return Observable.create { (observer) -> Disposable in
            let completeQueryURL = EndPoints.GetBreeds.topUrl
            
            if let url = URL(string: completeQueryURL){
                
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url) { (data, response, error) in
                    
                    if error != nil{
                        print("Newtwork Problem \(error!)")
                        observer.onError(error!)
                        return
                    }
                    
                    if let safeData = data{
                        do{
                            if let jsonResult = try JSONSerialization.jsonObject(with: safeData, options: [.allowFragments]) as? [String:Any]{
                                
                                guard let breeds = jsonResult["message"] as? [String:[String]] else{
                                    print("Couldn't Convert to data")
                                    observer.onError(NSError(domain: "Couldn't Convert Data", code: -1, userInfo: nil))
                                    return
                                }
                                let breedsData = BreedsData(breeds: breeds)
                                observer.onNext(breedsData)
                                
                            }
                            
                            
                        }catch{
                            
                            print("could not parse Json---\(error)")
                            observer.onError(error)
                        }
                        
                    }else {
                        print("Data is empty")
                        observer.onError(NSError(domain: "Data is empty", code: -1, userInfo: nil))
                    }
                }
                task.resume()
                
                return Disposables.create {
                    task.cancel()
                }
            }
            
            return Disposables.create { }
        }
        
    }
    
    
}
