//
//  NewView.swift
//  imdang
//
//  Created by daye on 7/28/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa


final class PrioritySettingView: UIView {
    
    let priorityButtonTapped = PublishRelay<Int>()
    let nextButtonTapped = PublishRelay<Void>()
    let skipButtonTapped = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    private let titleLabel = UILabel().then {
        $0.text = "임장 우선순위를 골라주세요!"
        $0.font = .pretenBold(24)
        $0.textColor = .grayScale800
        $0.numberOfLines = 0
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "1,2,3위를 기준으로 컨텐츠를 추천해드려요."
        $0.font = .pretenMedium(18)
        $0.textColor = .grayScale500
    }

    private let priorityStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 24
    }
    
    private let nextButton = UIButton(type: .system).then {
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = .pretenSemiBold(16)
        $0.layer.cornerRadius = 8
        $0.isEnabled = false
        $0.backgroundColor = .grayScale100
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.grayScale500, for: .disabled)
    }
    
    private let skipButton = UIButton(type: .system).then {
        $0.setTitle("건너뛰기", for: .normal)
        $0.titleLabel?.font = .pretenSemiBold(16)
        $0.setTitleColor(.grayScale600, for: .normal)
    }
    
    private var priorityViews: [Int: PrioritySelectionView] = [:]
    private var selectionStates: [Int: Bool] = [1: false, 2: false, 3: false]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
        bind()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupUI() {
        (1...3).forEach { index in
            let priorityView = PrioritySelectionView(title: "\(index)위")
            priorityView.selectionButton.tag = index
            priorityStackView.addArrangedSubview(priorityView)
            priorityViews[index] = priorityView
        }
        
        [titleLabel, subtitleLabel, priorityStackView, nextButton, skipButton].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        priorityStackView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        skipButton.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(10)
            $0.centerX.equalToSuperview()
        }
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(skipButton.snp.top).offset(-10)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
    }
    
    private func bind() {
        priorityViews.values.forEach { priorityView in
            priorityView.selectionButton.rx.tap
                .map { priorityView.selectionButton.tag }
                .bind(to: priorityButtonTapped)
                .disposed(by: disposeBag)
        }
        nextButton.rx.tap.bind(to: nextButtonTapped).disposed(by: disposeBag)
        skipButton.rx.tap.bind(to: skipButtonTapped).disposed(by: disposeBag)
    }
    
    func updatePriority(priority: Int, category: String, item: String) {
        guard let targetView = priorityViews[priority] else { return }
        targetView.updateAsSelected(category: category, item: item)
        selectionStates[priority] = true
        checkNextButtonState()
    }
    
    private func checkNextButtonState() {
        let allSelected = selectionStates.values.allSatisfy { $0 == true }
        nextButton.isEnabled = allSelected
        nextButton.backgroundColor = allSelected ? .mainOrange500 : .grayScale100
    }
}


final class PrioritySelectionView: UIView {
    
    let selectionButton = UIButton().then {
        $0.backgroundColor = .grayScale25
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grayScale120.cgColor
        $0.layer.cornerRadius = 8
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .pretenSemiBold(18)
    }
    
    init(title: String) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        setupUI()
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(selectionButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        selectionButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
    
    private func setupButton() {
        resetToDefault()
    }

    func updateAsSelected(category: String, item: String) {
        var config = UIButton.Configuration.filled()
        
        config.title = "\(category) > \(item)"
        config.baseBackgroundColor = .grayScale25
        config.baseForegroundColor = .mainOrange500
        config.titleTextAttributesTransformer = .init { incoming in
            var outgoing = incoming
            outgoing.font = .pretenSemiBold(14)
            return outgoing
        }
        config.titleAlignment = .leading
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        config.cornerStyle = .medium
        
        selectionButton.configuration = config
    }
    
    func resetToDefault() {
        var config = UIButton.Configuration.plain()
        
        config.title = "선택"
        config.baseBackgroundColor = .grayScale25
        config.baseForegroundColor = .grayScale800
        
        config.titleTextAttributesTransformer = .init { incoming in
            var outgoing = incoming
            outgoing.font = .pretenSemiBold(14)
            return outgoing
        }
        config.titleAlignment = .center
        config.cornerStyle = .medium
        
        selectionButton.configuration = config
    }
}

