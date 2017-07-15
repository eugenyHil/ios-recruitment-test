//
//  ViewController.swift
//  iOSRecruitmentTest
//
//  Created by Bazyli Zygan on 15.06.2016.
//  Copyright © 2016 Snowdog. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var model = ViewControllerModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        NetworkManager.getItems(successCallback: { (items: [ItemModelResponse]?) in
            guard let items = items else {
                return
            }
            
            self.model.items = items
            self.tableView.reloadData()
        }, errorCallback: { (error: Error) in
            print("error")
        })
    }

    private func setupUI() {
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: Constants.tableViewCellIdentifier)
    }
}

extension ViewController: UITableViewDataSource, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: Constants.tableViewCellIdentifier, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        cell.item = model.items[indexPath.row]
        
        return cell
    }
}
