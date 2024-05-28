//
//  ATM.swift
//  BankApp
//
//  Created by Karina Kovaleva on 27.05.24.
//

import Foundation

struct ATMData: Codable {
    let data: DataClass

    enum CodingKeys: String, CodingKey {
        case data = "Data"
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let atm: [ATM]

    enum CodingKeys: String, CodingKey {
        case atm = "ATM"
    }
}

// MARK: - ATM
struct ATM: Codable {
    let atmID: String
    let type: String
    let baseCurrency: String
    let currency: String
    let atmPrinter: Bool
    let cards: [String]
    let currentStatus: String
    let address: Address
    let services: [Service]
    let availability: Availability
    let contactDetails: ContactDetails

    enum CodingKeys: String, CodingKey {
        case atmID = "atmId"
        case type, baseCurrency, currency
        case atmPrinter = "ATM_printer"
        case cards, currentStatus
        case address = "Address"
        case services = "Services"
        case availability = "Availability"
        case contactDetails = "ContactDetails"
    }
}

// MARK: - Address
struct Address: Codable {
    let streetName, buildingNumber, townName: String
    let countrySubDivision: String
    let country: String
    let addressLine: String
    let description: String
    let geolocation: Geolocation

    enum CodingKeys: String, CodingKey {
        case streetName, buildingNumber, townName, countrySubDivision, country, addressLine, description
        case geolocation = "Geolocation"
    }
}

// MARK: - Geolocation
struct Geolocation: Codable {
    let geographicCoordinates: GeographicCoordinates

    enum CodingKeys: String, CodingKey {
        case geographicCoordinates = "GeographicCoordinates"
    }
}

// MARK: - GeographicCoordinates
struct GeographicCoordinates: Codable {
    let latitude, longitude: String
}

// MARK: - Availability
struct Availability: Codable {
    let access24Hours, isRestricted, sameAsOrganization: Bool
    let standardAvailability: StandardAvailability

    enum CodingKeys: String, CodingKey {
        case access24Hours, isRestricted, sameAsOrganization
        case standardAvailability = "StandardAvailability"
    }
}

// MARK: - StandardAvailability
struct StandardAvailability: Codable {
    let day: [Day]

    enum CodingKeys: String, CodingKey {
        case day = "Day"
    }
}

// MARK: - Day
struct Day: Codable {
    let dayCode: String
    let openingTime: String
    let closingTime: String
    let dayBreak: Break

    enum CodingKeys: String, CodingKey {
        case dayCode, openingTime, closingTime
        case dayBreak = "Break"
    }
}

// MARK: - Break
struct Break: Codable {
    let breakFromTime: String
    let breakToTime: String
}

// MARK: - ContactDetails
struct ContactDetails: Codable {
    let phoneNumber: String
}

// MARK: - Service
struct Service: Codable {
    let serviceType: String
    let description: String
}

