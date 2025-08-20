//
//  OnboardingSetOptionController.swift
//  imdang
//
//  Created by daye on 7/28/25.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class OnboardingSetOptionController: BaseViewController, View, SelectionDelegate {
    
    var disposeBag = DisposeBag()

    private let backButton = UIButton().then {
        $0.setImage(ImdangImages.Image(resource: .backButton), for: .normal)
    }
    
    private let startView = OnboardingStartView()
    private let stepView = StepView()
    private let priorityView = PrioritySettingView()
    private let spotSelectionView = SpotSelectionView()
    private let doneView = DoneView()
    
    init(reactor: OnboardingSetOptionReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configNavigationBarItem()
    }

    private func setupUI() {
        view.backgroundColor = .white
        
        [startView, stepView, priorityView, spotSelectionView, doneView].forEach { view.addSubview($0) }
        
        stepView.isHidden = true
        priorityView.isHidden = true
        doneView.isHidden = true
        
        [startView, stepView, priorityView, spotSelectionView].forEach { view in
            view.snp.makeConstraints {
                $0.topEqualToNavigationBottom(vc: self).offset(10)
                $0.leading.trailing.bottom.equalToSuperview()
            }
        }
        
        doneView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configNavigationBarItem() {
        customBackButton.isHidden = true
        leftNaviItemView.addSubview(backButton)
        navigationViewBottomShadow.backgroundColor = .clear
        backButton.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
        }
    }
    
    func bind(reactor: OnboardingSetOptionReactor) {
        
        startView.selectedValue
            .map { OnboardingSetOptionReactor.Action.setOnboardingType($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    
        startView.nextButtonTapped
            .map { OnboardingSetOptionReactor.Action.goNextPage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        stepView.optionSelected.map { OnboardingSetOptionReactor.Action.optionSelected}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        priorityView.nextButtonTapped.map{ OnboardingSetOptionReactor.Action.completeNewView }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        priorityView.skipButtonTapped.map{ OnboardingSetOptionReactor.Action.skipNewView }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        spotSelectionView.nextButtonTapped
            .map { OnboardingSetOptionReactor.Action.spotSelected($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        spotSelectionView.skipButtonTapped
            .map { OnboardingSetOptionReactor.Action.skipSpotSelection }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        backButton.rx.tap.map { OnboardingSetOptionReactor.Action.goBack }.bind(to: reactor.action).disposed(by: disposeBag)
        
        priorityView.priorityButtonTapped
            .subscribe(onNext: { [weak self] tag in
                self?.presentSelectionModal(for: tag)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.currentPage == .done }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isDonePage in
                self?.leftNaviItemView.isHidden = isDonePage
                self?.rightNaviItemView.isHidden = isDonePage
                self?.navigationViewBottomShadow.isHidden = isDonePage
            })
            .disposed(by: disposeBag)
        
        reactor.state.compactMap { $0.stepData }.distinctUntilChanged().observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                UIView.transition(with: self.stepView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    self.stepView.configure(with: data)
                })
            }).disposed(by: disposeBag)
            
        reactor.state.map { $0.currentPage }.distinctUntilChanged()
                   .observe(on: MainScheduler.instance)
                   .subscribe(onNext: { [weak self] page in
                       guard let self = self else { return }
                   
                       self.startView.isHidden = (page != .start)
                       self.stepView.isHidden = (page != .step)
                       self.spotSelectionView.isHidden = (page != .spot) // spot 페이지 처리
                       self.priorityView.isHidden = (page != .priority)
                       self.doneView.isHidden = (page != .done)
                       
                       if page == .done {
                           self.doneView.play { finished in
                               if finished { print("온보딩 완료 애니메이션 끝!") }
                           }
                       }
                   }).disposed(by: disposeBag)
            
        reactor.state.map { $0.currentPage == .start || $0.currentPage == .done }.distinctUntilChanged()
            .bind(to: backButton.rx.isHidden)
            .disposed(by: disposeBag)
            
        reactor.state.map { $0.selectedPriorities }
            .distinctUntilChanged { oldDict, newDict in
                guard oldDict.count == newDict.count else { return false }
                return oldDict.allSatisfy { key, oldValue in
                    guard let newValue = newDict[key] else { return false }
                    return oldValue.0 == newValue.0 && oldValue.1 == newValue.1
                }
            }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] priorities in
                priorities.forEach { priority, data in
                    self?.priorityView.updatePriority(priority: priority, category: data.0, item: data.1)
                }
            })
            .disposed(by: disposeBag)
    }

    private func presentSelectionModal(for priority: Int) {
        let currentSelections = reactor?.currentState.selectedPriorities
            .filter { $0.key != priority } ?? [:]

        guard let onboardingType = reactor?.currentState.onboardingType else { return }
        
        let modalVC = SelectionModalController(
            priority: priority,
            existingSelections: currentSelections,
            onboardingType: onboardingType
        )
        modalVC.delegate = self
        
        if let sheet = modalVC.sheetPresentationController {
            sheet.detents = [.large(), .medium()]
            sheet.prefersGrabberVisible = true
        }
        
        self.present(modalVC, animated: true, completion: nil)
    }
    
    func didSelect(priority: Int, category: String, item: String) {
        reactor?.action.onNext(.prioritySelected(priority: priority, category: category, item: item))
    }
}
