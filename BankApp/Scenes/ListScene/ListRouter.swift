//
//  ListRouter.swift
//  BankApp
//
//  Created by Karina Kovaleva on 29.08.24.
//

import Foundation

protocol ListRoutingLogic {
    func showCalloutViewOnMap(id: Int)
}

class ListRouter: ListRoutingLogic {

    weak var containerViewController: ContainerViewController?
    
    func showCalloutViewOnMap(id: Int) {
        self.containerViewController?.switchToMapViewController(id: id)
    }
}
 
