//
//  MainViewModel.swift
//  iOSRecruitmentTest
//
//  Created by Developer on 16.07.17.
//  Copyright © 2017 Snowdog. All rights reserved.
//

import Foundation


protocol MainViewModelDelegate: class {
    func itemsWereAdded(viewModel: MainViewModel)
    func errorOccured(error: Error)
}

class MainViewModel {
    weak var viewDelegate: MainViewModelDelegate?
    
    var items: [ItemModel]? {
        didSet {
            guard let _ = self.viewDelegate?.itemsWereAdded(viewModel: self) else {
                assertionFailure(Constants.property_not_setted)
                return
            }
        }
    }
    lazy var filteredArray = [ItemModel]()
    
    var model: MainModel? {
        didSet {
            guard let model = self.model else {
                assertionFailure(Constants.property_not_setted)
                return
            }
            
            model.getEntries({ (items) in
                self.items = items
            }, errorHandler: { (error) in
                guard let _ = self.viewDelegate?.errorOccured(error: error) else {
                    assertionFailure(Constants.property_not_setted)
                    return
                }
            })
        }
    }
    
    func updateItems() {
        guard let model = self.model else {
            assertionFailure(Constants.property_not_setted)
            return
        }
        
        model.update({ (items) in
            self.items = items
        }, errorHandler: { (error) in
            guard let _ = self.viewDelegate?.errorOccured(error: error) else {
                assertionFailure(Constants.property_not_setted)
                return
            }
        })
    }
    
    func numberOfRows() -> Int {
        return self.items?.count ?? 0
    }

    func entryAtRow(_ rowNr: Int) -> ItemModel? {       
        if let entries = self.items,
            entries.count > 0 {
                return entries[rowNr]
        }
    
        return nil
    }
}
