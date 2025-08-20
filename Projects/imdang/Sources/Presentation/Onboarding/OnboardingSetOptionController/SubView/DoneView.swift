//
//  DoneView.swift
//  imdang
//
//  Created by daye on 7/28/25.
//

import UIKit
import Lottie
import SnapKit
import Then

final class DoneView: UIView {

    private let animationView = LottieAnimationView().then {
        $0.animation = LottieAnimation.named("WelcomeLottie")
        $0.contentMode = .scaleAspectFill
        $0.loopMode = .playOnce
    }
    
    private let checkImageView = UIImageView().then {
        $0.image = UIImage(named: "circleCheck64")
    }
    
    private let mainLabel = UILabel().then {
        $0.text = "내 취향 설정 완료!"
        $0.font = .pretenBold(24)
        $0.textColor = .grayScale900
        $0.textAlignment = .center
    }
    
    private let subLabel = UILabel().then {
        $0.text = "아파트 임당이 취향에 맞는 정보를\n 큐레이션 해드릴게요!"
        $0.font = .pretenMedium(16)
        $0.textColor = .grayScale500
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {

        backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [checkImageView, mainLabel, subLabel]).then {
            $0.axis = .vertical
            $0.alignment = .center
            $0.spacing = 8
            $0.setCustomSpacing(24, after: checkImageView)
        }
        
        addSubview(stackView)
    
        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        addSubview(animationView)
        animationView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalToSuperview()
            
        }
    }

    func play(completion: ((Bool) -> Void)? = nil) {
        animationView.play { (finished) in
            completion?(finished)
        }
    }
}
