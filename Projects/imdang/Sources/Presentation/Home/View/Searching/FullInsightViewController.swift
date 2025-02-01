//
//  FullInsightViewController.swift
//  imdang
//
//  Created by 임대진 on 2/1/25.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

class FullInsightViewController: BaseViewController {
    private var tableView: UITableView!
    private var chipViewHidden: Bool = false
    private let searchingViewModel = SearchingViewModel()
    private let insights = BehaviorRelay<[Insight]>(value: [])
    private let disposeBag = DisposeBag()
    
    private let titleLabel = UILabel().then {
        $0.font = .pretenSemiBold(18)
        $0.textColor = .grayScale900
    }
    
    private let countLabel = UILabel().then {
        $0.font = .pretenSemiBold(16)
        $0.textColor = .grayScale900
    }
    
    private let chipView = HorizontalCollectionChipView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customBackButton.isHidden = false
        
        setupTableView()
        addSubViews()
        makeConstraints()
        configNavigationBarItem()
        
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 112
        tableView.separatorStyle = .none
        
        tableView.register(cell: InsightTableCell.self)
    }
    
    private func addSubViews() {
        view.addSubview(tableView)
        view.addSubview(chipView)
        view.addSubview(countLabel)
    }
    
    private func configNavigationBarItem() {
        leftNaviItemView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func makeConstraints() {
        chipView.snp.makeConstraints {
            $0.topEqualToNavigationBottom(vc: self).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(36)
        }
        
        countLabel.snp.makeConstraints {
            if chipViewHidden {
                $0.topEqualToNavigationBottom(vc: self).offset(24)
            } else {
                $0.top.equalTo(chipView.snp.bottom).offset(16)
            }
            $0.leading.equalToSuperview().offset(20)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(countLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func config(title: String, insights: [Insight], chipViewHidden: Bool = false) {
        titleLabel.text = title
        countLabel.text = "\(insights.count)개"
        self.insights.accept(insights)
        self.chipViewHidden = chipViewHidden
        self.chipView.isHidden = chipViewHidden
    }
}

extension FullInsightViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return insights.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InsightTableCell", for: indexPath) as! InsightTableCell
        cell.selectionStyle = .none
        cell.configure(insight: insights.value[indexPath.row], layoutType: .horizontal)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchingViewModel.loadInsightDetail(id: insights.value[indexPath.row].insightId)
            .subscribe { [self] data in
                if let data = data {
                    let vc = InsightDetailViewController(url: "", insight: data, likeCount: insights.value[indexPath.row].likeCount, myInsights: chipViewHidden ? [] : nil)
                    vc.hidesBottomBarWhenPushed = true
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}
