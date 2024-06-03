//
//  Configurator.swift
//  BankApp
//
//  Created by Karina Kovaleva on 29.05.24.
//

import UIKit

protocol ConfiguratorProtocol {
    static func createMapModule() -> UIViewController
    static func createListModule() -> UIViewController
}

class Configurator: ConfiguratorProtocol {
    
    static func createMapModule() -> UIViewController {
        let viewController = MapViewController()
        let interactor = MapInteractor()
        let presenter = MapPresenter()
        
        viewController.mapInteractor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
    
    static func createListModule() -> UIViewController {
        let viewController = ListViewController()

        return viewController
    }
}
