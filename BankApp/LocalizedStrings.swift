//
//  LocalizedStrings.swift
//  BankApp
//
//  Created by Karina Kovaleva on 30.08.24.
//

import Foundation

enum LocalizedStrings: String {
    case mapTitle =  "map_Title"
    case listTitle =  "list_Title"
    case cancel = "cancel"
    case detailed = "detailed"
    case settings = "settings"
    case monday = "monday"
    case tuesday = "tuesday"
    case wednesday = "wednesday"
    case thursday = "thursday"
    case friday = "friday"
    case saturday = "saturday"
    case sunday = "sunday"
    case address = "address"
    case phoneNumber = "phone_Number"
    case type = "type"
    case buildARoute = "build_A_Route"
    case availableServices = "available_Services"
    case cards = "cards"
    case currency = "currency"
    case baseCurrency = "base_Currency"
    case from = "from"
    case to = "to"
    case operatingMode = "operating_mode"
    case access24Hours = "access24Hours"
    case status = "status"
    case working = "working"
    case notWorking = "not_working"
    case disabled = "temp_not_working"
    case atm = "atm"
    case pst = "pst"
    case cashIn = "cashin"
    case infoUnavailable = "info_unavailable"
    case chooseApp = "choose_app"
    case alertRoutingTitle = "alert_routing_title"
    case alertRoutingMessage = "alert_routing_message"
    case alertAccessLocationTitle = "alert_access_location_title"
    case alertAccessLocationMessage = "alert_access_location_message"

    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
