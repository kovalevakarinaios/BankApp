//
//  DataManager.swift
//  BankApp
//
//  Created by Karina Kovaleva on 3.06.24.
//

import Foundation

protocol DataManaging: AnyObject {
    var sharedData: [ATM] { get }
    func fetchATMs()
}

extension Notification.Name {
    static let didUpdateATMs = Notification.Name("didUpdateATMs")
}

class DataManager: DataManaging {

    static let shared = DataManager()

    private(set) var sharedData: [ATM] = [] {
        didSet {
            NotificationCenter.default.post(name: .didUpdateATMs, object: nil)
        }
    }

    func fetchATMs() {
        NetworkManager.shared.fetchData { result in
            switch result {
            case .success(let response):
                self.sharedData = response.data.atm
                let db = Storage.db
                Storage.createTable()
                response.data.atm.forEach { Storage.insert(atm: $0) }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
