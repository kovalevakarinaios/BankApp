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
        let presenter = MapPresenter()
        let interactor = MapInteractor()
        let router = MapRouter()
        
        viewController.mapInteractor = interactor
        viewController.router = router
        router.viewController = viewController
        router.dataStore = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
    
    static func createListModule() -> UIViewController {
        let viewController = ListViewController()
        let presenter = ListPresenter()
        let interactor = ListInteractor()
        let router = ListRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        router.containerViewController = viewController.parent as? ContainerViewController
        interactor.presenter = presenter
        presenter.viewController = viewController
        
        return viewController
    }
    
    static func createDetailModule() -> UIViewController {
        let viewController = DetailedViewController()
        let presenter = DetailedPresenter()
        let interactor = DetailedInteractor()
        let router = DetailedRouter()
        
        viewController.interactor = interactor
        presenter.viewController = viewController
        interactor.presenter = presenter
        viewController.router = router
        router.dataStore = interactor
        router.viewController = viewController
        
        return viewController
    }
}
