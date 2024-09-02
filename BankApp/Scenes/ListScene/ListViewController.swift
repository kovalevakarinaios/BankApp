//
//  ListViewController.swift
//  BankApp
//
//  Created by Karina Kovaleva on 2.06.24.
//

import UIKit

protocol ListDisplayLogic: AnyObject {
    func displayAtms(viewModel: ListModels.ViewModel)
}

class ListViewController: UIViewController {
    
    var router: ListRoutingLogic?

    private var dataSource: UICollectionViewDiffableDataSource<ListModels.ViewModel.Section, ListModels.ViewModel.AtmForViewModel>?
    
    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    private lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.register(CardCell.self, forCellWithReuseIdentifier: CardCell.identifier)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.identifier)
        return collectionView
    }()

    private var sectionsWithAtms: [ListModels.ViewModel.Section] = []
    
    var interactor: ListBusinnessLogic?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.configureDataSource()
        self.interactor?.fetchAtms()
    }
    
    private func setupCollectionView() {

        self.view.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}

//MARK: - Collection View Setup
extension ListViewController {
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(self.view.frame.height / 10))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(self.view.frame.height / 20))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        header.pinToVisibleBounds = true
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configureDataSource() {

        self.dataSource = UICollectionViewDiffableDataSource<ListModels.ViewModel.Section, ListModels.ViewModel.AtmForViewModel>(collectionView: self.collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: ListModels.ViewModel.AtmForViewModel) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.identifier, for: indexPath) as? CardCell else { return nil }
            cell.configureCell(name: itemIdentifier.name, address: itemIdentifier.address)
            return cell
        }
        
        self.dataSource?.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            if kind == UICollectionView.elementKindSectionHeader {
                guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.identifier, for: indexPath) as? HeaderView else { return nil }
                let citySection = self.dataSource?.snapshot().sectionIdentifiers[indexPath.section]
                headerView.setText(city: citySection?.cityName ?? LocalizedStrings.infoUnavailable.localized)
                return headerView
            }
            return nil
        }
        
        self.applySnapshot()
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<ListModels.ViewModel.Section, ListModels.ViewModel.AtmForViewModel>()
     
        snapshot.appendSections(sectionsWithAtms)
        
        for section in sectionsWithAtms {
            snapshot.appendItems(section.atms, toSection: section)
        }
        
        self.dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension ListViewController: ListDisplayLogic {
    func displayAtms(viewModel: ListModels.ViewModel) {
        self.sectionsWithAtms = viewModel.sectionsWithAtms
        DispatchQueue.main.async {
            self.applySnapshot()
        }
    } 
}

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.router?.showCalloutViewOnMap(id: self.sectionsWithAtms[indexPath.section].atms[indexPath.row].id)
    }
}
