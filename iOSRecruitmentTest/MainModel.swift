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


extension Results {
    
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        
        return array
    }
}

class MainModel {
    var items: [ItemModelResponse] = []
    
    func getEntries(_ completionHandler: @escaping (_ entries: [ItemModel]) -> Void) {
        
        let queue = DispatchQueue(label: "serialQueue")
        
        queue.async {
            class ItemModelDub: ItemModel {
                var id: Int
                var name: String
                var modelDescription: String
                var icon: String
                var timestamp: TimeInterval
                var url: String
                
                init(id: Int, name: String, modelDescription: String, icon: String, timestamp: TimeInterval, url: String) {
                    self.id = id
                    self.name = name
                    self.modelDescription = modelDescription
                    self.icon = icon
                    self.timestamp = timestamp
                    self.url = url
                }
            }
            
            func getResultArray(objects: Results<ItemModelResponse>) -> [ItemModel] {
                var returnArray = [ItemModel]()
                for item in objects {
                    let e = ItemModelDub(id: item.id, name: item.name, modelDescription: item.modelDescription, icon: item.icon, timestamp: item.timestamp, url: item.url)
                    returnArray.append(e)
                }
                
                return returnArray
            }
            
            let realm = try! Realm()
            let objects = realm.objects(ItemModelResponse.self)
            
            if objects.count > 0 {
                let returnArray = getResultArray(objects: objects)
                DispatchQueue.main.async {
                    completionHandler(returnArray)
                }
            } else {
                NetworkManager.getItems(successCallback: { (items: [ItemModelResponse]?) in
                    guard let items = items else {
                        return
                    }
                    
                    queue.async {
                        func getResultArrayE(objects: [ItemModelResponse]) -> [ItemModel] {
                            var returnArray = [ItemModel]()
                            for item in objects {
                                let e = ItemModelDub(id: item.id, name: item.name, modelDescription: item.modelDescription, icon: item.icon, timestamp: item.timestamp, url: item.url)
                                returnArray.append(e)
                            }
                            
                            return returnArray
                        }
                        
                        let realm = try! Realm()
                        
                        try? realm.write { () -> Void in
                            realm.add(items)
                        }
                        
                        let returnArray = getResultArrayE(objects: items)
                        
                        DispatchQueue.main.async {
                            completionHandler(returnArray)
                        }
                    }
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
