//
//  InsightViewController.swift
//  imdang
//
//  Created by daye on 12/17/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then
import ReactorKit

class InsightViewController: BaseViewController, View {

    private let buttonTitles = ["기본 정보", "인프라", "단지 환경", "단지 시설", "호재"]
    private var selectedIndex = 0
    var disposeBag = DisposeBag()

    private let titleLabel = UILabel().then {
        $0.text = "인사이트 작성"
        $0.font = .pretenBold(20)
        $0.textColor = .grayScale900
    }
    
    private let progressView = InsightProgressBar()
    
    private let underLineView = UIView().then {
        $0.backgroundColor = .grayScale100
    }
    
    private let containerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let scoreLabel = PaddingLabel().then {
        $0.text = "00%"
        $0.textColor = .mainOrange500
        $0.font = .pretenSemiBold(14)
        $0.backgroundColor = .mainOrange50
        $0.padding = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        
        $0.layer.cornerRadius = 14
        $0.clipsToBounds = true
    }

    private var insightSubView: [UIViewController] = []
    private let baseVC = InsightBaseInfoViewController()
    private let infraVC = WriteInsightEtcViewController(info: InsightEtcInfo.infrastructure, title: "인프라")
    private let environVC = WriteInsightEtcViewController(info: InsightEtcInfo.environment, title: "단지 환경")
    private let facilVC = WriteInsightEtcViewController(info: InsightEtcInfo.facility, title: "단지 시설")
    private let newsVC = WriteInsightEtcViewController(info: InsightEtcInfo.goodNews, title: "호재")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .grayScale25
        navigationViewBottomShadow.isHidden = true
        
        
        reactor = InsightReactor()
        setupSubviews()
        
        configNavigationBarItem()
        layout()
        presentAlert()
    }
    
    private func setupSubviews() {
        baseVC.reactor = self.reactor
        infraVC.reactor = self.reactor
        environVC.reactor = self.reactor
        facilVC.reactor = self.reactor
        newsVC.reactor = self.reactor
        [baseVC, infraVC, environVC, facilVC, newsVC].forEach { insightSubView.append($0) }
    }

    private func configNavigationBarItem() {
        customBackButton.isHidden = false
        
        leftNaviItemView.addSubview(titleLabel)
        rightNaviItemView.addSubview(scoreLabel)
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
        }
        
        scoreLabel.snp.makeConstraints {
            $0.height.equalTo(28)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
    }

    private func layout() {
        [progressView, underLineView, containerView].forEach { view.addSubview($0) }

        progressView.snp.makeConstraints {
            $0.topEqualToNavigationBottom(vc: self).offset(4)
            $0.leading.trailing.equalToSuperview()
        }

        underLineView.snp.makeConstraints {
            $0.top.equalTo(progressView.snp.bottom).offset(1)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }

        containerView.snp.makeConstraints {
            $0.top.equalTo(underLineView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        self.showInsightSubViewController(at: 0)
    }
    
    private func presentModal() {
        let modalVC = BaseInfoViewBottomSheet()
        modalVC.modalPresentationStyle = .fullScreen
        modalVC.modalTransitionStyle = .crossDissolve
        self.present(modalVC, animated: true, completion: nil)
    }
    
    private func presentAlert() {
        showInsightAlert(text: "작성 완료시 인사이트가\n바로 업로드 돼요. 여유로운 시간에\n신중하게 작성해주세요.", type: .confirmOnly) { 
        } cancelAction: {
        }
    }

    func bind(reactor: InsightReactor) {
        reactor.state
            .map { $0.isShowingCameraSheet }
            .distinctUntilChanged()
            .subscribe(onNext: { isShowingCamera in
                if isShowingCamera {
                    print("Open camera sheet!")
                    self.presentModal()
                }
            })
            .disposed(by: disposeBag)
        
        
        reactor.state
            .map { $0.setCurrentCategory }
            .distinctUntilChanged()
            .subscribe(onNext: { index in
                self.showInsightSubViewController(at: index)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isChangeScore }
            .subscribe(onNext: { score in
                if score == 0 { self.scoreLabel.text = "00%" }
                else { self.scoreLabel.text = "\(score)%" }
            })
            .disposed(by: disposeBag)
    }

    private func showInsightSubViewController(at index: Int) {
        progressView.setProgress(index: index)
        
        if let childVC = insightSubView[safe: index] {
            children.forEach { $0.removeFromParent() }
            containerView.subviews.forEach { $0.removeFromSuperview() }
            
            addChild(childVC)
            containerView.addSubview(childVC.view)
            childVC.view.snp.makeConstraints { $0.edges.equalToSuperview() }
            childVC.didMove(toParent: self)
        }
    }

}
