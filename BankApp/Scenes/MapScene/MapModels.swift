//
//  MapModels.swift
//  BankApp
//
//  Created by Karina Kovaleva on 27.05.24.
//

import Foundation

enum MapModels {
    
    enum ATMEnum {
        
        struct Request {
            
        }
        
        struct Response {
            let atms: [ATM]
        }
        
        struct ViewModel {
            
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
    }
}
