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

class HomeContainerViewController: BaseViewController {
    private let disposeBag = DisposeBag()
    
    private let searchViewController = SearchingViewController()
    private let exchangeViewController = ExchangeViewController(reactor: ExchangeReactor())
    
    private let searchButton = UIButton().then {
        $0.setTitle("탐색", for: .normal)
        $0.setTitleColor(.grayScale900, for: .normal)
        $0.titleLabel?.font = .pretenBold(24)
    }
    
    private let exchangeButton = UIButton().then {
        $0.setTitle("교환소", for: .normal)
        $0.setTitleColor(.grayScale500, for: .normal)
        $0.titleLabel?.font = .pretenBold(24)
    }
    
    private let alramButton = UIButton().then {
        $0.setImage(ImdangImages.Image(resource: .alarm), for: .normal)
    }
    
    private let myPageButton = UIButton().then {
        $0.setImage(ImdangImages.Image(resource: .person), for: .normal)
    }
    
    private let searchView = UIView().then {
        $0.backgroundColor = .white
        $0.isHidden = false
    }
    
    private let exchangeView = UIView().then {
        $0.backgroundColor = .white
        $0.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        configNavigationBarItem()
        makeConstraints()
        bindActions()
//        presentTooltip()
        
        navigationViewBottomShadow.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !UserdefaultKey.dontSeeToday {
            presentModal()
        }
    }
    
    private func presentModal() {
        let modalVC = TicketModalViewController()
        modalVC.modalPresentationStyle = .overFullScreen
        modalVC.modalTransitionStyle = .crossDissolve
        self.present(modalVC, animated: true, completion: nil)
    }
    
    private func presentTooltip() {
        let vc = HomeToolTipViewController(point: myPageButton)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    private func addSubviews() {
        [searchView, exchangeView].forEach { view.addSubview($0) }
        
        addChild(searchViewController)
        addChild(exchangeViewController)
        
        searchView.addSubview(searchViewController.view)
        exchangeView.addSubview(exchangeViewController.view)
        
        searchViewController.didMove(toParent: self)
        exchangeViewController.didMove(toParent: self)
    }
    
    private func makeConstraints() {
        
        searchView.snp.makeConstraints {
            $0.top.equalTo(myPageButton.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        exchangeView.snp.makeConstraints {
            $0.topEqualToNavigationBottom(vc: self)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        searchViewController.view.snp.makeConstraints {
            $0.edges.equalTo(searchView)
        }
        
        exchangeViewController.view.snp.makeConstraints {
            $0.edges.equalTo(exchangeView)
        }
    }
    
    private func configNavigationBarItem() {
        [searchButton, exchangeButton].forEach {
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

        exchangeButton.snp.makeConstraints {
            $0.leading.equalTo(searchButton.snp.trailing).offset(24)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(34)
        }
        
        myPageButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40)
        }

        alramButton.snp.makeConstraints {
            $0.trailing.equalTo(myPageButton.snp.leading).offset(-16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
    }
    
    private func bindActions() {
        searchButton.rx.tap
            .subscribe(onNext: { [weak self] state in
                self?.searchView.isHidden = false
                self?.exchangeView.isHidden = true
                self?.exchangeButton.setTitleColor(.grayScale500, for: .normal)
                self?.searchButton.setTitleColor(.grayScale900, for: .normal)
            })
            .disposed(by: disposeBag)
        
        exchangeButton.rx.tap
            .subscribe(onNext: { [weak self] state in
                self?.searchView.isHidden = true
                self?.exchangeView.isHidden = false
                self?.searchButton.setTitleColor(.grayScale500, for: .normal)
                self?.exchangeButton.setTitleColor(.grayScale900, for: .normal)
            })
            .disposed(by: disposeBag)
        
        myPageButton.rx.tap
            .subscribe(onNext: { [weak self] state in
                let vc = MyPageViewController()
                vc.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(vc, animated: true)
        })
        .disposed(by: disposeBag)
    }
}
