//
//  ItemModelResponse.swift
//  iOSRecruitmentTest
//
//  Created by Developer on 14.07.17.
//  Copyright © 2017 Snowdog. All rights reserved.
//

import ObjectMapper
import RealmSwift


class ItemModelResponse: Object, Mappable {
    var id: Int?
    dynamic var name: String?
    dynamic var modelDescription: String?
    dynamic var icon: String?
    var timestamp: TimeInterval?
    dynamic var url: String?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        modelDescription <- map["description"]
        icon <- map["icon"]
        timestamp <- map["timestamp"]
        url <- map["url"]
    }
}
