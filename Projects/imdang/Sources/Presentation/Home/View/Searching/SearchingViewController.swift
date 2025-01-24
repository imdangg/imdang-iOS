//
//  SearchingViewController.swift
//  SharedLibraries
//
//  Created by 임대진 on 11/26/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import RxRelay


class SearchingViewController: UIViewController {
    let searchingViewModel = SearchingViewModel()
    private var disposeBag = DisposeBag()
    private let myInsight = BehaviorRelay<[Insight]>(value: [])
    private let todayInsight = BehaviorRelay<[Insight]>(value: Insight.todayInsight)
    private let topInsight = BehaviorRelay<[Insight]>(value: Insight.topInsight)
    private let currentPage = PublishSubject<Int>()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
        $0.backgroundColor = .white
        $0.register(cell: InsightCollectionCell.self)
        $0.register(cell: EmptyMyInsightCollectionCell.self)
        
        $0.register(header: SearchingSectionHeaderView.self)
        
        $0.register(footer: PagingFooterView.self)
        $0.register(footer: SectionSeparatorView.self)
        
        $0.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "BannerCell")
    }
    
    private let bannerImageView = BannerView()
    private let searchBoxView = SearchBoxView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchingViewModel.loadMyInsight()
            .subscribe { [self] data in
                if let data = data {
                    myInsight.accept(data)
                    collectionView.reloadData()
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func setupCollectionView() {
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        
        view.addSubview(collectionView)
        view.addSubview(searchBoxView)
        
        searchBoxView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBoxView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            switch sectionIndex {
            case 0: return self.createBannerLayout()
            case 1: return self.createFirstSectionLayout()
            case 2: return self.createSecondSectionLayout()
            case 3: return self.createThirdSectionLayout()
            default: return nil
            }
        }
    }
    
    private func createBannerLayout() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(96))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: myInsight.value.isEmpty ? 0 : 32, trailing: 0)
        return section
    }

    private func createFirstSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(myInsight.value.isEmpty ? 72 : 100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(myInsight.value.isEmpty ? 72 : 336))
        
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(77))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let separatorSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(8))
        let separator = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: separatorSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        if myInsight.value.isEmpty {
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 32, trailing: 20)
            header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            separator.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -20, bottom: 0, trailing: -20)
            section.boundarySupplementaryItems = [header, separator]
            return section
        } else {
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 3)
            let section = NSCollectionLayoutSection(group: group)
            
            section.orthogonalScrollingBehavior = .none
            section.contentInsets = NSDirectionalEdgeInsets(top: 24, leading: 20, bottom: 20, trailing: 0)
            header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20)
            separator.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -20, bottom: 0, trailing: 0)
            section.boundarySupplementaryItems = [header, separator]
            return section
        }
    }
    
    private func createSecondSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(271))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(271))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 12

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let separatorSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(8))
        let separator = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: separatorSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 32, trailing: 0)
        header.contentInsets = NSDirectionalEdgeInsets(top: -32, leading: 0, bottom: 0, trailing: 20)
        separator.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: -20, bottom: 0, trailing: 0)

        section.boundarySupplementaryItems = [header, separator]

        return section
    }
    
    private func createThirdSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(336))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 3)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        
        section.visibleItemsInvalidationHandler = { [weak self] _, contentOffset, environment in
            let containerWidth = environment.container.contentSize.width
            let itemWidth = environment.container.contentSize.width
            let pageIndex = Int(max(0, round(contentOffset.x / itemWidth)))

            if containerWidth > 0 {
                self?.currentPage.onNext(pageIndex)
            }
        }

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(6))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
        header.contentInsets = NSDirectionalEdgeInsets(top: -32, leading: 0, bottom: 0, trailing: 20)
        footer.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: -20, bottom: 40, trailing: 0)
        
        section.boundarySupplementaryItems = [header, footer]
        
        return section
    }

}

extension SearchingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return myInsight.value.isEmpty ? 1 : myInsight.value.count > 3 ? 3 : myInsight.value.count
        case 2: return todayInsight.value.count
        case 3: return topInsight.value.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let insightId = myInsight.value[indexPath.row].id
        switch indexPath.section {
        case 1:
            
            searchingViewModel.loadInsightDetail(id: insightId)
                .subscribe { [self] data in
                    if let data = data {
                        let vc = InsightDetailViewController(url: "", state: .done, insight: data)
                        vc.hidesBottomBarWhenPushed = true
                        navigationController?.pushViewController(vc, animated: true)
                    }
                }
                .disposed(by: disposeBag)
        case 2:
            let vc = InsightDetailViewController(url: todayInsight.value[indexPath.row].titleImageUrl, state: todayInsight.value[indexPath.row].state, insight: InsightDetail.testData)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = InsightDetailViewController(url: topInsight.value[indexPath.row].titleImageUrl, state: topInsight.value[indexPath.row].state, insight: InsightDetail.testData)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SearchingSectionHeaderView.reuseIdentifier, for: indexPath) as! SearchingSectionHeaderView
            
            switch indexPath.section {
            case 0:
                return UICollectionReusableView()
            case 1:
                headerView.configure(with: "내가 다녀온 단지의 다른 인사이트", type: .notTopten, showHorizontalCollection: myInsight.value.isEmpty ? false : true)
            case 2:
                headerView.configure(with: "오늘 새롭게 올라온 인사이트", type: .notTopten, showHorizontalCollection: false)
            case 3:
                headerView.configure(with: "추천수 TOP 10 인사이트", type: .topten, showHorizontalCollection: false)
                headerView.bind(input: currentPage.asObservable(), indexPath: indexPath, collectionView: collectionView)
            default:
                return UICollectionReusableView()
            }
            
            return headerView
        } else if kind == UICollectionView.elementKindSectionFooter {
            switch indexPath.section {
            case 0:
                return UICollectionReusableView()
            case 1:
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionSeparatorView.reuseIdentifier, for: indexPath) as! SectionSeparatorView
                return footerView
            case 2:
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionSeparatorView.reuseIdentifier, for: indexPath) as! SectionSeparatorView
                return footerView
            case 3:
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PagingFooterView.reuseIdentifier, for: indexPath) as! PagingFooterView
                footerView.bind(input: currentPage.asObservable(), indexPath: indexPath, collectionView: collectionView)
                return footerView
            default:
                return UICollectionReusableView()
            }
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath)
            cell.addSubview(bannerImageView)
            bannerImageView.snp.makeConstraints { $0.edges.equalToSuperview() }
            return cell
        case 1:
            if myInsight.value.isEmpty {
                let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath, cellType: EmptyMyInsightCollectionCell.self)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath, cellType: InsightCollectionCell.self)
                cell.configure(insight: myInsight.value[indexPath.row], layoutType: .horizontal)
                return cell
            }
        case 2:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath, cellType: InsightCollectionCell.self)
            cell.configure(insight: todayInsight.value[indexPath.row], layoutType: .vertical)
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath, cellType: InsightCollectionCell.self)
            cell.configure(insight: topInsight.value[indexPath.row], layoutType: .horizontal)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}
