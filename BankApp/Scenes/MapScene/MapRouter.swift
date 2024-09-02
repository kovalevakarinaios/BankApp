//
//  MapRouter.swift
//  BankApp
//
//  Created by Karina Kovaleva on 27.05.24.
//

import Foundation

protocol MapRoutingLogic {
    func showDetailView()
}

protocol MapDataPassing {
    var dataStore: MapDataStore? { get set }
}


class MapRouter: MapRoutingLogic, MapDataPassing {

    weak var viewController: MapViewController?
    var dataStore: MapDataStore?
    
    func showDetailView() {
        guard let detailedViewController = Configurator.createDetailModule() as? DetailedViewController else { return }
        self.viewController?.navigationController?.pushViewController(detailedViewController, animated: true)
        guard let mapDataStore = dataStore else { return }
        self.passDataToDetail(source: mapDataStore, destination: &detailedViewController.router!.dataStore!)
    }

    private func passDataToDetail(source: MapDataStore, destination: inout DetailedDataStore) {
        destination.atm = source.atmDataStore
        destination.location = source.location
    }
}
