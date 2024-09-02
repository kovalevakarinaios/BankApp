//
//  DeetailedRouter.swift
//  BankApp
//
//  Created by Karina Kovaleva on 27.08.24.
//

import Foundation

protocol DetailDataPassing {
    var dataStore: DetailedDataStore? { get set }
}


class DetailedRouter: DetailDataPassing {
    
    weak var viewController: DetailedDisplayLogic?
    var dataStore: DetailedDataStore?
    
}
