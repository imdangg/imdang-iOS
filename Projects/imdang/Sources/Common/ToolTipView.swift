//
//  ToolTipView.swift
//  imdang
//
//  Created by 임대진 on 1/24/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

enum ToopTimeType {
    case up, down
}

class ToolTipView: UIView {
    private let disposeBag = DisposeBag()
    private var type: ToopTimeType!
    
    private let dimView = UIButton().then {
        $0.backgroundColor = .clear
    }
    
    private let triangleView = UIImageView().then {
        $0.image = ImdangImages.Image(resource: .triangle)
    }
    
    private let triangleReverseView = UIImageView().then {
        $0.image = ImdangImages.Image(resource: .triangleReverse)
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .pretenMedium(14)
        $0.textAlignment = .center
        $0.textColor = .white
        $0.backgroundColor = .mainOrange500
        
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    init(type: ToopTimeType) {
        self.type = type
        super.init(frame: .zero)
        titleLabel.text = type == .up ? "무료 패스권은 교환소에서 확인할 수 있어요" : "작성 완료 시 인사이트가 바로 업로드돼요"
        
        addSubViews()
        makeConstraints()
        bindActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        [dimView, triangleView, triangleReverseView, titleLabel].forEach { addSubview($0) }
    }
    
    private func makeConstraints() {
        let topPadding = UIDevice.current.haveTouchId ? 70 : 105
        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        if type == .up {
            triangleView.snp.makeConstraints {
                $0.top.equalToSuperview().offset(topPadding)
                $0.leading.equalToSuperview().offset(100)
            }
            
            titleLabel.snp.makeConstraints {
                $0.top.equalTo(triangleView.snp.bottom)
                $0.leading.equalToSuperview().offset(20)
                $0.width.equalTo(267)
                $0.height.equalTo(48)
            }
        } else {
            titleLabel.snp.makeConstraints {
                $0.bottom.equalToSuperview().offset(-116)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(267)
                $0.height.equalTo(48)
            }
            
            triangleReverseView.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom)
                $0.trailing.equalTo(titleLabel.snp.trailing).offset(-20)
            }
        }
    }
    
    private func bindActions() {
        dimView.rx.tap
            .subscribe(onNext: { [weak self] _ in
                if self?.type == .up {
//                    UserdefaultKey.homeToolTip = true
                }
                self?.removeFromSuperview()
            })
            .disposed(by: disposeBag)
    }
}
