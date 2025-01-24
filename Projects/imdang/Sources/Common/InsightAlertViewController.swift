//
//  InsightAlertViewController.swift
//  imdang
//
//  Created by 임대진 on 1/6/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

enum AlertType {
    case confirmOnly, cancellable, write
}

class InsightAlertViewController: UIViewController {
    var confirmAction: (() -> Void)?
    var cancelAction: (() -> Void)?
    private let disposeBag = DisposeBag()
    private let dimView = UIButton().then {
        $0.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    }
    
    private let alertView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
    }
    
    private let icon = UIImageView().then {
        $0.image = ImdangImages.Image(resource: .circleWarning)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.font = .pretenSemiBold(18)
        $0.textColor = .grayScale900
        $0.numberOfLines = 0
    }
    
    private let cancleButton = UIButton().then {
        $0.backgroundColor = .white
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.grayScale700, for: .normal)
        $0.titleLabel?.font = .pretenSemiBold(16)
        
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(hexCode: "#CBD5E0").cgColor
    }
    
    private let confirmButton = UIButton().then {
        $0.backgroundColor = .mainOrange500
        $0.setTitle("네, 괜찮아요", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .pretenSemiBold(16)
        $0.layer.cornerRadius = 8
    }
    
    private let storegeBoxButton = UIButton().then {
        $0.setTitle("보관함 확인하기", for: .normal)
        $0.setTitleColor(.grayScale700, for: .normal)
        $0.titleLabel?.font = .pretenSemiBold(14)
        $0.capsulLayer(height: 42)
        $0.layer.borderColor = UIColor.grayScale100.cgColor
        $0.layer.borderWidth = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindActions()
    }
    
    private func addSubviews() {
        [icon, descriptionLabel, cancleButton, confirmButton, storegeBoxButton].forEach { alertView.addSubview($0) }
        [dimView, alertView].forEach { view.addSubview($0) }
    }
    
    private func makeConstrints() {
        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        alertView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        icon.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(64)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(icon.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(55)
        }
        
        cancleButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(24)
            $0.width.equalTo(137.5)
            $0.height.equalTo(52)
        }
    }
    
    private func bindActions() {
        dimView.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        cancleButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
                self?.cancelAction?()
            })
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
                self?.confirmAction?()
            })
            .disposed(by: disposeBag)
        
        storegeBoxButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
                self?.cancelAction?()
            })
            .disposed(by: disposeBag)
    }
    
    func config(text: String, type: AlertType) {
        addSubviews()
        makeConstrints()
        descriptionLabel.setTextWithLineHeight(text: text, lineHeight: 25.2, textAlignment: .center)
        
        switch type {
        case .confirmOnly:
            confirmButton.setTitle("확인", for: .normal)
            cancleButton.isHidden = true
            
            confirmButton.snp.makeConstraints {
                $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
                $0.bottom.equalToSuperview().inset(24)
                $0.horizontalEdges.equalToSuperview().inset(24)
                $0.height.equalTo(52)
            }
            
        case .cancellable:
            confirmButton.setTitle("네, 괜찮아요", for: .normal)
            
            confirmButton.snp.makeConstraints {
                $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
                $0.trailing.equalToSuperview().offset(-24)
                $0.bottom.equalToSuperview().offset(-24)
                $0.width.equalTo(137.5)
                $0.height.equalTo(52)
            }
            
        case .write:
            confirmButton.setTitle("확인", for: .normal)
            cancleButton.isHidden = true
            
            
            storegeBoxButton.snp.makeConstraints {
                $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
                $0.centerX.equalToSuperview()
                $0.width.equalTo(121)
                $0.height.equalTo(42)
            }
            
            confirmButton.snp.makeConstraints {
                $0.top.equalTo(storegeBoxButton.snp.bottom).offset(24)
                $0.bottom.equalToSuperview().inset(24)
                $0.horizontalEdges.equalToSuperview().inset(24)
                $0.height.equalTo(52)
            }
        }
    }
}

extension UIButton {
    func capsulLayer(height: Int) {
        self.layer.cornerRadius = Double(height) / 2
    }
}
