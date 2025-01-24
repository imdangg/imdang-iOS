//
//  InsightTotalAppraisalView.swift
//  imdang
//
//  Created by 임대진 on 1/3/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

protocol TotalAppraisalFootereViewDelegate: AnyObject {
    func didTapButton(title: String, text: String)
}

class InsightTotalAppraisalFooterView: UICollectionReusableView {
    static let identifier = "InsightTotalAppraisalFooterView"
    weak var delegate: TotalAppraisalFootereViewDelegate?
    
    let customTextView = CommonTextViewButton(title: "", placeHolder: "")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customTextView.delegate = self
        addSubviews()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        [customTextView].forEach { addSubview($0) }
    }
    
    private func makeConstraints() {
        customTextView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25.5)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(208)
        }
    }
    
    func config(title: String) {
        customTextView.titleLabel.text = title
        let attributedString = NSMutableAttributedString(string: title)
        let range = (title as NSString).range(of: "*")
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
        
        customTextView.titleLabel.attributedText = attributedString
    }
    
    func setPlaceHolder(text: String) {
        customTextView.placeholderLabel.text = text
    }
    
}


extension InsightTotalAppraisalFooterView: CustomTextViewDelegate {
    func customTextViewDidTap(_ commonTextView: CommonTextViewButton) {
        self.delegate?.didTapButton(title: self.customTextView.titleLabel.text ?? "", text: self.customTextView.text)
    }
}
