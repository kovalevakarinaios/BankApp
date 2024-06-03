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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                                 target: self,
                                                                 action: #selector(self.updateContent))
        self.setupSegmentedControl()
        self.add(asChildViewController: self.mapVC)
    }
    
    private func setupSegmentedControl() {
        self.segmentedControl = UISegmentedControl(items: ["Map", "List"])
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
    
    @objc private func updateContent() {
        // Update Content Function
    }
}
