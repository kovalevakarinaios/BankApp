//
//  MapInteractor.swift
//  BankApp
//
//  Created by Karina Kovaleva on 27.05.24.
//

import MapKit

protocol MapBusinessLogic {
    func fetchAtms()
    func saveSelectedItem(identifier: Int)
    func requestUserLocation()
}

protocol MapDataStore {
    var atms: [ATM] { get set }
    var atmDataStore: ATM? { get set }
    var location: CLLocationCoordinate2D? { get set }
    var id: Int? { get set }
}

class MapInteractor: NSObject, MapBusinessLogic, MapDataStore {

    var atms: [ATM] = []
    var atmDataStore: ATM?
    var presenter: MapPresenterLogic?
    var locationManager = CLLocationManager()
    var location: CLLocationCoordinate2D?
    var id: Int?
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchAtms), name: .didUpdateATMs, object: nil)
    }
    
    @objc func fetchAtms() {
        self.atms = DataManager.shared.sharedData
        self.presenter?.prepareDataForDisplay(atms: MapModels.Response.AtmsResponse(atms: self.atms))
    }
    
    func saveSelectedItem(identifier: Int) {
        for atm in atms {
            if String(identifier) == atm.atmID {
                self.atmDataStore = atm
                break
            }
        }
    }
    
    func requestUserLocation() {
        self.locationManager.delegate = self
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.requestLocation()
        case .restricted, .denied:
            self.presenter?.prepareInfoAboutAccessToLocation()
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationManager.requestLocation()
        @unknown default:
            break
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


extension MapInteractor: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.presenter?.prepareLocationForDisplay(location: MapModels.Response.LocationResponse(location: location))
            self.location = location.coordinate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
    }
}
