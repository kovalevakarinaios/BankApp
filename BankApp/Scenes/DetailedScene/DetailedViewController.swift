//
//  DetailedViewController.swift
//  BankApp
//
//  Created by Karina Kovaleva on 27.08.24.
//

import MapKit

protocol DetailedDisplayLogic: AnyObject {
    func displayInfoAboutAtm(info: DetailedModels.ViewModel)
}

class DetailedViewController: UIViewController {
    
    private var atmLocation: CLLocationCoordinate2D?
    private var currentLocation: CLLocationCoordinate2D?
    
    private lazy var infoLabel: UILabel = {
        var infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.numberOfLines = 0
        return infoLabel
    }()
    
    private lazy var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var routeToAtmButton: UIButton = {
        var routeToAtmButton = UIButton(configuration: self.buttonConfiguration)
        routeToAtmButton.translatesAutoresizingMaskIntoConstraints = false
        routeToAtmButton.addTarget(self, action: #selector(self.routeToAtmButtonTapped), for: .touchUpInside)
        return routeToAtmButton
    }()
    
    private lazy var buttonConfiguration: UIButton.Configuration = {
        var buttonConfiguration = UIButton.Configuration.borderedProminent()
        buttonConfiguration.buttonSize = .large
        buttonConfiguration.title = LocalizedStrings.buildARoute.localized
        buttonConfiguration.baseBackgroundColor = .systemGreen
        buttonConfiguration.baseForegroundColor = .systemBackground
        return buttonConfiguration
    }()
    
    var router: DetailDataPassing?
    var interactor: DetailedBussinessLogic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.interactor?.fetchAtm()
        self.setupLayout()
    }
    
    private func setupLayout() {
        self.view.addSubview(self.routeToAtmButton)
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.infoLabel)
        
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.routeToAtmButton.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            
            self.routeToAtmButton.topAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.routeToAtmButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            self.routeToAtmButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            self.routeToAtmButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            
            self.infoLabel.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.infoLabel.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.infoLabel.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.infoLabel.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.infoLabel.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
    }
    
    
    @objc private func routeToAtmButtonTapped() {
    
        guard let atmLocation = atmLocation else { return }
        guard let currentLocation = currentLocation else {
            let alertController = UIAlertController(title: LocalizedStrings.alertRoutingTitle.localized,
                                                    message: LocalizedStrings.alertRoutingMessage.localized,
                                                    preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: LocalizedStrings.settings.localized, style: .destructive) { action in
                
            })
            
            alertController.addAction(UIAlertAction(title: LocalizedStrings.cancel.localized, style: .cancel))
            
            self.present(alertController, animated: true)
            
            return
        }
        
        let alertController = UIAlertController(title: LocalizedStrings.chooseApp.localized, message: nil, preferredStyle: .actionSheet)
        
        let appleMapsURL = URL(string: "maps://?saddr=\(currentLocation.latitude),\(currentLocation.longitude)&daddr=\(atmLocation.latitude),\(atmLocation.longitude)")!
        
        if UIApplication.shared.canOpenURL(appleMapsURL) {
            alertController.addAction(UIAlertAction(title: "Apple Maps", style: .default, handler: { action in
                UIApplication.shared.open(appleMapsURL)
            }))
        }
      
        let googleMapsURL = URL(string: "comgooglemaps://")!
        
        if UIApplication.shared.canOpenURL(googleMapsURL) {
            alertController.addAction(UIAlertAction(title: "Google Maps", style: .default, handler: { action in
                UIApplication.shared.open(googleMapsURL)
            }))
        }
        
        let yandexMapsURL = URL(string: "yandexmaps://build_route_on_map/?lat_from=\(currentLocation.latitude)&lon_from=\(currentLocation.longitude)&lat_to=\(atmLocation.latitude)&lon_to=\(atmLocation.longitude)")!
        
        if UIApplication.shared.canOpenURL(yandexMapsURL) {
            alertController.addAction(UIAlertAction(title: "Yandex Maps", style: .default, handler: { action in
                UIApplication.shared.open(yandexMapsURL)
            }))
        }
        
        alertController.addAction(UIAlertAction(title: LocalizedStrings.cancel.localized, style: .cancel))
        
        self.present(alertController, animated: true)
    }
}

extension DetailedViewController: DetailedDisplayLogic {
    func displayInfoAboutAtm(info: DetailedModels.ViewModel) {
        self.infoLabel.attributedText = info.infoAboutAtm
        self.atmLocation = info.coordinates
        self.currentLocation = info.currentLocationCoordinates
    }
}
