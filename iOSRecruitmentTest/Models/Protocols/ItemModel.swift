//
//  ItemModel.swift
//  iOSRecruitmentTest
//
//  Created by Developer on 17.07.17.
//  Copyright © 2017 Snowdog. All rights reserved.
//

import Foundation


protocol ItemModel {
    var id: Int { get set }
    var name: String { get set }
    var modelDescription: String { get set }
    var icon: String { get set }
    var timestamp: TimeInterval { get set }
    var url: String { get set }
}
