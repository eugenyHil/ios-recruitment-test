//
//  MainViewController.swift
//  iOSRecruitmentTest
//
//  Created by Bazyli Zygan on 15.06.2016.
//  Copyright © 2016 Snowdog. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var canShow: Bool = false
    
    var viewModel: MainViewModel? {
        willSet {
            self.viewModel?.viewDelegate = nil
        }
        didSet {
            self.viewModel?.viewDelegate = self
//            self.refreshDisplay()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: Constants.tableViewCellIdentifier)
    }
}

extension MainViewController: BalancesViewModelViewDelegate {
    func entriesWereAdded(viewModel: MainViewModel) {
        canShow = true
        tableView.reloadData()
    }
}

extension MainViewController: UITableViewDataSource, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if canShow == false {
            return 0
        }
        
        return viewModel?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: Constants.tableViewCellIdentifier, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        
        let item = viewModel?.entryAtRow(indexPath.row)
        cell.item = item
        
        return cell
    }
}
