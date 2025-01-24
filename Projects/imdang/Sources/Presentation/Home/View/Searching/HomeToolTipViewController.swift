//
//  HomeToolTipViewController.swift
//  imdang
//
//  Created by 임대진 on 1/24/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

class HomeToolTipViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let point: UIView
    
    private let dimView = UIButton().then {
        $0.backgroundColor = .clear
    }
    
    private let tooltipBackgroundView = UIImageView().then {
        $0.image = ImdangImages.Image(resource: .topTooltip)
        $0.contentMode = .scaleAspectFill
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "무료 패스권은 교환소에서 확인할 수 있어요"
        $0.font = .pretenMedium(14)
        $0.textColor = .white
    }
    
    init(point: UIView) {
        self.point = point
        print(point)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubViews()
        makeConstraints()
        bindActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    private func addSubViews() {
        [dimView, tooltipBackgroundView, titleLabel].forEach { view.addSubview($0) }
    }
    
    private func makeConstraints() {
        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tooltipBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(96)
            $0.leading.equalToSuperview().offset(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(tooltipBackgroundView.snp.leading).offset(16)
            $0.bottom.equalTo(tooltipBackgroundView.snp.bottom).offset(-14)
        }
    }
    
    private func bindActions() {
        dimView.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}
