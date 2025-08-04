////
////  InsightDetailViewController.swift
////  imdang
////
////  Created by 임대진 on 1/8/25.
////
//
import UIKit
import SnapKit
import Then
import RxSwift
import RxRelay

final class InsightDetailViewController: BaseViewController {

    private var insight: InsightDetail!
    private var images: [UIImage]?
    private var tableView: UITableView!
    private var showEditButton: Bool
    private var disposeBag = DisposeBag()
    private var myInsights: [Insight]?
    private let analyticsService = AnalyticsService.shared
    private let kakaoShareService = KakaoShareService()
    private let insightDetailViewModel = InsightDetailViewModel()
    private let selectedIndex = BehaviorRelay<Int?>(value: nil)
    private let accused = BehaviorRelay<Bool>(value: false)
    
    private let reportButton = UIButton().then {
        $0.setImage(ImdangImages.Image(resource: .report), for: .normal)
    }
    
    private let shareButton = UIButton().then {
        $0.setImage(ImdangImages.Image(resource: .share), for: .normal)
    }
    
//    private let requestButton = CommonButton(title: "교환 요청", initialButtonType: .enabled)
//    private let degreeButton = CommonButton(title: "거절", initialButtonType: .whiteBackBorderStyle)
//    private let agreeButton = CommonButton(title: "수락", initialButtonType: .enabled)
//    private let waitButton = CommonButton(title: "대기중", initialButtonType: .disabled)
//    private let doneButton = CommonButton(title: "교환 완료", initialButtonType: .disabled)
    private let editButton = CommonButton(title: "수정하기", initialButtonType: .whiteBackBorderStyle).then {
        $0.isHidden = true
    }
    private let buttonBackView = UIView().then { $0.backgroundColor = .white }.then {
        $0.applyTopBlur()
        $0.isHidden = true
    }
    private let headerView = InsightDetailCategoryTapView()
    private let categoryTapView = InsightDetailCategoryTapView().then {
        $0.isHidden = true
    }
    
