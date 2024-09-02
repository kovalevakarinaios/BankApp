//
//  ListModels.swift
//  BankApp
//
//  Created by Karina Kovaleva on 3.06.24.
//

enum ListModels {
    
    struct Request {
        
    }
    
    struct Response {
        let atms: [ATM]
    }
    
    struct ViewModel {
        let sectionsWithAtms: [Section]
        
        struct AtmForViewModel: Hashable {
            let id: Int
            let name: String
            let address: String
        }
        
        struct Section: Hashable {
            let cityName: String
            let atms: [AtmForViewModel]
        }
    }
}
