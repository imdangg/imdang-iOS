//
//  Untitled.swift
//  imdang
//
//  Created by daye on 12/22/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxRelay
import ReactorKit

enum ItemType {
    case text
    case image
    case address
    case button

}

class InsightBaseInfoViewController: UIViewController, TotalAppraisalFootereViewDelegate, View {
    
    var disposeBag = DisposeBag()
    
    private var baseInfo = InsightDetail.emptyInsight
    private var imageData: UIImage?
    private var buildingName = ""
    private var summary: String = ""
    private var nextButtonView = NextAndBackButton()
    
    private var selectedIndexPaths: [BehaviorRelay<Set<IndexPath>>] = [
        BehaviorRelay<Set<IndexPath>>(value: []), // Section 4
        BehaviorRelay<Set<IndexPath>>(value: []), // Section 5
        BehaviorRelay<Set<IndexPath>>(value: [])  // Section 6
    ]
    
    private var checkSectionState = BehaviorRelay<[TextFieldState]>(value: Array(repeating: .normal, count: 8))
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .grayScale25
        $0.register(BaseInfoTextFieldCell.self, forCellWithReuseIdentifier: BaseInfoTextFieldCell.identifier)
        $0.register(BaseInfoButtonCell.self, forCellWithReuseIdentifier: BaseInfoButtonCell.identifier)
        $0.register(BaseInfoImageCell.self, forCellWithReuseIdentifier: BaseInfoImageCell.identifier)
        $0.register(BaseInfoAddressCell.self, forCellWithReuseIdentifier: BaseInfoAddressCell.identifier)
        $0.register(InsightTotalAppraisalFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: InsightTotalAppraisalFooterView.identifier)
        $0.register(BaseInfoHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BaseInfoHeaderCell.identifier)
        $0.dataSource = self
        $0.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }

    private func layout() {
        view.addSubview(collectionView)
        view.addSubview(nextButtonView)
        nextButtonView.config(needBack: false)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        nextButtonView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(96)
        }
    }

    private let items: [(header: String, script: String, itemType: ItemType, itemData: [String])]
        = [("표시 이미지", "", .image, [""]),
            ("제목", "최소1자-최대20자", .text, [""]),
            ("단지 주소", "", .address, ["지번 주소", "단지 아파트 명"]),
            ("다녀온 날짜", "", .text, [""]),
            ("다녀온 시간", "복수 선택 가능", .button, ["아침", "점심", "저녁", "밤"]),
            ("교통 수단", "복수 선택 가능", .button, ["자차", "대중교통", "도보"]),
            ("출입 제한", "하나만 선택", .button, ["제한됨", "허락시 가능", "자유로움"])
        ]
    
    func bind(reactor: InsightReactor) {
        
        nextButtonView.nextButton.rx.tap
            .map { InsightReactor.Action.tapBaseInfoConfirm(self.baseInfo, self.imageData) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        checkSectionState
            .subscribe(onNext: { [weak self] arr in
                guard let self = self else { return }
                self.nextButtonView.nextButtonEnable(value: arr.filter { $0 == .done }.count == 8 ? true : false)
//                self.nextButtonView.nextButtonEnable(value: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func updateSectionState(index: Int, newState: TextFieldState) {
        var currentStates = checkSectionState.value
        currentStates[index] = newState
        checkSectionState.accept(currentStates)
    }
}

// MARK: - UICollectionViewDataSource
extension InsightBaseInfoViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items[section].itemData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.section].itemType
        switch item {
        case .text:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseInfoTextFieldCell.identifier, for: indexPath) as! BaseInfoTextFieldCell
            cell.titleTextField.rx.text
                .subscribe(onNext: { [weak self] text in
                    guard let self = self else { return }
                    if indexPath.section == 1 {
                        
                        baseInfo.title = text ?? ""
                        updateSectionState(index: indexPath.section, newState: baseInfo.title != "" ? TextFieldState.done : TextFieldState.normal)
                        
                    } else if indexPath.section == 3 {
                        
                        baseInfo.visitAt = text.map { $0.replacingOccurrences(of: ".", with: "-") } ?? ""
                        updateSectionState(index: indexPath.section, newState: baseInfo.visitAt != "" ? TextFieldState.done : TextFieldState.normal)
                        
                    }
                })
                .disposed(by: disposeBag)
            
            if indexPath.section == 3 {
                cell.titleTextField.setConfigure(placeholderText: "예시) 2024.01.01", textfieldType: .decimalPad)
            }
            
            return cell
            
        case .button:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BaseInfoButtonCell.identifier,
                for: indexPath
            ) as! BaseInfoButtonCell

            let itemArray = items[indexPath.section].itemData

            cell.configure(title: itemArray[indexPath.row])

            let selectedSetRelay = selectedIndexPaths[indexPath.section - 4]

                selectedSetRelay
                    .map { selectedSet in
                        selectedSet.contains { $0 == indexPath } ? .selectedBorderStyle : .unselectedBorderStyle
                    }
                    .bind(to: cell.rx.commonButtonState)
                    .disposed(by: disposeBag)

                cell.buttonView.rx.tap
                    .subscribe(onNext: { [weak self] in
                        guard let self else { return }

                        var selectedSet = selectedSetRelay.value

                        if indexPath.section == 6 {
                            // 단일 선택
                            if selectedSet.contains(indexPath) {
                                selectedSet.remove(indexPath) // 선택 해제
                            } else {
                                selectedSet = [indexPath] // 선택 변경
                            }
                        } else {
                            // 다중 선택
                            if selectedSet.contains(indexPath) {
                                selectedSet.remove(indexPath)
                            } else {
                                selectedSet.insert(indexPath)
                            }
                        }

                        selectedSetRelay.accept(selectedSet)
                        
                        print("Section: \(indexPath.section), Selected: \(selectedSet.map { itemArray[$0.row] })")
                        
                        switch indexPath.section {
                        case 4:
                            baseInfo.visitTimes = selectedSet.map { itemArray[$0.row] }
                            updateSectionState(index: indexPath.section, newState: baseInfo.visitTimes.isEmpty == false ? TextFieldState.done : TextFieldState.normal)
                            
                        case 5:
                            baseInfo.visitMethods = selectedSet.map { itemArray[$0.row] }
                            updateSectionState(index: indexPath.section, newState: baseInfo.visitMethods.isEmpty == false ? TextFieldState.done : TextFieldState.normal)
                            
                        case 6:
                            baseInfo.access = selectedSet.map { itemArray[$0.row] }[safe: 0]?.replacingOccurrences(of: " ", with: "_") ?? ""
                            updateSectionState(index: indexPath.section, newState: baseInfo.access != "" ? TextFieldState.done : TextFieldState.normal)
                            
                        default:
                            break
                        }
                    })
                    .disposed(by: cell.disposeBag)

                return cell
            
        case .image:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseInfoImageCell.identifier, for: indexPath) as! BaseInfoImageCell
            cell.buttonTapState
                .subscribe(onNext: { [weak self] in
                    guard let self else { return }
                    
                    let imageModal = BaseInfoViewBottomSheet()
                    imageModal.modalPresentationStyle = .overFullScreen
                    present(imageModal, animated: false, completion: nil)
                    
                    imageModal.onPhotoLibrarySelected = { [self] image in
                        cell.resultImageAccept(image: image)
                        
                        self.imageData = image
                        self.updateSectionState(index: indexPath.section, newState: self.imageData != nil ? TextFieldState.done : TextFieldState.normal)
                    }
                    imageModal.onCameraSelected = { image in
                        cell.resultImageAccept(image: image)
                        
                        self.imageData = image
                        self.updateSectionState(index: indexPath.section, newState: self.imageData != nil ? TextFieldState.done : TextFieldState.normal)
                    }
                })
                .disposed(by: disposeBag)
            return cell
                 
        case .address:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseInfoAddressCell.identifier, for: indexPath) as! BaseInfoAddressCell
            
            if indexPath.row == 0 {
                baseInfo.address.siDo == ""
                ? cell.configure(title: "지번 주소")
                : cell.setData(title: "\(baseInfo.address.siDo) \(baseInfo.address.siGunGu) \(baseInfo.address.eupMyeonDong) \(baseInfo.address.buildingNumber)")
            } else {
                buildingName == ""
                ? cell.configure(title: "아파트 단지 명")
                : cell.setData(title: buildingName)
            }
            
            cell.buttonAction = { result in
                let webViewController = WebViewController()
                self.present(webViewController, animated: true, completion: nil)
                
                webViewController.onAddressSelected = { [self] data in
                    if let sido = (data["sido"]) as? String {
                        baseInfo.address.siDo = sido
                    }
                    
                    if let sigungu = (data["sigungu"]) as? String {
                        baseInfo.address.siGunGu = sigungu
                    }
                    
                    if let query = (data["query"]) as? String {
                        let splited = query.split(separator: " ")
                        baseInfo.address.eupMyeonDong = String(splited[0])
                        baseInfo.address.buildingNumber = String(splited[1])
                    }
                    
                    if let buildingName = (data["buildingName"]) as? String {
                        self.buildingName = buildingName
                        baseInfo.apartmentComplex.name = buildingName
                    }
                    
                    collectionView.reloadSections(IndexSet([2]))
                }
            }
            
            updateSectionState(index: indexPath.section, newState: buildingName != "" ? TextFieldState.done : TextFieldState.normal)
            
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension InsightBaseInfoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BaseInfoHeaderCell.identifier, for: indexPath) as! BaseInfoHeaderCell
            
            headerView.adjustTopPadding(indexPath.section == 0 ? 20 : 0)