    private var isMine = false
    
    
    init(insight: InsightDetail, images: [UIImage]? = nil, showEditButton: Bool = true) {
        self.insight = insight
        self.images = images
        self.showEditButton = showEditButton
        self.accused.accept(insight.accused)
//        self.isMine = insight.crea
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .detailModalDidDismiss, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customBackButton.isHidden = false
        navigationViewBottomShadow.isHidden = true
        
        setNavigationItem()
        configureTableView()
        addSubviews()
        makeConstraints()
        bindActions()
        
        view.addSubview(categoryTapView)
        categoryTapView.snp.makeConstraints {
            $0.topEqualToNavigationBottom(vc: self)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AnalyticsService().screenEvent(ScreenName: .insightDetail)
    }
    
    private func setNavigationItem() {
        [reportButton, shareButton].forEach { rightNaviItemView.addSubview($0) }
        
        shareButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(10)
        }
        
        reportButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(shareButton.snp.leading).offset(-12)
        }
    }
    
    private func configureTableView() {
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 1
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        
        tableView.register(cell: UITableViewCell.self)
        tableView.register(cell: InsightDetailImageCell.self)
        tableView.register(cell: InsightDetailEtcTableCell.self)
        tableView.register(cell: InsightDetailTitleTableCell.self)
        tableView.register(cell: InsightDetailDefaultInfoTableCell.self)
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.topEqualToNavigationBottom(vc: self)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func addSubviews() {
        [buttonBackView, editButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func makeConstraints() {
        buttonBackView.snp.makeConstraints() {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(96)
            $0.bottom.equalToSuperview()
        }
        
        editButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(56)
            $0.bottom.equalToSuperview().offset(-40)
        }
        
        showButton()
    }
    
    private func showButton() {
        // MARK: TODO
        if isMine {
            buttonBackView.isHidden = false
            editButton.isHidden = false
        } else {
            buttonBackView.isHidden = true
            editButton.isHidden = true
        }
    }
    
    private func bindActions() {
        
        editButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                let vc = InsightViewController()
                let reactor = InsightReactor()
                reactor.detail = owner.insight
                reactor.updateInsightId = owner.insight.insightId.value
                vc.reactor = reactor
                owner.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        reportButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                if !owner.accused.value {
                    owner.showReportAlert(title: "이 인사이트를 신고할까요?", description: "허위, 과다 신고시 불이익이\n발생할 수 있어요", type: .cancellable, comfrimAction: {
                        
                        owner.insightDetailViewModel.accueInsight(insightId: owner.insight.insightId.value)
                            .subscribe(with: self) { owner, result in
                                if result {
                                    owner.accused.accept(true)
                                    owner.showAlert(text: "신고가 완료되었어요.", type: .confirmOnly)
                                }
                            }
                            .disposed(by: owner.disposeBag)
                    })
                } else {
                    owner.showReportAlert(title: "이미 신고한 인사이트에요", description: "동일한 인사이트를 중복으로\n신고할 수 없어요", type: .confirmOnly)
                }
            })
            .disposed(by: disposeBag)
        
        shareButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.kakaoShareService.insightKakaoShare(title: owner.insight.title, insightId: owner.insight.insightId.value, imageUrl: owner.insight.images.first ?? "") { linkType in
                    owner.openKakaoLink(kakaoLinkType: linkType)
                }
            })
            .disposed(by: disposeBag)
        
        headerView.selectedIndex
            .compactMap { $0 }
            .distinctUntilChanged()
            .subscribe(with: self, onNext: { owner, index in
                owner.selectedIndex.accept(index)
            })
            .disposed(by: disposeBag)
        
        categoryTapView.selectedIndex
            .compactMap { $0 }
            .distinctUntilChanged()
            .subscribe(with: self, onNext: { owner, index in
                owner.selectedIndex.accept(index)
            })
            .disposed(by: disposeBag)
        
        selectedIndex
            .compactMap { $0 }
            .distinctUntilChanged()
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(with: self, onNext: { owner, index in
                owner.headerView.selectedIndex.accept(index)
                owner.categoryTapView.selectedIndex.accept(index)
                if owner.insight.memberId.value == UserdefaultKey.memberId {
                    owner.tableView.scrollToRow(at: IndexPath(row: 0, section: index + 2), at: .top, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func scrollToSection(index: Int) {
        let indexPath = IndexPath(row: 0, section: index + 2)
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        let cellTopY = cell.frame.origin.y
        
        let targetOffsetY = cellTopY - 70
        
        var offset = tableView.contentOffset
        offset.y = targetOffsetY
        
        tableView.setContentOffset(offset, animated: true)
    }
}

extension InsightDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let etcCell = tableView.dequeueReusableCell(forIndexPath: indexPath, cellType: InsightDetailEtcTableCell.self)
        etcCell.selectionStyle = .none
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath, cellType: InsightDetailImageCell.self)
            cell.config(url: insight.images, mainImage: images)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath, cellType: InsightDetailTitleTableCell.self)
            cell.config(info: insight)
            cell.selectionStyle = .none
            
            cell.likeButton.rx.tap
                .subscribe(with: self) { owner, _ in
                    owner.insightDetailViewModel.recommendInsight(insightId: owner.insight.insightId.value)
                        .subscribe(with: self) { owner, result in
                            switch result {
                            case .success:
                                cell.likeInsight()
                                owner.analyticsService.insightLike(isOn: true)
                            case .failure:
                                return
                            }
                        }
                        .disposed(by: owner.disposeBag)
                }
                .disposed(by: disposeBag)
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath, cellType: InsightDetailDefaultInfoTableCell.self)
            cell.config(info: insight, isMyInsight: insight.memberId.value == UserdefaultKey.memberId)
            cell.selectionStyle = .none
            return cell
        case 3:
            etcCell.config(info: insight.infra.conversionArray(), text: insight.infra.text)
            return etcCell
        case 4:
            etcCell.config(info: insight.complexEnvironment.conversionArray(), text: insight.complexEnvironment.text)
            return etcCell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 2:
            return 44
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 2:
            return headerView
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0,1,2:
            return 0
        case 3:
            return insight.infra.text != "" ? UITableView.automaticDimension : 0
        case 4:
            return insight.complexEnvironment.text != "" ? UITableView.automaticDimension : isMine ? 60 : 40
        default:
            return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = InsightDetailEtcFooterView()
        switch section {
        case 3:
            footerView.config(text: insight.infra.text)
            return footerView
        case 4:
            footerView.config(text: insight.complexEnvironment.text)
            return footerView
        default:
            return nil
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerHeight: CGFloat = 423
        let sectionHeaderYOffset = scrollView.contentOffset.y
        
        if sectionHeaderYOffset >= headerHeight {
            categoryTapView.isHidden = false
        } else {
            categoryTapView.isHidden = true
        }
        
        guard scrollView.isTracking || scrollView.isDragging || scrollView.isDecelerating else {
            return
        }
        
        let visibleRows = tableView.indexPathsForVisibleRows ?? []
        
        for indexPath in visibleRows {
            if (2...6).contains(indexPath.section), indexPath.row == 0 {
                
                let indexPath = IndexPath(row: 0, section: indexPath.section)
                let cellRect = tableView.rectForRow(at: indexPath)
                let cellTopY = cellRect.origin.y - scrollView.contentOffset.y

                if cellTopY < 100 {
                    let currentIndex = indexPath.section - 2
                    categoryTapView.setCurrentIndex.accept(currentIndex)
                    headerView.setCurrentIndex.accept(currentIndex)
                    break
                }
            }
        }
    }
}
