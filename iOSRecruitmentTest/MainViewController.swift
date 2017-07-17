//
//  MainViewController.swift
//  iOSRecruitmentTest
//
//  Created by Bazyli Zygan on 15.06.2016.
//  Copyright © 2016 Snowdog. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

//let uiRealm = try? Realm()

extension DispatchQueue {
    public static let realmBackgroundQueue = DispatchQueue(label: "io.realm.realm.background")
}

extension ThreadSafeReference {
    func async(write: Bool = false, queue: DispatchQueue = .realmBackgroundQueue,
               errorHandler: ((Realm.Error) -> Void)? = nil,
               block: @escaping (Realm, Confined) -> Void, completed: @escaping () -> Void) {
        queue.async {
            do {
                let realm = try Realm()
                if let obj = realm.resolve(self) {
                    if write { realm.beginWrite() }
                    block(realm, obj)
                    if write { try realm.commitWrite() }
                } else {
                    // throw "object deleted" error
                }
            } catch {
                errorHandler?(error as! Realm.Error)
            }
            
            DispatchQueue.main.async {
                completed()
            }
        }
    }
}

extension MainViewController: BalancesViewModelViewDelegate {
    func entriesWereAdded(viewModel: MainViewModel) {
        print("new entries in model")
        canShow = true
        tableView.reloadData()
    }
}

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
        
//        if let items = uiRealm?.objects(ItemModelResponse.self),
//            items.count > 0 {
        
//        getEntries { (items) in
//            self.showData(items: Array(items))
//        }
        
        
//        } else {
//            NetworkManager.getItems(successCallback: { (items: [ItemModelResponse]?) in
//                guard let items = items else {
//                    return
//                }
//                
////                uiRealm?.async_write { () -> Void in
////                    
////                    uiRealm?.add(items)
////                }
//                
//                //////////
//                let realm = try! Realm()
//                let models = realm.objects(ItemModelResponse.self)
//                ThreadSafeReference(to: models).async(write: true, errorHandler: { (error) in
//                    print(error.localizedDescription)
//                }, block: { (realm, confined) in
//                    realm.add(items)
//                }, completed: {
//                    self.showData(items: items)                    
//                })
//                //////////
//            }, errorCallback: { (error: Error) in
//                print("error")
//            })
//        }
    }

    private func setupUI() {
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: Constants.tableViewCellIdentifier)
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
