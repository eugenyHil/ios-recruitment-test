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
import SDWebImage


class MainModel {
    func update(_ completionHandler: @escaping (_ entries: [ItemModel]) -> Void, errorHandler: @escaping (_ error: Error) -> Void) {
        let queue = DispatchQueue(label: "serialQueue")
        
        queue.async {
            guard let realm = try? Realm() else {
                return
            }
        
            let objects = realm.objects(ItemModelResponse.self)
            
            try? realm.write({ () -> Void in
                realm.delete(objects)
            })
            
            SDImageCache.shared().clearMemory()
            SDImageCache.shared().clearDisk(onCompletion: {
                self.getEntries(completionHandler, errorHandler: errorHandler)
            })
        }
    }
    
    func getEntries(_ completionHandler: @escaping (_ entries: [ItemModel]) -> Void, errorHandler: @escaping (_ error: Error) -> Void) {
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

        func getResultArray<T: Any>(objects: EnumeratedSequence<T>) -> [ItemModel] {
            var returnArray = [ItemModel]()
            for (_, item) in objects {
                guard let item = item as? ItemModelResponse else {
                    assertionFailure(Constants.wrong_casting)
                    return []
                }
            
                // create temporary DataEntry-conform object in order to prevent error: "Realm accessed from incorrect thread"
                let e = ItemModelDub(id: item.id, name: item.name, modelDescription: item.modelDescription, icon: item.icon, timestamp: item.timestamp, url: item.url)
                returnArray.append(e)
            }
            
            return returnArray
        }
        
        let queue = DispatchQueue(label: "serialQueue")
        queue.async {
            guard let realm = try? Realm() else {
                return
            }
            
            let objects = realm.objects(ItemModelResponse.self)
            
            if objects.count > 0 {
                let returnArray = getResultArray(objects: objects.enumerated())
                DispatchQueue.main.async {
                    completionHandler(returnArray)
                }
            } else {
                NetworkManager.getItems(successCallback: { (items: [ItemModelResponse]?) in
                    guard let items = items else {
                        return
                    }
                    
                    queue.async {
                        guard let realm = try? Realm() else {
                            return
                        }
                        
                        try? realm.write { () -> Void in
                            realm.add(items)
                        }
                        
                        let returnArray = getResultArray(objects: items.enumerated())
                        
                        DispatchQueue.main.async {
                            completionHandler(returnArray)
                        }
                    }
                }, errorCallback: { (error: Error) in
                    errorHandler(error)
                })
            }
        }
    }
}
