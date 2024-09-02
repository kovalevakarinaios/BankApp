//
//  Helper.swift
//  BankApp
//
//  Created by Karina Kovaleva on 3.06.24.
//

import Foundation

protocol HelperProtocol {
    static func createAddress(atm: ATM) -> String
    static func createStandardAvailability(atm: ATM) -> String
}

class Helper: HelperProtocol {
    
    static func createAddress(atm: ATM) -> String {
        let addressAtm = atm.address
        let stringAddress = addressAtm.countrySubDivision + " область, " + addressAtm.townName + ", " + addressAtm.streetName + " " + addressAtm.buildingNumber
        return stringAddress
    }
    
    static func createStandardAvailability(atm: ATM) -> String {
        let atmAvailability = atm.availability.standardAvailability.day
        var atmAvailabilityString = String()
        
        if atm.availability.access24Hours {
            atmAvailabilityString += LocalizedStrings.access24Hours.localized
        } else {
            for day in atmAvailability {
                switch day.dayCode {
                case "01":
                    atmAvailabilityString += "\n\(LocalizedStrings.monday.localized): "
                case "02":
                    atmAvailabilityString += "\n\(LocalizedStrings.tuesday.localized): "
                case "03":
                    atmAvailabilityString += "\n\(LocalizedStrings.wednesday.localized): "
                case "04":
                    atmAvailabilityString += "\n\(LocalizedStrings.thursday.localized): "
                case "05":
                    atmAvailabilityString += "\n\(LocalizedStrings.friday.localized): "
                case "06":
                    atmAvailabilityString += "\n\(LocalizedStrings.saturday.localized): "
                case "07":
                    atmAvailabilityString += "\n\(LocalizedStrings.sunday.localized): "
                default:
                    break
                }
                atmAvailabilityString += createOpeningHoursString(day: day)
            }
        }
        
        func createOpeningHoursString(day: Day) -> String {
            let openingHoursString = "\(LocalizedStrings.from.localized) " + day.openingTime + " \(LocalizedStrings.to.localized) " + day.closingTime
            return openingHoursString
        }
        
        return atmAvailabilityString
    }
}
