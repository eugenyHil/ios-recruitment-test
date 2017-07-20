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
    
    lazy fileprivate var refreshControl: UIRefreshControl = {
        let tableViewController = UITableViewController()
        let refreshControl = UIRefreshControl()
        tableViewController.tableView = self.tableView
        refreshControl.addTarget(self, action: #selector(MainViewController.refresh), for: UIControlEvents.valueChanged)
        tableViewController.refreshControl = refreshControl
        
        return refreshControl
    }()
    lazy fileprivate var itemsWereAdded: Bool = false
    lazy fileprivate var shouldShowSearchResults = false
    
    var viewModel: MainViewModel? {
        didSet {
            self.viewModel?.viewDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        tableView.registerCellType(TableViewCell.self)
    }
    
    @objc fileprivate func refresh() {
        viewModel?.updateItems()
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let viewModel = viewModel,
            let entries = viewModel.items,
            let searchString = searchBar.text else {
            return
        }
        
        viewModel.filteredArray = entries.filter { item in
            return searchString.isEmpty || item.name.lowercased().contains(searchString.lowercased())
        }
        
        shouldShowSearchResults = !searchString.isEmpty
        
        self.tableView.reloadData()
    }
}

extension MainViewController: MainViewModelDelegate {
    func itemsWereAdded(viewModel: MainViewModel) {
        itemsWereAdded = true
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func errorOccured(error: Error) {
        func showAlert(error: Error) {
            let alert = UIAlertController(title: Constants.alert_title, message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: Constants.alert_close_title, style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        refreshControl.endRefreshing()
        showAlert(error: error)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }

        if shouldShowSearchResults {
            return viewModel.filteredArray.count
        }
        
        if itemsWereAdded == false {
            return 0
        }
        
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withCellType: TableViewCell.self, for: indexPath) as? TableViewCell,
            let viewModel = viewModel else {
            return UITableViewCell()
        }
        
        cell.item = shouldShowSearchResults ? viewModel.filteredArray[indexPath.row] : viewModel.entryAtRow(indexPath.row)
        
        return cell
    }
}
