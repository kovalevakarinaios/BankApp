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
        print("fetchATMs func")
        NetworkManager.shared.fetchData { result in
            print("NetworkManager.shared.fetchData are starting")
            switch result {
            case .success(let response):
                print("Connection")
                self.sharedData = response.data.atm
                Storage.createTable()
                response.data.atm.forEach { Storage.insert(atm: $0) }
            case .failure(let error):
                print(error)
            }
        }
    }
}

