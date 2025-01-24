//
//  JoinCompletedViewController.swift
//  SharedLibraries
//
//  Created by 임대진 on 1/21/25.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class JoinCompletedViewController: BaseViewController {
    
    private var disposeBag = DisposeBag()
    
    private let icon = UIImageView().then {
        $0.image = ImdangImages.Image(resource: .circleCheck64)
        $0.tintColor = .mainOrange500
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "아피트임당 가입 완료"
        $0.font = .pretenBold(24)
        $0.textColor = .grayScale900
        $0.textAlignment = .center
    }
    private let subTitleLabel = UILabel().then {
        $0.font = .pretenMedium(16)
        $0.textColor = .grayScale700
        $0.setTextWithLineHeight(text: "아파트임당은 이런 분들을 위해\n1:1 임장 인사이트 교환 서비스를 제공해요", lineHeight: 22.4)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    private let Label1 = UILabel().then {
        $0.text = "동등한 퀄리티의 인사이트를 공유하고 싶어요"
        $0.font = .pretenMedium(14)
        $0.textColor = .grayScale900
        $0.backgroundColor = .grayScale50
        $0.textAlignment = .center
        
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    private let Label2 = UILabel().then {
        $0.text = "의미있는 인사이트를 공유하고 싶어요"
        $0.font = .pretenMedium(14)
        $0.textColor = .grayScale900
        $0.backgroundColor = .grayScale50
        $0.textAlignment = .center
        
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    private let Label3 = UILabel().then {
        $0.text = "지속적으로 양질의 인사이트 공유를 하고 싶어요"
        $0.font = .pretenMedium(14)
        $0.textColor = .grayScale900
        $0.backgroundColor = .grayScale50
        $0.textAlignment = .center
        
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private let startButton = CommonButton(title: "시작하기", initialButtonType: .enabled)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationViewBottomShadow.isHidden = true
        
        addSubviews()
        makeConstraints()
        bindAction()
    }
    
    private func addSubviews() {
        [icon, titleLabel, subTitleLabel, Label1, Label2, Label3, startButton].forEach { view.addSubview($0) }
    }
    
    private func makeConstraints() {
        
        icon.snp.makeConstraints {
            $0.bottom.equalTo(titleLabel.snp.top).offset(-24)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(64)
        }
        
        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(subTitleLabel.snp.top).offset(-8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(34)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.bottom.equalTo(Label1.snp.top).offset(-40)
            $0.centerX.equalToSuperview()
        }
        
        Label1.snp.makeConstraints {
            $0.top.equalTo(view.snp.centerY).offset(9)
            $0.horizontalEdges.equalToSuperview().inset(38)
            $0.height.equalTo(60)
        }
        
        Label2.snp.makeConstraints {
            $0.top.equalTo(Label1.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(38)
            $0.height.equalTo(60)
        }
        
        Label3.snp.makeConstraints {
            $0.top.equalTo(Label2.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(38)
            $0.height.equalTo(60)
        }
        
        startButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-40)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
    }
    
    private func bindAction() {
        startButton.rx.tap
            .subscribe(onNext: {
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootView(TabBarController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
}
