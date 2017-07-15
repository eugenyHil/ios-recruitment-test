//
//  ItemModelResponse.swift
//  iOSRecruitmentTest
//
//  Created by Developer on 14.07.17.
//  Copyright © 2017 Snowdog. All rights reserved.
//

import ObjectMapper


class ItemModelResponse: Mappable {
    var id: NSNumber!
    var name: String!
    var description: String!
    var icon: String!
    var timestamp: TimeInterval!
    var url: String!
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        description <- map["description"]
        icon <- map["icon"]
        timestamp <- map["timestamp"]
        url <- map["url"]
    }
}

//id: 0,
//name: "Item (0)",
//description: "Description of item (0)",
//icon: "http://localhost:8080/api/items/0/icon.png",
//timestamp: 1468595269800,
//url: "http://localhost:8080/api/items/0"
