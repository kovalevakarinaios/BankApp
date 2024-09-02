//
//  MapModels.swift
//  BankApp
//
//  Created by Karina Kovaleva on 27.05.24.
//

import MapKit

enum MapModels {
    
    struct Request {
        
    }
    
    struct Response {
        struct AtmsResponse {
            let atms: [ATM]
        }
        struct LocationResponse {
            let location: CLLocation
        }
    }
    
    struct ViewModel {
        struct AtmsViewModel {
            let atmsForMap: [AtmForMap]
            
            struct AtmForMap {
                let id: Int
                let name: String
                let address: String
                let openingHours: String
                let atmCurrency: String
                let latitude: Double
                let longitude: Double
            }
        }
        
        struct LocationViewModel {
            let latitude: CLLocationDegrees
            let longitude: CLLocationDegrees
        }
        
        struct LocationAlertControllerViewModel {
            let title: String
            let message: String
        }
       
    }
}
