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
    var id: Int = DefaultValue.int
    dynamic var name: String = DefaultValue.string
    dynamic var modelDescription: String = DefaultValue.string
    dynamic var icon: String = DefaultValue.string
    var timestamp: TimeInterval = DefaultValue.double
    dynamic var url: String = DefaultValue.string
    
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
