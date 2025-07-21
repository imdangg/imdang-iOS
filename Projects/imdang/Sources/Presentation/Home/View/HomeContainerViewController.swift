//
//  HomeContainerViewController.swift
//  imdang
//
//  Created by 임대진 on 11/20/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

enum HomeTapState {
    case search, exchange
}

class HomeContainerViewController: BaseViewController {
    let homeTapState = BehaviorRelay<HomeTapState>(value: .search)
    private let disposeBag = DisposeBag()
    private let homeViewModel = HomeViewModel()
    private let serverService = ServerJoinService.shared
    private let analyticsService = AnalyticsService.shared
    
    private let searchViewController = SearchingViewController()
    
    private let containerView = UIView()
    private let searchButton = UIButton().then {
        $0.setTitle("탐색", for: .normal)
        $0.setTitleColor(.grayScale900, for: .normal)
        $0.titleLabel?.font = .pretenBold(24)
    }
    
    private let alramButton = UIButton().then {
        $0.setImage(ImdangImages.Image(resource: .alarm), for: .normal)
    }
    
    private let myPageButton = UIButton().then {
        $0.setImage(ImdangImages.Image(resource: .person), for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewModel.loadMyNickname()
        
        addSubviews()
        configNavigationBarItem()
        makeConstraints()
        switchToViewController(searchViewController)
        bindActions()
        
        navigationViewBottomShadow.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        serverService.checkTokenExpired()
    }
    
    private func popReportAlert() {
//                showReportAlert(title: "신고가 5회 누적되었어요", description: "3일간 인사이트 교환이 불가능해요.\n문의 사항은 아래 메일로 남겨주세요.", highligshtText: "3일간", email: true, type: .confirmOnly)
//                showReportAlert(title: "신고가 15회 누적되었어요", description: "5일간 인사이트 교환이 불가능해요.\n문의 사항은 아래 메일로 남겨주세요.", highligshtText: "5일간", email: true, type: .confirmOnly)
//                showReportAlert(title: "신고가 30회 누적되었어요", description: "7일간 인사이트 교환이 불가능해요.\n문의 사항은 아래 메일로 남겨주세요.", highligshtText: "7일간", email: true, type: .confirmOnly)
//                showReportAlert(title: "신고가 50회 누적되었어요", description: "해당 계정은 서비스를 사용할 수 없어요.\n문의 사항은 아래 메일로 남겨주세요.", highligshtText: "서비스를 사용할 수 없어요.", email: true, type: .confirmOnly)
    }
    
    private func addSubviews() {
        [containerView].forEach { view.addSubview($0) }
    }
    
    private func makeConstraints() {
        containerView.snp.makeConstraints {
            $0.topEqualToNavigationBottom(vc: self)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func configNavigationBarItem() {
        [searchButton].forEach {
            leftNaviItemView.addSubview($0)
        }
        [alramButton, myPageButton].forEach {
            rightNaviItemView.addSubview($0)
        }
        
        searchButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.height.equalTo(34)
        }
        
        myPageButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }

//        alramButton.snp.makeConstraints {
//            $0.trailing.equalTo(myPageButton.snp.leading).offset(-16)
//            $0.centerY.equalToSuperview()
//            $0.width.height.equalTo(24)
//        }
    }
    
    private func bindActions() {
        
        myPageButton.rx.tap
            .withLatestFrom(homeTapState)
            .subscribe(onNext: { [weak self] state in
                if state == .search {
                    self?.analyticsService.searchMypageButtonClick()
                } else {
                    self?.analyticsService.exchangeMypageButtonClick()
                }
                let vc = MyPageViewController(reactor: MyPageReactor())
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
        })
        .disposed(by: disposeBag)
        
        alramButton.rx.tap
            .withLatestFrom(homeTapState)
            .subscribe(onNext: { [weak self] state in
                if state == .search {
                    self?.analyticsService.searchNotiButtonClick()
                } else {
                    self?.analyticsService.exchangeNotiButtonClick()
                }
                let vc = NotificationViewController(reactor: NotificationReactor())
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func switchToViewController(_ viewController: UIViewController) {
        children.forEach { $0.willMove(toParent: nil); $0.view.removeFromSuperview(); $0.removeFromParent() }
        
        addChild(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
}
