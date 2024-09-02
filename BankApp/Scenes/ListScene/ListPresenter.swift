//
//  ListPresenter.swift
//  BankApp
//
//  Created by Karina Kovaleva on 3.06.24.
//

import Foundation

protocol ListPresenterLogic {
    func prepareDataForDisplay(response: ListModels.Response)
}

class ListPresenter: ListPresenterLogic {
    
    weak var viewController: ListDisplayLogic?
    
    func prepareDataForDisplay(response: ListModels.Response) {
        var viewModel: [ListModels.ViewModel.Section] = []
        
        let cities = Set(response.atms.map { $0.address.townName }).sorted()
        
        for city in cities {
            let items = response.atms.filter { $0.address.townName == city }
            var updatedItems: [ListModels.ViewModel.AtmForViewModel]  = []
            for item in items {
                if let id = Int(item.atmID) {
                    let atm = ListModels.ViewModel.AtmForViewModel(id: id,
                                                                   name: item.address.addressLine,
                                                                   address: Helper.createAddress(atm: item))
                    updatedItems.append(atm)
                }
            }
            let atms = ListModels.ViewModel.Section(cityName: city, atms: updatedItems)
            viewModel.append(atms)
        }

        self.viewController?.displayAtms(viewModel: ListModels.ViewModel(sectionsWithAtms: viewModel))
    }
}
