//
//  ContainerViewController.swift
//  BankApp
//
//  Created by Karina Kovaleva on 2.06.24.
//

import UIKit

class ContainerViewController: UIViewController {
    
    private let mapVC = Configurator.createMapModule()
    private let listVC = Configurator.createListModule()

    private var segmentedControl = UISegmentedControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
     
        self.setupNavigationBar()
        self.setupSegmentedControl()
        self.updateContent()
        self.add(asChildViewController: self.mapVC)
        
        if let listRouter = (listVC as? ListViewController)?.router as? ListRouter {
            listRouter.containerViewController = self
        }
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .systemGreen
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .refresh,
                                                                   target: self,
                                                                   action: #selector(self.updateContent)),
                                                   UIBarButtonItem(title: nil,
                                                                   image: UIImage(systemName: "location.fill"),
                                                                   target: self,
                                                                   action: #selector(self.updateLocation))
        ]
    }
     
    private func setupSegmentedControl() {
        self.segmentedControl = UISegmentedControl(items: [LocalizedStrings.mapTitle.localized,
                                                           LocalizedStrings.listTitle.localized])
        self.segmentedControl.selectedSegmentIndex = 0
        self.navigationItem.titleView = self.segmentedControl
        self.segmentedControl.addTarget(self, action: #selector(self.segmentedControlValueChanged), for: .valueChanged)
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.remove(asChildViewController: self.listVC)
            self.add(asChildViewController: self.mapVC)
            
        } else if sender.selectedSegmentIndex == 1 {
            self.remove(asChildViewController: self.mapVC)
            self.add(asChildViewController: self.listVC)
        }
    }
    
    private func add(asChildViewController vc: UIViewController) {
        self.addChild(vc)
        self.view.addSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vc.view.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            vc.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            vc.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            vc.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        vc.didMove(toParent: self)
    }
    
    private func remove(asChildViewController vc: UIViewController) {
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
    
    func switchToMapViewController(id: Int) {
        self.segmentedControl.selectedSegmentIndex = 0
        self.remove(asChildViewController: self.listVC)
        self.add(asChildViewController: self.mapVC)
        if let mapVc = self.mapVC as? MapViewController {
            mapVc.selectAnnotationForAtm(id: id)
        }
    }
    
    @objc private func updateContent() {
        DataManager.shared.fetchATMs()
    }
    
    @objc private func updateLocation() {
        if let mapVc = self.mapVC as? MapViewController {
            mapVc.mapInteractor?.requestUserLocation()
        }
    }
}
