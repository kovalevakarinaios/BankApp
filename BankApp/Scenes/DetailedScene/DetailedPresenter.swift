//
//  DetailedPresenter.swift
//  BankApp
//
//  Created by Karina Kovaleva on 27.08.24.
//

import UIKit
import CoreLocation

protocol DetailedPresenterLogic {
    func prepareForDisplay(response: DetailedModels.Response)
}

class DetailedPresenter: DetailedPresenterLogic {

    weak var viewController: DetailedDisplayLogic?
    
    func prepareForDisplay(response: DetailedModels.Response) {
        let headlineAttribute: [NSAttributedString.Key : Any]  = [.font : UIFont.boldSystemFont(ofSize: 30),
                                                                  .foregroundColor : UIColor.darkGray]
        let titleAttribute: [NSAttributedString.Key : Any]  = [.font : UIFont.boldSystemFont(ofSize: 20),
                                                               .foregroundColor : UIColor.darkText]
        let contentAttribute: [NSAttributedString.Key : Any] = [.font : UIFont.systemFont(ofSize: 18),
                                                                .foregroundColor : UIColor.black]

        let atm = response.atm
        let address = Helper.createAddress(atm: atm)
        let availability = Helper.createStandardAvailability(atm: response.atm)
        
        let atmType = switch atm.type {
        case "ATM":
            LocalizedStrings.atm.localized
        case "PST":
            LocalizedStrings.pst.localized
        case "CASHIN":
            LocalizedStrings.cashIn.localized
        default:
            LocalizedStrings.infoUnavailable.localized
        }
        
        let currentStatusDescription = switch atm.currentStatus {
        case "On":
            LocalizedStrings.working.localized
        case "Off":
            LocalizedStrings.notWorking.localized
        case "TempOff":
            LocalizedStrings.disabled.localized
        default:
            LocalizedStrings.infoUnavailable.localized
        }
        
        let infoComponents = [
            NSAttributedString(string: atm.address.addressLine + "\n\n", attributes: headlineAttribute),
            NSAttributedString(string: address + "\n\n", attributes: titleAttribute),
            NSAttributedString(string: availability + "\n\n", attributes: titleAttribute),
            NSAttributedString(string: "\(LocalizedStrings.type.localized): ", attributes: titleAttribute),
            NSAttributedString(string: atmType + "\n", attributes: contentAttribute),
            NSAttributedString(string: "\(LocalizedStrings.status.localized): ", attributes: titleAttribute),
            NSAttributedString(string: currentStatusDescription + "\n", attributes: contentAttribute),
            NSAttributedString(string: "\(LocalizedStrings.baseCurrency.localized): ", attributes: titleAttribute),
            NSAttributedString(string: atm.baseCurrency + "\n", attributes: contentAttribute),
            NSAttributedString(string: "\(LocalizedStrings.currency.localized): ", attributes: titleAttribute),
            NSAttributedString(string: atm.currency + "\n", attributes: contentAttribute),
            NSAttributedString(string: "\(LocalizedStrings.cards.localized): ", attributes: titleAttribute),
            NSAttributedString(string: atm.cards.joined(separator: ", ") + "\n", attributes: contentAttribute),
            NSAttributedString(string: "\(LocalizedStrings.availableServices.localized): ", attributes: titleAttribute),
            NSAttributedString(string: atm.services.map{ $0.serviceType }.joined(separator: ", ") + "\n", attributes: contentAttribute),
            NSAttributedString(string: "\(LocalizedStrings.phoneNumber.localized): ", attributes: titleAttribute),
            NSAttributedString(string: atm.contactDetails.phoneNumber, attributes: contentAttribute)
        ]
        
        let finalAttributedString = NSMutableAttributedString()

        for component in infoComponents {
            finalAttributedString.append(component)
        }
        
        guard let atmLatitude = CLLocationDegrees(response.atm.address.geolocation.geographicCoordinates.latitude) else { return }
        guard let atmLongitude = CLLocationDegrees(response.atm.address.geolocation.geographicCoordinates.longitude) else { return }
        let atmCoordinates = CLLocationCoordinate2D(latitude: atmLatitude, longitude: atmLongitude)
        
        self.viewController?.displayInfoAboutAtm(info: DetailedModels.ViewModel(infoAboutAtm: finalAttributedString, coordinates: atmCoordinates, currentLocationCoordinates: response.coordinates))
    }
    
    
}
