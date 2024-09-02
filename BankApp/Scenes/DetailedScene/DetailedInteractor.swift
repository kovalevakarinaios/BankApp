//
//  DetailedInteractor.swift
//  BankApp
//
//  Created by Karina Kovaleva on 27.08.24.
//

import MapKit

protocol DetailedBussinessLogic {
    func fetchAtm()
}

protocol DetailedDataStore {
    var atm: ATM? { get set }
    var location: CLLocationCoordinate2D? { get set }
}

class DetailedInteractor: DetailedBussinessLogic, DetailedDataStore {

    var atm: ATM?
    var location: CLLocationCoordinate2D?

    var presenter: DetailedPresenterLogic?
    
    func fetchAtm() {
        guard let atm = atm else { return }
        self.presenter?.prepareForDisplay(response: DetailedModels.Response(atm: atm, coordinates: location))
    }
}
