//
//  SelectionModalController.swift
//  imdang
//
//  Created by daye on 8/5/25.
//

import UIKit
import Then
import SnapKit


protocol SelectionDelegate: AnyObject {
    func didSelect(priority: Int, category: String, item: String)
}

final class SelectionModalController: UIViewController {
    
    weak var delegate: SelectionDelegate?
    
    private let priority: Int
    private let existingSelections: [Int: (String, String)]
    let onboardingType: OnboardingType
    
    private var categories: [String] {
        switch onboardingType {
        case .liveIn:
            return ["출퇴근지역", "교통", "학군", "인프라", "환경"]
        case .gapInvestment:
            return ["아파트 평수", "세대수", "유형", "출퇴근 지역", "인프라", "환경", "교통", "학군"]
        }
    }
    private var spot: [String] = ["종로구", "서대문구", "중구", "마포구", "용산구", "양천구", "성동구", "강서구", "광진구", "구로구", "동대문구", "금천구", "중랑구", "영등포구", "성북구", "동작구", "강북구", "관악구", "도봉구", "서초구", "노원구", "강남구", "은평구", "송파구", "강동구"]
    private var items: [String: [String]] {
        switch onboardingType {
        case .liveIn:
            return [
                "출퇴근지역": ["강남구", "여의도", "광화문", "을지로", "성수", "판교", "마포", "마곡", "구로", "상암 DMC", "강서", "송파"],
                "교통": ["역세권", "버스정류장 인근", "주차관리", "주차장 엘리베이터 연결", "자차 출퇴근 편리"],
                "학군": ["초품아", "육아 커뮤니티 활발", "명문 초/중/고", "안전한 통학로", "학원가 근접"],
                "인프라": ["대형마트", "아이동반시설", "대학병원", "문화시설", "백화점"],
                "환경": ["공원", "하천", "등산로", "아파트 밀집", "한강"]
            ]
        case .gapInvestment:
            return [
                "아파트 평수": ["초소형(21~40m2)", "소형(60m2이하)", "중소형(60~82m2이하)", "중대형(85~102m2)","대형(135m2이상)"],
                "세대수": ["100세대 이상", "500세대 이상", "1000세대 이상", "2000세대 이상", "3000세대 이상"],
                "유형": ["신축", "구축"],
                "출퇴근 지역":["강남구", "여의도","광화문", "을지로", "성수", "판교", "마포", "마곡", "구로", "상암 DMC", "강서", "송파"],
                "인프라": ["대형마트", "아이동반시설", "대학병원", "문화시설", "백화점"],
                "환경": ["공원", "등산로", "한강", "하천", "아파트 밀집"],
                "교통": ["역세권", "버스정류장 인근", "주차관리", "주차장 엘리베이터 연결", "자차 출퇴근 편리"],
                "학군": ["초품아", "육아 커뮤니티 활발", "명문 초/중/고", "안전한 통학로", "학원가 근접"]
            ]
        }
    }
    
    private var selectedCategoryIndex = 0
    private var selectedItem: String?
    
    private let priorityLabel = UILabel().then {
        $0.font = .pretenSemiBold(18)
        $0.textColor = .darkGray
    }
    
