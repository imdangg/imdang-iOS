//
//  InsightProgressBar.swift
//  imdang
//
//  Created by 임대진 on 1/24/25.
//

import UIKit
import Then
import SnapKit

final class InsightProgressBar: UIView {
    var currentIndex = 0
    
    private var circle1 = UIImageView().then {
        $0.image = ImdangImages.Image(resource: .progressCircle)
        $0.contentMode = .scaleAspectFit
        $0.tag = 0
    }
    private var circle2 = UIImageView().then {
        $0.image = ImdangImages.Image(resource: .grayCircle)
        $0.contentMode = .scaleAspectFit
        $0.tag = 1
    }
    private var circle3 = UIImageView().then {
        $0.image = ImdangImages.Image(resource: .grayCircle)
        $0.contentMode = .scaleAspectFit
        $0.tag = 2
    }
    private var circle4 = UIImageView().then {
        $0.image = ImdangImages.Image(resource: .grayCircle)
        $0.contentMode = .scaleAspectFit
        $0.tag = 3
    }
    private var circle5 = UIImageView().then {
        $0.image = ImdangImages.Image(resource: .grayCircle)
        $0.contentMode = .scaleAspectFit
        $0.tag = 4
    }
    
    private var stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
    }
    
    private var stick1 = UIView().then {
        $0.backgroundColor = .grayScale200
        $0.tag = 0
    }
    private var stick2 = UIView().then {
        $0.backgroundColor = .grayScale200
        $0.tag = 1
    }
    private var stick3 = UIView().then {
        $0.backgroundColor = .grayScale200
        $0.tag = 2
    }
    private var stick4 = UIView().then {
        $0.backgroundColor = .grayScale200
        $0.tag = 3
    }
    
    private var label1 = UILabel().then {
        $0.text = "기본정보"
        $0.textColor = .mainOrange500
        $0.font = .pretenSemiBold(12)
        $0.tag = 0
    }
    private var label2 = UILabel().then {
        $0.text = "인프라"
        $0.textColor = .grayScale300
        $0.font = .pretenSemiBold(12)
        $0.tag = 1
    }
    private var label3 = UILabel().then {
        $0.text = "단지환경"
        $0.textColor = .grayScale300
        $0.font = .pretenSemiBold(12)
        $0.tag = 2
    }
    private var label4 = UILabel().then {
        $0.text = "단지시설"
        $0.textColor = .grayScale300
        $0.font = .pretenSemiBold(12)
        $0.tag = 3
    }
    private var label5 = UILabel().then {
        $0.text = "호재"
        $0.textColor = .grayScale300
        $0.font = .pretenSemiBold(12)
        $0.tag = 4
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        [circle1, circle2, circle3, circle4, circle5].forEach { stackView.addArrangedSubview($0) }
        [stackView, stick1, stick2, stick3, stick4, label1, label2, label3, label4, label5].forEach { addSubview($0) }
    }
    
    private func makeConstraints() {
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-37)
        }
        
        [circle1, circle2, circle3, circle4, circle5].forEach {
            $0.snp.makeConstraints {
                $0.width.height.equalTo(16)
            }
        }
        
        stick1.snp.makeConstraints {
            $0.leading.equalTo(circle1.snp.trailing).offset(4)
            $0.centerY.equalTo(circle1.snp.centerY)
            $0.trailing.equalTo(circle2.snp.leading).offset(-4)
            $0.height.equalTo(1)
        }
        
        stick2.snp.makeConstraints {
            $0.leading.equalTo(circle2.snp.trailing).offset(4)
            $0.centerY.equalTo(circle1.snp.centerY)
            $0.trailing.equalTo(circle3.snp.leading).offset(-4)
            $0.height.equalTo(1)
        }
        
        stick3.snp.makeConstraints {
            $0.leading.equalTo(circle3.snp.trailing).offset(4)
            $0.centerY.equalTo(circle1.snp.centerY)
            $0.trailing.equalTo(circle4.snp.leading).offset(-4)
            $0.height.equalTo(1)
        }
        
        stick4.snp.makeConstraints {
            $0.leading.equalTo(circle4.snp.trailing).offset(4)
            $0.centerY.equalTo(circle1.snp.centerY)
            $0.trailing.equalTo(circle5.snp.leading).offset(-4)
            $0.height.equalTo(1)
        }
        
        label1.snp.makeConstraints {
            $0.top.equalTo(circle1.snp.bottom).offset(4)
            $0.leading.equalTo(circle1.snp.leading)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        label2.snp.makeConstraints {
            $0.centerX.equalTo(circle2.snp.centerX)
            $0.centerY.equalTo(label1.snp.centerY)
        }
        
        label3.snp.makeConstraints {
            $0.centerX.equalTo(circle3.snp.centerX)
            $0.centerY.equalTo(label1.snp.centerY)
        }
        
        label4.snp.makeConstraints {
            $0.centerX.equalTo(circle4.snp.centerX)
            $0.centerY.equalTo(label1.snp.centerY)
        }
        
        label5.snp.makeConstraints {
            $0.centerY.equalTo(label1.snp.centerY)
            $0.trailing.equalTo(circle5.snp.trailing)
        }
    }
    
    func setProgress(index: Int) {
        [circle1, circle2, circle3, circle4, circle5].forEach {
            if index - 1 >= 0 && $0.tag == index - 1 {
                $0.image = ImdangImages.Image(resource: .progressCheck)
            }
            
            if $0.tag == index {
                $0.image = ImdangImages.Image(resource: .progressCircle)
            }
            
            if index + 1 < 5 && $0.tag == index + 1 {
                $0.image = ImdangImages.Image(resource: .grayCircle)
            }
        }
        
        [label1, label2, label3, label4, label5].forEach {
            if index - 1 >= 0 && $0.tag == index - 1 {
                $0.textColor = .grayScale200
            }
            
            if $0.tag == index {
                $0.textColor = .mainOrange500
            }
            
            if index + 1 < 5 && $0.tag == index + 1 {
                $0.textColor = .grayScale200
            }
            
        }
        
        [stick1, stick2, stick3, stick4].forEach { stick in
            if index - 1 >= 0 && stick.tag == index - 1 {
                UIView.animate(withDuration: 0.3) {
                    stick.backgroundColor = .mainOrange500
                }
            }
            
            if stick.tag == index {
                stick.backgroundColor = .grayScale200
            }
        }
    }
}

