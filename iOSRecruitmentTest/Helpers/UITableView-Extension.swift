//
//  UITableView-Extension.swift
//  iOSRecruitmentTest
//
//  Created by Developer on 19.07.17.
//  Copyright © 2017 Snowdog. All rights reserved.
//

import UIKit


extension UITableView {
    func registerCellType(_ cellType: UITableViewCell.Type) {
        let cellName = String(describing: cellType) 
        register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
    }
    
    func dequeueReusableCell(withCellType cellType: UITableViewCell.Type, for indexPath: IndexPath) -> UITableViewCell {
        let cellName = String(describing: cellType)
        
        return dequeueReusableCell(withIdentifier: cellName, for: indexPath)
    }
}
