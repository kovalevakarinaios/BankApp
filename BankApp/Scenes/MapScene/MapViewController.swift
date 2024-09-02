//
//  ViewController.swift
//  BankApp
//
//  Created by Karina Kovaleva on 27.05.24.
//

import UIKit
import MapKit

protocol MapDisplayLogic {
    func displayAtms(viewModel: MapModels.ViewModel.AtmsViewModel)
    func displayCurrentLocation(viewModel: MapModels.ViewModel.LocationViewModel)
    func setupAnnotations()
    func selectAnnotationForAtm(id: Int)
    func showAlertController(viewModel: MapModels.ViewModel.LocationAlertControllerViewModel)
}

class MapViewController: UIViewController {
    
    private var viewModel: [MapModels.ViewModel.AtmsViewModel.AtmForMap] = []
    
    var mapInteractor: MapBusinessLogic?
    var router: MapRoutingLogic?
    
    private lazy var map: MKMapView = {
        var map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMap()
        self.mapInteractor?.fetchAtms()
        self.mapInteractor?.requestUserLocation()
    }

    private func setupMap() {
        self.view.addSubview(self.map)
        self.map.delegate = self
        
        NSLayoutConstraint.activate([
            self.map.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.map.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.map.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.map.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    deinit {
        print("MapViewController deinit")
    }
}

extension MapViewController: MapDisplayLogic {

    func displayAtms(viewModel: MapModels.ViewModel.AtmsViewModel) {
        print("Successfull data received")
        self.viewModel = viewModel.atmsForMap
        self.setupAnnotations()
        print(map.annotations.count)
    }
    
    func setupAnnotations() {
        var count = 0
        self.viewModel.forEach { atm in
            
            let annotation = AnnotationAtm(id: atm.id,
                                           name: atm.name,
                                           address: atm.address,
                                           openingHours: atm.openingHours,
                                           atmCurrency: atm.atmCurrency,
                                           coordinate: CLLocationCoordinate2D(latitude: atm.latitude, longitude: atm.longitude))
            count += 1

            self.map.addAnnotation(annotation)
        }
        print(count)
    }
    
    func selectAnnotationForAtm(id: Int) {
        if let annotation = self.map.annotations.first(where: { ($0 as? AnnotationAtm)?.id == id }) {
            self.map.selectAnnotation(annotation, animated: true)
        }
    }
    
    func displayCurrentLocation(viewModel: MapModels.ViewModel.LocationViewModel) {
        let center = CLLocationCoordinate2D(latitude: viewModel.latitude, longitude: viewModel.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: center, span: span)
        self.map.setRegion(region, animated: true)
        self.map.showsUserLocation = true
    }
    
    func showAlertController(viewModel: MapModels.ViewModel.LocationAlertControllerViewModel) {
        let alertController = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: .alert)
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsURL) {
            alertController.addAction(UIAlertAction(title: LocalizedStrings.settings.localized, style: .destructive) { action in
                UIApplication.shared.open(settingsURL)
            })
        }
        alertController.addAction(UIAlertAction(title: LocalizedStrings.cancel.localized, style: .cancel))
        self.present(alertController, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    // Delegate func (when we need adding different types of points
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? AnnotationAtm else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationAtm.identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: AnnotationAtm.identifier)
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.canShowCallout = true
        annotationView?.glyphText = "ATM"
        annotationView?.markerTintColor = .systemGreen
        
        let view = CalloutView(id: annotation.id,
                               name: annotation.name,
                               address: annotation.address,
                               openingHours: annotation.openingHours,
                               atmCurrency: annotation.atmCurrency)
        view.delegate = self
        
        annotationView?.detailCalloutAccessoryView = view
        
        return annotationView
    }
}

extension MapViewController: ButtonTapDelegate {
    func didTapButton(identifier: Int) {
        self.mapInteractor?.saveSelectedItem(identifier: identifier)
        self.router?.showDetailView()
    }
}