//            print("header state : \(checkSectionState[indexPath.section])")
            headerView.headerView.setState(checkSectionState.value[indexPath.section])
            headerView.configure(title: items[indexPath.section].header,
                                 script: items[indexPath.section].script)
            
            return headerView
        } else if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableFooter(forIndexPath: indexPath, footerType: InsightTotalAppraisalFooterView.self)
            footer.config(title: "인사이트 요약*")
            footer.setPlaceHolder(text: "예시)\n지하철역과 도보 10분 거리로 접근성이 좋지만, 근처 공사로 소음 문제가 있을 수 있을 것 같아요. 하지만 단지 내 공원이 잘 조성되어 있어 가족 단위 거주자에게 적합할 것 같아요")
            footer.customTextView.text = summary
            footer.delegate = self
            
            return footer
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == items.count - 1 {
            return CGSize(width: collectionView.bounds.width, height: 300)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        
        switch section {
        case 1, 2, 3:
            let width = collectionView.bounds.width - 40
            return CGSize(width: width, height: 52)
        case 4, 5, 6:
            let width = (collectionView.bounds.width - 40 - 10) / 2
            return CGSize(width: width, height: 52)
        default:
            let width = collectionView.bounds.width - 40
            return CGSize(width: width, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets(top: 28, left: 20, bottom: 40, right: 20)
        case 7:
            return UIEdgeInsets(top: 8, left: 20, bottom: 120, right: 20)
        default:
            return UIEdgeInsets(top: 8, left: 20, bottom: 40, right: 20)
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func didTapButton(title: String, text: String) {
        let childVC = CommonTextViewViewComtroller(title: title, text: text)
        
        childVC.onDataSend = { [weak self] data in
            guard let self = self else { return }
            
            baseInfo.summary = data
            updateSectionState(index: 7, newState: baseInfo.summary != "" ? TextFieldState.done : TextFieldState.normal)
            self.summary = data
            let lastSection = self.items.count - 1
            let footerIndexPath = IndexPath(item: 0, section: lastSection)
            self.collectionView.reloadSections(IndexSet(integer: footerIndexPath.section))
        }
        navigationController?.pushViewController(childVC, animated: true)
    }
}
