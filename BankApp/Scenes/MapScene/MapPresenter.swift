//
//  MapPresenter.swift
//  BankApp
//
//  Created by Karina Kovaleva on 27.05.24.
//

import Foundation

protocol MapPresenterLogic {
    func prepareDataForDisplay(atms: MapModels.ATMEnum.Response)
    func createAddress(atm: ATM) -> String
    func createStandardAvailability(atm: ATM) -> String
}

class MapPresenter: MapPresenterLogic {
    
    weak var viewController: MapViewController?
    
    func prepareDataForDisplay(atms: MapModels.ATMEnum.Response) {
        var viewModel: [MapModels.ATMEnum.ViewModel.AtmForMap] = []
        for atm in atms.atms {
            if let id = Int(atm.atmID),
               let latitude = Double(atm.address.geolocation.geographicCoordinates.latitude),
               let longitude = Double(atm.address.geolocation.geographicCoordinates.longitude) {
                let atm = MapModels.ATMEnum.ViewModel.AtmForMap(id: id,
                                                                name: atm.address.addressLine,
                                                                address: self.createAddress(atm: atm),
                                                                openingHours: self.createStandardAvailability(atm: atm),
                                                                atmCurrency: atm.currency,
                                                                latitude: latitude,
                                                                longitude: longitude)
                viewModel.append(atm)
            }
        }
        let viewModelNew = MapModels.ATMEnum.ViewModel(atmsForMap: viewModel)
        self.viewController?.displayAtms(viewModel: viewModelNew)
    }
    
    func createAddress(atm: ATM) -> String {
        let addressAtm = atm.address
        let stringAddress = addressAtm.countrySubDivision + " область, " + addressAtm.townName + ", " + addressAtm.streetName + " " + addressAtm.buildingNumber
        return stringAddress
    }
    
    func createStandardAvailability(atm: ATM) -> String {
        let atmAvailability = atm.availability.standardAvailability.day
        var atmAvailabilityString = String()
        
        if atm.availability.access24Hours {
            atmAvailabilityString += "Круглосуточно"
        } else {
            for day in atmAvailability {
                switch day.dayCode {
                case "01":
                    atmAvailabilityString += "\nПонедельник: "
                case "02":
                    atmAvailabilityString += "\nВторник: "
                case "03":
                    atmAvailabilityString += "\nСреда: "
                case "04":
                    atmAvailabilityString += "\nЧетверг: "
                case "05":
                    atmAvailabilityString += "\nПятница: "
                case "06":
                    atmAvailabilityString += "\nСуббота: "
                case "07":
                    atmAvailabilityString += "\nВоскресенье: "
                default:
                    break
                }
                atmAvailabilityString += createOpeningHoursString(day: day)
            }
        }
        
        func createOpeningHoursString(day: Day) -> String {
            let openingHoursString = "c " + day.openingTime + " до " + day.closingTime
            return openingHoursString
        }
        
        return atmAvailabilityString
    }
    
    deinit {
        print("MapPresenter deinit")
    }
}
