//
//  LocationBoxCollectionCell.swift
//  SharedLibraries
//
//  Created by 임대진 on 12/8/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class LocationBoxCollectionCell: UICollectionViewCell {
    static let identifier = "LocationBoxCollectionCell"
    private var pageIndex = 0
    
    private var disposeBag = DisposeBag()
    private let locationImage = UIImageView().then {
        $0.image = ImdangImages.Image(resource: .location).withRenderingMode(.alwaysTemplate)
        $0.tintColor = .white
    }
    
    private let locationnLabel = UILabel().then {
        $0.font = .pretenSemiBold(18)
        $0.textColor = .white
    }
    
    let zoneStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .center
        $0.backgroundColor = .mainOrange400
        
        $0.layer.cornerRadius = 8
    }
    
    let insightStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .center
        $0.backgroundColor = .mainOrange400
        
        $0.layer.cornerRadius = 8
    }
    
    private let zoneLabel = UILabel().then {
        $0.text = "단지"
        $0.font = .pretenMedium(14)
        $0.textColor = .white
    }
    
    private let insightLabel = UILabel().then {
        $0.text = "인사이트"
        $0.font = .pretenMedium(14)
        $0.textColor = .white
    }
    
    private let zoneCountLabel = UILabel().then {
        $0.font = .pretenMedium(14)
        $0.textColor = .white
    }
    
    private let insightCountLabel = UILabel().then {
        $0.font = .pretenMedium(14)
        $0.textColor = .white
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .grayScale100
        self.layer.cornerRadius = 10
        
        addSubview()
        makeConstraints()
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        [zoneLabel, zoneCountLabel].forEach {
            zoneStackView.addSubview($0)
        }
        [insightLabel, insightCountLabel].forEach {
            insightStackView.addSubview($0)
        }
        [locationImage, locationnLabel, zoneStackView, insightStackView].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func makeConstraints() {
        locationImage.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(22.5)
        }
        
        locationnLabel.snp.makeConstraints {
            $0.leading.equalTo(locationImage.snp.trailing).offset(4)
            $0.top.equalToSuperview().offset(20)
        }
        
        zoneStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-20)
            $0.height.equalTo(46)
            $0.trailing.equalTo(self.contentView.snp.centerX).offset(-4)
        }
        
        insightStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview().offset(-20)
            $0.height.equalTo(46)
            $0.leading.equalTo(self.contentView.snp.centerX).offset(4)
        }
        
        zoneLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(13)
            $0.bottom.equalToSuperview().offset(-13)
        }
        
        zoneCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalToSuperview().offset(13)
            $0.bottom.equalToSuperview().offset(-13)
        }
        
        insightLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(13)
            $0.bottom.equalToSuperview().offset(-13)
        }
        
        insightCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalToSuperview().offset(13)
            $0.bottom.equalToSuperview().offset(-13)
        }
    }

    func configure(address: AddressData) {
        locationnLabel.text = address.toAddress()
        zoneCountLabel.text = "\(address.apartmentComplexCount)개"
        insightCountLabel.text = "\(address.insightCount)개"
    }
    
    func bind(input: Observable<Int>, pageIndex: Int) {
        self.pageIndex = pageIndex
        
        input
            .subscribe(onNext: { [weak self] currentPage in
                self?.setTintColor(visiable: pageIndex == currentPage)
            })
            .disposed(by: disposeBag)
    }
    
    func setTintColor(visiable: Bool) {
        UIView.animate(withDuration: 0.15) { [self] in
            if visiable {
                backgroundColor = .mainOrange500
                zoneStackView.backgroundColor = .mainOrange400
                insightStackView.backgroundColor = .mainOrange400
            } else {
                backgroundColor = .grayScale100
                zoneStackView.backgroundColor = .grayScale50
                insightStackView.backgroundColor = .grayScale50
            }
        }
    }
}