    private let categoryScrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
    }
    
    private let categoryStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 24
    }
    
    private let indicatorView = UIView().then {
        $0.backgroundColor = .black
    }
    
    private let headerDividerView = UIView().then {
        $0.backgroundColor = .lightGray.withAlphaComponent(0.3)
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 16
        
        $0.collectionViewLayout = layout
        $0.backgroundColor = .white
        $0.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.identifier)
        $0.dataSource = self
        $0.delegate = self
    }
    
    private let selectButton = UIButton(type: .system).then {
        $0.setTitle("선택", for: .normal)
        $0.titleLabel?.font = .pretenSemiBold(16)
        $0.backgroundColor = .grayScale200
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 8
        $0.isEnabled = false
    }
    
    init(priority: Int, existingSelections: [Int: (String, String)], onboardingType:  OnboardingType) {
        self.priority = priority
        self.existingSelections = existingSelections
        self.onboardingType = onboardingType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupHierarchy()
        setupLayout()
        setupActions()
        setupCategoryButtons()
        
        priorityLabel.text = "\(priority)순위"
        view.layoutIfNeeded()
        updateIndicator(animated: false)
    }
    
    private func setupHierarchy() {
        [priorityLabel, categoryScrollView, indicatorView, headerDividerView, collectionView, selectButton].forEach { view.addSubview($0) }
        categoryScrollView.addSubview(categoryStackView)
    }
    
    private func setupLayout() {
        priorityLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(35)
            $0.leading.equalToSuperview().inset(20)
        }
        
        categoryScrollView.snp.makeConstraints {
            $0.top.equalTo(priorityLabel.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        categoryStackView.snp.makeConstraints {
            $0.edges.equalTo(categoryScrollView.contentLayoutGuide)
            $0.height.equalTo(categoryScrollView.frameLayoutGuide)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
    
        indicatorView.snp.makeConstraints { make in
            make.top.equalTo(categoryScrollView.snp.bottom)
            make.height.equalTo(2)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(0)
        }
        
        headerDividerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(indicatorView.snp.bottom)
            $0.height.equalTo(1)
        }
        
        selectButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.height.equalTo(54)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(headerDividerView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalTo(selectButton.snp.top).offset(-20)
        }
    }
    
    private func setupActions() {
        selectButton.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
    }
    
    private func setupCategoryButtons() {
        categories.enumerated().forEach { index, title in
            let button = UIButton(type: .system).then {
                $0.setTitle(title, for: .normal)
                $0.titleLabel?.font = .pretenSemiBold(14)
                $0.setTitleColor(index == 0 ? .grayScale900 : .grayScale120, for: .normal)
                $0.tag = index
                $0.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
            }
            categoryStackView.addArrangedSubview(button)
        }
    }
    
    @objc private func categoryButtonTapped(_ sender: UIButton) {
        let selectedIndex = sender.tag
        if selectedCategoryIndex == selectedIndex { return }
        
        selectedItem = nil
        updateSelectButtonState()
        
        selectedCategoryIndex = selectedIndex
        
        updateIndicator()
        
        collectionView.reloadData()
        collectionView.setContentOffset(.zero, animated: false)
    }
    
    private func updateIndicator(animated: Bool = true) {
        guard let button = categoryStackView.arrangedSubviews[selectedCategoryIndex] as? UIButton else { return }
        
        categoryStackView.arrangedSubviews.forEach { view in
            if let btn = view as? UIButton {
                btn.setTitleColor(btn.tag == selectedCategoryIndex ? .black : .gray, for: .normal)
            }
        }
        
        indicatorView.snp.remakeConstraints {
            $0.top.equalTo(categoryScrollView.snp.bottom)
            $0.height.equalTo(2)
            $0.leading.equalTo(button.snp.leading)
            $0.width.equalTo(button.snp.width)
        }
        
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        
        categoryScrollView.scrollRectToVisible(button.frame, animated: true)
    }
    
    @objc private func selectButtonTapped() {
        guard let selectedItem = selectedItem else { return }
        let selectedCategory = categories[selectedCategoryIndex]
        
        let isDuplicate = existingSelections.values.contains { (category, item) in
            return category == selectedCategory && item == selectedItem
        }
        
        if isDuplicate {
            showSnackbar(message: "동일 항목 선택이 불가능합니다.")
            return
        }
        
        delegate?.didSelect(priority: priority, category: selectedCategory, item: selectedItem)
        dismiss(animated: true, completion: nil)
    }
    
    private func updateSelectButtonState() {
        let isEnabled = (selectedItem != nil)
        selectButton.isEnabled = isEnabled
        selectButton.backgroundColor = isEnabled ? .mainOrange500 : .grayScale100
    }
    
    private func showSnackbar(message: String) {
        let snackbarView = UIView().then {
            $0.backgroundColor = .grayScale900
            $0.layer.cornerRadius = 8
            $0.alpha = 0
        }
        
        let messageLabel = UILabel().then {
            $0.text = message
            $0.textColor = .white
            $0.font = .systemFont(ofSize: 14)
            $0.textAlignment = .center
        }
        
        snackbarView.addSubview(messageLabel)
        view.addSubview(snackbarView)
        
        messageLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16))
        }
        
        snackbarView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(48)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(15)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            snackbarView.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseIn, animations: {
                snackbarView.alpha = 0
            }, completion: { _ in
                snackbarView.removeFromSuperview()
            })
        })
    }
}

extension SelectionModalController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let category = categories[selectedCategoryIndex]
        return items[category]?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.identifier, for: indexPath) as? ItemCell else {
            return UICollectionViewCell()
        }
        let category = categories[selectedCategoryIndex]
        if let item = items[category]?[indexPath.item] {
            cell.configure(with: item)
            cell.isSelectedItem = (item == selectedItem)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 10) / 2
        return CGSize(width: width, height: 36)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categories[selectedCategoryIndex]
        guard let item = items[category]?[indexPath.item] else { return }

        let previousSelectedItem = selectedItem
        selectedItem = item

        if let previousItem = previousSelectedItem, let previousIndex = items[category]?.firstIndex(of: previousItem) {
             let previousIndexPath = IndexPath(item: previousIndex, section: 0)
             if previousIndexPath != indexPath {
                 collectionView.reloadItems(at: [previousIndexPath])
             }
        }
        collectionView.reloadItems(at: [indexPath])

        updateSelectButtonState()
    }
}
