//
//  InsightCategoryTapView.swift
//  imdang
//
//  Created by 임대진 on 1/8/25.
//
import UIKit
import Then
import SnapKit
import RxSwift
import RxRelay

final class InsightDetailCategoryTapView: UIView {
    let selectedIndex = BehaviorRelay<Int?>(value: nil)
    let setCurrentIndex = BehaviorRelay<Int?>(value: nil)
    private var disposeBag = DisposeBag()
    private let buttonTitles = ["기본 정보", "인프라", "단지 환경"]

    private let buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 24
        $0.alignment = .center
        $0.distribution = .fill
    }

    private let selectTabUnderLineView = UIView().then {
        $0.backgroundColor = .grayScale900
    }
    
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.borderColor = UIColor.grayScale100.cgColor
        self.layer.borderWidth = 1
        
        addSubviews()
        makeConstraints()
        setupButtons()
        setupUI()
        
        selectedIndex
            .compactMap { $0 }
            .distinctUntilChanged()
            .subscribe(with: self, onNext: { owner, index in
                owner.setupUI(index: index)
            })
            .disposed(by: disposeBag)
        
        setCurrentIndex
            .compactMap { $0 }
            .distinctUntilChanged()
            .subscribe(with: self, onNext: { owner, index in
                owner.setupUI(index: index)
            })
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        [buttonStackView, selectTabUnderLineView].forEach { addSubview($0) }
    }
    
    private func makeConstraints() {
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.horizontalEdges.equalToSuperview().inset(20).priority(999)
            $0.height.equalTo(40)
        }

        selectTabUnderLineView.snp.makeConstraints {
            $0.bottom.equalTo(buttonStackView.snp.bottom)
            $0.height.equalTo(3)
            $0.width.equalTo(0)
            $0.leading.equalToSuperview()
        }
    }
    
    private func setupButtons() {
        buttonTitles.enumerated().forEach { index, title in
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.setTitleColor(index == selectedIndex.value ? .grayScale900 : .grayScale500, for: .normal)
            button.titleLabel?.font = .pretenSemiBold(14)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.minimumScaleFactor = 0.8
            button.titleLabel?.lineBreakMode = .byTruncatingTail
            button.tag = index

            button.addTarget(self, action: #selector(didTapTabButton(_:)), for: .touchUpInside)
            buttonStackView.addArrangedSubview(button)
        }
        
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        buttonStackView.addArrangedSubview(spacer)
    }
    
    private func getButton(at index: Int) -> UIButton? {
        return buttonStackView.arrangedSubviews[index] as? UIButton
    }

    @objc private func didTapTabButton(_ sender: UIButton) {
        selectedIndex.accept(sender.tag)
        setupUI(index: sender.tag)
    }
    
    private func setupUI(index: Int = 0) {
        for (i, button) in buttonStackView.arrangedSubviews.enumerated() {
            if let btn = button as? UIButton {
                btn.setTitleColor(i == index ? .grayScale900 : .grayScale500, for: .normal)
            }
        }

        if let button = getButton(at: index) {
            self.updateUnderlinePosition(for: button)
        }
    }
    
    private func updateUnderlinePosition(for button: UIButton) {
        selectTabUnderLineView.snp.remakeConstraints {
            $0.bottom.equalTo(buttonStackView)
            $0.height.equalTo(3)
            $0.width.equalTo(button.titleLabel?.intrinsicContentSize.width ?? 0)
            $0.centerX.equalTo(button)
        }
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    
}
