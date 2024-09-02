//
//  ListInteractor.swift
//  BankApp
//
//  Created by Karina Kovaleva on 3.06.24.
//

import Foundation

protocol ListBusinnessLogic {
    func fetchAtms()
}

class ListInteractor: ListBusinnessLogic {

    var presenter: ListPresenterLogic?
    var id: Int?
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchAtms), name: .didUpdateATMs, object: nil)
    }
    
    @objc func fetchAtms() {
        let atms = DataManager.shared.sharedData
        self.presenter?.prepareDataForDisplay(response: ListModels.Response(atms: atms))
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
