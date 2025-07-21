//
//  AddressListViewController.swift
//  imdang
//
//  Created by 임대진 on 2/5/25.
//

import UIKit
import SnapKit
import Then
import RxSwift

class AddressListViewController: BaseViewController {
    private let searchingViewModel = SearchingViewModel()
    private var disposeBag = DisposeBag()
    private var guList = [String]()
    private var addresses: [String: [String]] = [:]
    
    private var selectedGuIndex: Int = 0

    private var guTableView: UITableView!
    private var dongTableView: UITableView!
    private let lineView = UIView().then {
        $0.backgroundColor = .grayScale100
    }
    private let titleLabel = UILabel().then {
        $0.text = "지역으로 찾기"
        $0.font = .pretenSemiBold(16)
        $0.textColor = .grayScale900
    }
    
    private let mapButton = ImageTextButton(type: .imageFirst, horizonPadding: 8, spacing: 4).then {
        $0.customImage.image = ImdangImages.Image(resource: .mapButtonGray)
        $0.customText.text = "지도"
        $0.customText.font = .pretenMedium(12)
        $0.customText.textColor = .grayScale700
        
        $0.layer.cornerRadius = 4
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.grayScale200.cgColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        customBackButton.isHidden = false
        
        searchingViewModel.loadDistricts()
            .subscribe(with: self) { owner, result in
                if let result {
                    owner.guList = result.sorted()
                    if let first = owner.guList.first {
                        owner.loadDongAddresses(siGunGu: first)
                    }
                    owner.guTableView.reloadData()
                }
            }
            .disposed(by: disposeBag)
        
        setupTableView()
        addSubViews()
        makeConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AnalyticsService().screenEvent(ScreenName: .searchToDistrictDetail)
    }
    
    private func loadDongAddresses(siGunGu: String) {
        searchingViewModel.loadDongAddresses(siGunGu: siGunGu)
            .subscribe(with: self) { owner, result in
                if let result {
                    owner.addresses = result
                    owner.dongTableView.reloadData()
                    owner.dongTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        guTableView = UITableView(frame: view.bounds, style: .plain)
        dongTableView = UITableView(frame: view.bounds, style: .plain)
        
        guTableView.delegate = self
        dongTableView.delegate = self
        guTableView.dataSource = self
        dongTableView.dataSource = self
        
        guTableView.showsVerticalScrollIndicator = false
        dongTableView.showsVerticalScrollIndicator = false
        
        guTableView.tag = 1
        dongTableView.tag = 2
        
        guTableView.rowHeight = 62
        dongTableView.rowHeight = 62
        
        guTableView.separatorStyle = .none
        dongTableView.separatorStyle = .none
        
        guTableView.register(cell: AddressTableCell.self)
        dongTableView.register(cell: AddressTableCell.self)
    }
    
    private func addSubViews() {
        leftNaviItemView.addSubview(titleLabel)
        rightNaviItemView.addSubview(mapButton)
        
        [guTableView, lineView, dongTableView].forEach { view.addSubview($0) }
    }
    
    private func makeConstraints() {
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
        }
        
        mapButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        guTableView.snp.makeConstraints {
            $0.topEqualToNavigationBottom(vc: self)
            $0.leading.equalToSuperview()
            $0.width.equalTo(100)
            $0.bottom.equalToSuperview()
        }
        
        lineView.snp.makeConstraints {
            $0.topEqualToNavigationBottom(vc: self)
            $0.leading.equalTo(guTableView.snp.trailing).offset(1)
            $0.width.equalTo(1)
            $0.bottom.equalToSuperview()
        }
        
        dongTableView.snp.makeConstraints {
            $0.topEqualToNavigationBottom(vc: self)
            $0.leading.equalTo(lineView.snp.trailing)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

    }
}

extension AddressListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.tag == 1 ? guList.count : guList.isEmpty ? 0 : addresses[guList[selectedGuIndex]]?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath, cellType: AddressTableCell.self)
        cell.selectionStyle = .none
        
        if tableView.tag == 1 {
            cell.config(title: guList[indexPath.row])
            cell.selectedCell(isSlected: (selectedGuIndex == indexPath.row))
        } else {
            cell.config(title: addresses[guList[selectedGuIndex]]![indexPath.row])
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1 {
            selectedGuIndex = indexPath.row
            let selectedGu = guList[selectedGuIndex]
            
            loadDongAddresses(siGunGu: selectedGu)
            
            guTableView.reloadData()
        } else {
            let fullVC = FullInsightViewController()
            fullVC.hidesBottomBarWhenPushed = true
            let address = AddressData(siDo: "서울", siGunGu: guList[selectedGuIndex], eupMyeonDong: addresses[guList[selectedGuIndex]]![indexPath.row], apartmentComplexCount: 0, insightCount: 0)
            fullVC.config(type: .search, title: "서울 \(address.siGunGu) \(address.eupMyeonDong)", address: address, chipViewHidden: true)
            self.navigationController?.pushViewController(fullVC, animated: true)
        }
    }
}
