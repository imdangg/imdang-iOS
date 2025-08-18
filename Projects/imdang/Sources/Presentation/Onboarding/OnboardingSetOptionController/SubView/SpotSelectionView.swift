//
//  SpotSelectionView.swift
//  imdang
//
//  Created by daye on 8/16/25.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

final class SpotSelectionHeaderView: UICollectionReusableView {
    static let identifier = "SpotSelectionHeaderView"
    
    private let titleLabel = UILabel().then {
        $0.text = "관심동네가 있으신가요?"
        $0.font = .pretenBold(24)
        $0.textColor = .grayScale800
        $0.numberOfLines = 0
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "*최대 3개까지 고를 수 있어요"
        $0.font = .pretenMedium(18)
        $0.textColor = .grayScale500 //디자인셋에 없음
    }
    
    private let spotTitle = UILabel().then {
        $0.text = "서울"
        $0.font = .pretenMedium(18)
        $0.textColor = .grayScale900
    }
    
    private let divider = UIView().then {
        $0.backgroundColor = .grayScale50
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [titleLabel, subtitleLabel, spotTitle, divider].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        spotTitle.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(25)
            $0.leading.equalToSuperview().inset(20)
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(spotTitle.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class SpotSelectionView: UIView {
    
    private let disposeBag = DisposeBag()
    private var spots: [String] = []
    private var selectedSpots: Set<String> = [] {
        didSet {
            let isEnabled = !selectedSpots.isEmpty
            nextButton.isEnabled = isEnabled
            nextButton.backgroundColor = isEnabled ? .mainOrange500 : .grayScale100
        }
    }
    
    let nextButtonTapped = PublishRelay<[String]>()
    let skipButtonTapped = PublishRelay<Void>()
    
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 10
        layout.headerReferenceSize = CGSize(width: self.frame.width, height: 181)
       
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.identifier)
        collectionView.register(SpotSelectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SpotSelectionHeaderView.identifier)
        
        return collectionView
    }()
    
    private let nextButton = UIButton(type: .system).then {
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = .pretenBold(16)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .grayScale100
        $0.layer.cornerRadius = 8
        $0.isEnabled = false
    }
    
    private let skipButton = UIButton(type: .system).then {
        $0.setTitle("건너뛰기", for: .normal)
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .font: UIFont.pretenSemiBold(16),
            .foregroundColor: UIColor.grayScale500
        ]
        let attributedTitle = NSAttributedString(string: "건너뛰기", attributes: attributes)
        $0.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.spots = ["종로구", "서대문구", "중구", "마포구", "용산구", "양천구", "성동구", "강서구", "광진구", "구로구", "동대문구", "금천구", "중랑구", "영등포구", "성북구", "동작구", "강북구", "관악구", "도봉구"]
        setupUI()
        bindActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        [collectionView, nextButton, skipButton].forEach {
            addSubview($0)
        }
        
        skipButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaLayoutGuide).offset(-10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(skipButton.snp.top).offset(-8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(54)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(1)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top).offset(-20)
        }
    }
    
    private func bindActions() {
        nextButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.nextButtonTapped.accept(Array(owner.selectedSpots))
            })
            .disposed(by: disposeBag)
            
        skipButton.rx.tap
            .map { () }
            .bind(to: skipButtonTapped)
            .disposed(by: disposeBag)
    }
}

extension SpotSelectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SpotSelectionHeaderView.identifier, for: indexPath) as? SpotSelectionHeaderView else {
                return UICollectionReusableView()
            }
            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return spots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.identifier, for: indexPath) as? ItemCell else {
            return UICollectionViewCell()
        }
        let spotName = spots[indexPath.item]
        cell.configure(with: spotName)
        cell.isSelectedItem = selectedSpots.contains(spotName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedSpot = spots[indexPath.item]
        
        if selectedSpots.contains(selectedSpot) {
            selectedSpots.remove(selectedSpot)
        } else {
            if selectedSpots.count < 3 {
                selectedSpots.insert(selectedSpot)
            }
        }
        
        collectionView.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10
        let width = (collectionView.frame.width - spacing) / 2
        return CGSize(width: width, height: 40)
    }
    
}
