//
//  StorageBoxEmptyViewController.swift
//  imdang
//
//  Created by 임대진 on 2/2/25.
//

import UIKit
import SnapKit
import Then
import RxSwift

class StorageBoxEmptyViewController: BaseViewController {
    private var disposeBag = DisposeBag()
    private let navigationTitleButton = UILabel().then {
        $0.text = "보관함"
        $0.textColor = .grayScale900
        $0.font = .pretenBold(24)
    }
    
    private let mapButton = ImageTextButton(type: .imageFirst, horizonPadding: 8, spacing: 4).then {
        $0.customImage.image = ImdangImages.Image(resource: .mapButtonGray)
        $0.customText.text = "지도"
        $0.customText.font = .pretenMedium(12)
        $0.customText.textColor = .grayScale700
        
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grayScale200.cgColor
    }
    
    private let backView = UIView()
    
    private let icon = UIImageView().then {
        $0.image = ImdangImages.Image(resource: .emptyInsight76)
    }
    
    private let label = UILabel().then {
        $0.font = .pretenRegular(18)
        $0.textColor = .grayScale500
        $0.numberOfLines = 0
        $0.setTextWithLineHeight(text: "추천 또는 작성한 인사이트가 없어요.\n양질의 인사이트를 추천하고 관리해보세요", lineHeight: 25.2, textAlignment: .center)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setNavigationItem()
        addSubviews()
        makeConstraints()
        
        mapButton.rx.tap
            .subscribe(with: self) { owner, _ in
                let vc = MapViewController()
                vc.config(type: .storage)
                vc.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func setNavigationItem() {
        leftNaviItemView.addSubview(navigationTitleButton)
        rightNaviItemView.addSubview(mapButton)
        
        navigationTitleButton.snp.makeConstraints {
            $0.height.equalTo(34)
            $0.width.equalTo(83)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        mapButton.snp.makeConstraints {
            $0.width.equalTo(57)
            $0.height.equalTo(32)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
    
    private func addSubviews() {
        [icon, label].forEach { backView.addSubview($0) }
        [backView].forEach { view.addSubview($0) }
    }
    
    private func makeConstraints() {
        icon.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(icon.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        backView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(46)
        }
    }
}
