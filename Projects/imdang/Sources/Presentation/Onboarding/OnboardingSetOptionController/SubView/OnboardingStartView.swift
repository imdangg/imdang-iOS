//
//  OnboardingStartView..swift
//  imdang
//
//  Created by daye on 8/16/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class OnboardingStartView: UIView {
    
    let selectedValue = PublishRelay<OnboardingType>()
    let nextButtonTapped = PublishRelay<Void>()
    
    private let disposeBag = DisposeBag()
    private let selectedType = BehaviorRelay<OnboardingType?>(value: nil)
    
    private let startViewTitle = UILabel().then {
        $0.text = "어떤 분야에\n관심 있으신가요?"
        $0.font = .pretenBold(24)
        $0.numberOfLines = 2
        $0.textColor = .grayScale900
        $0.textAlignment = .left
    }
    
    private let liveInButton: UIButton = {
        var config = UIButton.Configuration.filled()

        config.title = "실거주"
        let originalImage = UIImage(resource: .liveIn)
        config.image = originalImage.resized(to: CGSize(width: 32, height: 32))
        
        config.imagePlacement = .top
        config.imagePadding = 7
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .grayScale700
        config.cornerStyle = .small
        config.titleTextAttributesTransformer = .init { incoming in
            var outgoing = incoming
            outgoing.font = .pretenSemiBold(16)
            return outgoing
        }
        let button = UIButton(configuration: config)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.grayScale100.cgColor
        button.layer.cornerRadius = 8
        button.backgroundColor = .white
        return button
    }()
    
    private let gapInvestmentButton: UIButton = {
        var config = UIButton.Configuration.filled()

        config.title = "갭투자"
        let originalImage = UIImage(resource: .gapInvestment)
        config.image = originalImage.resized(to: CGSize(width: 32, height: 32))
         
        config.imagePlacement = .top
        config.imagePadding = 7
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .grayScale700
        config.cornerStyle = .small
        config.titleTextAttributesTransformer = .init { incoming in
            var outgoing = incoming
            outgoing.font = .pretenSemiBold(16)
            return outgoing
        }
        let button = UIButton(configuration: config)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.grayScale100.cgColor
        button.layer.cornerRadius = 8
        button.backgroundColor = .white
        return button
    }()
    
    
    private let nextButton = UIButton(type: .system).then {
        $0.setTitle("다음으로", for: .normal)
        $0.titleLabel?.font = .pretenSemiBold(16)
        $0.layer.cornerRadius = 8
        $0.isEnabled = false
        $0.backgroundColor = .grayScale100
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.grayScale500, for: .disabled)
    }
    
    private lazy var buttonStackView = UIStackView(arrangedSubviews: [liveInButton, gapInvestmentButton]).then {
        $0.axis = .horizontal
        $0.spacing = 5
        $0.distribution = .fillEqually
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [startViewTitle, buttonStackView, nextButton].forEach { addSubview($0) }
        
        startViewTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(150)
            $0.leading.equalToSuperview().inset(20)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(startViewTitle.snp.bottom).offset(84)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        [liveInButton, gapInvestmentButton].forEach { button in
            button.snp.makeConstraints { $0.height.equalTo(158) }
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
    }
    
    // MARK: - Binding
    private func bind() {
    
        liveInButton.rx.tap
            .map { OnboardingType.liveIn }
            .bind(to: selectedType)
            .disposed(by: disposeBag)
            
        gapInvestmentButton.rx.tap
            .map { OnboardingType.gapInvestment }
            .bind(to: selectedType)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(to: nextButtonTapped)
            .disposed(by: disposeBag)
        
        selectedType
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] type in
                guard let self = self else { return }
                
                let isEnabled = (type != nil)
                self.nextButton.isEnabled = isEnabled
                
                UIView.animate(withDuration: 0.3,
                               delay: 0,
                               options: .curveEaseInOut,
                               animations: {
                
                    self.updateButtonSelection(selected: type)
                    self.nextButton.backgroundColor = isEnabled ? .mainOrange500 : .grayScale100
                })
            })
            .disposed(by: disposeBag)
        
        selectedType
            .compactMap { $0 }
            .bind(to: selectedValue)
            .disposed(by: disposeBag)
    }
    
    private func updateButtonSelection(selected type: OnboardingType?) {
        liveInButton.layer.borderColor = (type == .liveIn) ? UIColor.mainOrange300.cgColor : UIColor.grayScale100.cgColor
        liveInButton.backgroundColor = (type == .liveIn) ? .mainOrange50 : .white
        
        gapInvestmentButton.layer.borderColor = (type == .gapInvestment) ? UIColor.mainOrange300.cgColor : UIColor.grayScale100.cgColor
        gapInvestmentButton.backgroundColor = (type == .gapInvestment) ? .mainOrange50 : .white
    }
}
