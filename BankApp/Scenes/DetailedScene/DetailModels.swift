//
//  DetailModels.swift
//  BankApp
//
//  Created by Karina Kovaleva on 27.08.24.
//

import MapKit

enum DetailedModels {
    
    struct Request {
       
    }
    
    struct Response {
        var atm: ATM
        var coordinates: CLLocationCoordinate2D?
    }
    
    struct ViewModel {
        var infoAboutAtm: NSMutableAttributedString
        var coordinates: CLLocationCoordinate2D
        var currentLocationCoordinates: CLLocationCoordinate2D?
    }
}

