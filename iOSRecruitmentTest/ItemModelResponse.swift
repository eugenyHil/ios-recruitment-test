//
//  ItemModelResponse.swift
//  iOSRecruitmentTest
//
//  Created by Developer on 14.07.17.
//  Copyright © 2017 Snowdog. All rights reserved.
//

import ObjectMapper
import RealmSwift


class ItemModelResponse: Object, Mappable, ItemModel {
    var id: Int = 0
    dynamic var name: String = ""
    dynamic var modelDescription: String = ""
    dynamic var icon: String = ""
    var timestamp: TimeInterval = 0.0
    dynamic var url: String = ""
    
    required convenience init?(map: Map) {
        self.init()        
        do {
            id = try map.value("id")
            name = try map.value("name")
            modelDescription = try map.value("description")
            icon = try map.value("icon")
            timestamp = try map.value("timestamp")
            url = try map.value("url")
        } catch {
            return nil
        }
    }
    
    func mapping(map: Map) {
    }
}
