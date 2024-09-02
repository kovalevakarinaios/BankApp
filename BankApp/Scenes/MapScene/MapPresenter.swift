//
//  MapPresenter.swift
//  BankApp
//
//  Created by Karina Kovaleva on 27.05.24.
//

import Foundation

protocol MapPresenterLogic {
    func prepareDataForDisplay(atms: MapModels.Response.AtmsResponse)
    func prepareLocationForDisplay(location: MapModels.Response.LocationResponse)
    func prepareInfoAboutAccessToLocation()
}

class MapPresenter: MapPresenterLogic {

    weak var viewController: MapViewController?
    
    func prepareDataForDisplay(atms: MapModels.Response.AtmsResponse) {
        var viewModel: [MapModels.ViewModel.AtmsViewModel.AtmForMap] = []
        for atm in atms.atms {
            if let id = Int(atm.atmID),
               let latitude = Double(atm.address.geolocation.geographicCoordinates.latitude),
               let longitude = Double(atm.address.geolocation.geographicCoordinates.longitude) {
                let atm = MapModels.ViewModel.AtmsViewModel.AtmForMap(id: id,
                                                        name: atm.address.addressLine,
                                                        address: Helper.createAddress(atm: atm),
                                                        openingHours: Helper.createStandardAvailability(atm: atm),
                                                        atmCurrency: atm.currency,
                                                        latitude: latitude,
                                                        longitude: longitude)
                viewModel.append(atm)
            }
        }
        let viewModelNew = MapModels.ViewModel.AtmsViewModel(atmsForMap: viewModel)
        self.viewController?.displayAtms(viewModel: viewModelNew)
    }
    
    func prepareLocationForDisplay(location: MapModels.Response.LocationResponse) {
        self.viewController?.displayCurrentLocation(viewModel: MapModels.ViewModel.LocationViewModel(latitude: location.location.coordinate.latitude, longitude: location.location.coordinate.longitude))
    }
    
    func prepareInfoAboutAccessToLocation() {
        self.viewController?.showAlertController(viewModel: MapModels.ViewModel.LocationAlertControllerViewModel(title: LocalizedStrings.alertAccessLocationTitle.localized,
                                                                                                                 message: LocalizedStrings.alertAccessLocationMessage.localized))
    }
    
    deinit {
        print("MapPresenter deinit")
    }
}
