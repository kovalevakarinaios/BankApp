//
//  AnnotationAtm.swift
//  BankApp
//
//  Created by Karina Kovaleva on 3.06.24.
//

import MapKit

class AnnotationAtm: NSObject, MKAnnotation {
    
    static let identifier = "AnnotationAtm"
    let id: Int
    let name: String
    let address: String
    let openingHours: String
    let atmCurrency: String
    let coordinate: CLLocationCoordinate2D
    
    init(id: Int, name: String, address: String, openingHours: String, atmCurrency: String, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.name = name
        self.address = address
        self.openingHours = openingHours
        self.atmCurrency = atmCurrency
        self.coordinate = coordinate
    }
}
