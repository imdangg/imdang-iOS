//
//  NextAndBackButton.swift.swift
//  SharedLibraries
//
//  Created by 임대진 on 1/18/25.
//

import UIKit
import SnapKit
import Then

final class NextAndBackButton: UIView {
    private let backgroundView = UIView().then {
        $0.backgroundColor = .white
        $0.applyTopBlur()
        $0.layer.cornerRadius = 8
    }
    
    let backButton = UIButton().then {
        $0.setTitle("이전", for: .normal)
        $0.backgroundColor = .grayScale100
        $0.titleLabel?.font = .pretenSemiBold(16)
        $0.setTitleColor(.grayScale500, for: .normal)
        
        $0.layer.cornerRadius = 8
    }
    
    let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.backgroundColor = .grayScale100
        $0.titleLabel?.font = .pretenSemiBold(16)
        $0.setTitleColor(.grayScale500, for: .normal)
        
        $0.layer.cornerRadius = 8
    }
    
    var isEnable = false
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        [backgroundView, backButton, nextButton].forEach { addSubview($0) }
    }
    
    func config(needBack: Bool, title: String? = nil) {
        
        if let title = title {
            nextButton.setTitle(title, for: .normal)
        }
        
        backgroundView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.verticalEdges.equalToSuperview()
        }
        
        if needBack {
            backButton.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(20)
                $0.top.equalTo(backgroundView.snp.top)
                $0.trailing.equalTo(super.snp.centerX).offset(-5)
                $0.height.equalTo(56)
            }
            
            nextButton.snp.makeConstraints {
                $0.leading.equalTo(super.snp.centerX).offset(5)
                $0.trailing.equalToSuperview().offset(-20)
                $0.top.equalTo(backgroundView.snp.top)
                $0.height.equalTo(56)
            }
        } else {
            nextButton.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview().inset(20)
                $0.top.equalTo(backgroundView.snp.top)
                $0.height.equalTo(56)
            }
        }
    }
    
    func nextButtonEnable(value: Bool) {
        isEnable = value
        
        if isEnable {
            nextButton.backgroundColor = .mainOrange500
            nextButton.layer.borderWidth = 0
            nextButton.setTitleColor(.white, for: .normal)
        } else {
            nextButton.backgroundColor = .grayScale100
            nextButton.layer.borderWidth = 0
            nextButton.setTitleColor(.grayScale500, for: .normal)
        }
    }
}
