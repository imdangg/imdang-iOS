//
//  ItemCell.swift
//  imdang
//
//  Created by daye on 8/18/25.
//

import Foundation
import UIKit

class ItemCell: UICollectionViewCell {
    static let identifier = "ItemCell"

    var isSelectedItem: Bool = false {
        didSet {
            let textColor: UIColor = isSelectedItem ? .mainOrange500 : .grayScale800
            let isUnderlineHidden: Bool = !isSelectedItem
            let setFont: UIFont = isSelectedItem ? .pretenSemiBold(16) : .pretenRegular(16)
            
            titleLabel.textColor = textColor
            underlineView.isHidden = isUnderlineHidden
            titleLabel.font = setFont
        }
    }

    private let titleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .grayScale800
    }

    private let underlineView = UIView().then {
        $0.backgroundColor = .mainOrange500
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        isSelectedItem = false
    }

    private func setupHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(underlineView)
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        underlineView.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.width.equalTo(titleLabel.snp.width)
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.height.equalTo(1.5)
        }
    }

    func configure(with title: String) {
        titleLabel.text = title
    }
}

