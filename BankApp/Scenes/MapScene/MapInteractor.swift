//
//  MapInteractor.swift
//  BankApp
//
//  Created by Karina Kovaleva on 27.05.24.
//

import Foundation

protocol MapBusinessLogic {
    func fetchAtms()
}

class MapInteractor: MapBusinessLogic {
    
    var presenter: MapPresenterLogic?
    
    func fetchAtms() {
        NetworkManager.shared.fetchData { result in
            switch result {
            case .success(let result):
                let response = MapModels.ATMEnum.Response(atms: result.data.atm)
                self.presenter?.prepareDataForDisplay(atms: response)
            case .failure(let error):
                switch error {
                case .wrongURL:
                    print("wrongURL")
                case .invalidResponse:
                    print("invalid response")
                case .decodingError:
                    print("decoding error")
                }
            }
        }
    }
    
    deinit {
        print("MapInteractor deinit")
    }
}
