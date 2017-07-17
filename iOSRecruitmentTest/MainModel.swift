//
//  MainModel.swift
//  iOSRecruitmentTest
//
//  Created by Developer on 14.07.17.
//  Copyright © 2017 Snowdog. All rights reserved.
//

import Foundation
import Realm
import RealmSwift


class MainModel {
    var items: [ItemModelResponse] = []
    
    func getEntries(_ completionHandler: @escaping (_ entries: [ItemModelResponse]) -> Void) {
        
        let serialQueue = DispatchQueue(label: "XXqueuename")
        
        serialQueue.async {
            let realm = try! Realm()
            let objects = realm.objects(ItemModelResponse.self)
            
            if objects.count > 0 {
                DispatchQueue.main.async {
                    let realm = try! Realm()
                    let objects = realm.objects(ItemModelResponse.self)
                    completionHandler(Array(objects))
                }
            } else {
                NetworkManager.getItems(successCallback: { (items: [ItemModelResponse]?) in
                    
                    //let serialQueue = DispatchQueue(label: "queuename")
                    
                    guard let items = items else {
                        return
                    }
                    
                    serialQueue.async {
                        let realm = try! Realm()
                        
                        try? realm.write { () -> Void in
                            realm.add(items)
                        }
                        
                        DispatchQueue.main.async {
//                            completionHandler(Array(items))
                            let realm = try! Realm()
                            let objects = realm.objects(ItemModelResponse.self)
                            completionHandler(Array(objects))
                        }
                    }
                    
                    //////////
//                    let realm = try! Realm()
//                    let models = realm.objects(ItemModelResponse.self)
//                    ThreadSafeReference(to: models).async(write: true, errorHandler: { (error) in
//                        print(error.localizedDescription)
//                    }, block: { (realm, confined) in
//                        realm.add(items)
//                    }, completed: {
//                        self.showData(items: items)                    
//                    })
                    //////////
                }, errorCallback: { (error: Error) in
                    print("error")
                })

            }
        }
    }
    
    func getNumberOfRows() -> Int {
        let realm = try! Realm()
        let qEntry = realm.objects(ItemModelResponse.self)
        
        return qEntry.count
    }
}
