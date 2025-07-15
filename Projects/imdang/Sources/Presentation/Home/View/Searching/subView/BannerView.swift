//
//  BannerView.swift
//  imdang
//
//  Created by 임대진 on 12/4/24.
//

import UIKit
import SnapKit

class BannerView: UIView {
    
    private let titleLabel = UILabel().then {
        $0.textColor = .grayScale900
        $0.font = .pretenSemiBold(16)
        $0.numberOfLines = 2
        $0.setTextWithLineHeight(text: "아파트임당은\n왜 인사이트 가이드라인을 제공하나요?", lineHeight: 22.4)
    }
    
    private let imageView = UIImageView().then {
        $0.image = ImdangImages.Image(resource: .blob)
        $0.contentMode = .scaleAspectFill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .mainOrange50
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeConstraints()
    }
    
    private func makeConstraints() {
        self.addSubview(titleLabel)
        self.addSubview(imageView)
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
            $0.width.height.equalTo(56)
        }
    }
}
