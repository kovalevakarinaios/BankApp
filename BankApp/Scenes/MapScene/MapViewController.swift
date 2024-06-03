//
//  ViewController.swift
//  BankApp
//
//  Created by Karina Kovaleva on 27.05.24.
//

import UIKit
import MapKit

protocol MapDisplayLogic {
    func displayAtms(viewModel: MapModels.ATMEnum.ViewModel)
    func setupAnnotations()
}

class MapViewController: UIViewController {
    
    private var viewModel: [MapModels.ATMEnum.ViewModel.AtmForMap] = []
    
    var mapInteractor: MapBusinessLogic?
    
    private lazy var map: MKMapView = {
        var map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMap()
        self.mapInteractor?.fetchAtms()
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
    
    func displayAtms(viewModel: MapModels.ATMEnum.ViewModel) {
        print("Successfull data received")
        self.viewModel = viewModel.atmsForMap
        self.setupAnnotations()
    }
    
    func setupAnnotations() {
        self.viewModel.forEach { atm in
            let annotation = AnnotationAtm(id: atm.id,
                                           name: atm.name,
                                           address: atm.address,
                                           openingHours: atm.openingHours,
                                           atmCurrency: atm.atmCurrency,
                                           coordinate: CLLocationCoordinate2D(latitude: atm.latitude, longitude: atm.longitude))
            self.map.addAnnotation(annotation)
        }
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
        annotationView?.detailCalloutAccessoryView = CalloutView(name: annotation.name,
                                                                 address: annotation.address,
                                                                 openingHours: annotation.openingHours,
                                                                 atmCurrency: annotation.atmCurrency)
        
        return annotationView
    }
}
