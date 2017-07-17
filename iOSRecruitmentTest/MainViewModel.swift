//
//  MainViewModel.swift
//  iOSRecruitmentTest
//
//  Created by Developer on 16.07.17.
//  Copyright © 2017 Snowdog. All rights reserved.
//

import Foundation


protocol BalancesViewModelViewDelegate: class {
    
    func entriesWereAdded(viewModel: MainViewModel)
}

class MainViewModel {
    weak var viewDelegate: BalancesViewModelViewDelegate?
    
    fileprivate var entries: [ItemModelResponse]? {
        didSet {
            self.viewDelegate?.entriesWereAdded(viewModel: self)
        }
    }
    
    var model: MainModel? {
        didSet {
//            self.entries = nil;
            self.model?.getEntries({ (items) in
                self.entries = items
            })
        }
    }
    
    func numberOfRows() -> Int {
        if let model = self.model {
            return  model.getNumberOfRows()
        }
        
        return 0
    }

    
    func entryAtRow(_ rowNr: Int) -> ItemModelResponse? {       
        if let entries = self.entries,
            entries.count > 0 {
                return entries[rowNr]
        }
    
        return nil
    }
}
