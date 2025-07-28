//
//  OptionCell.swift
//  imdang
//
//  Created by daye on 7/28/25.
//

import UIKit
import SnapKit
import Then

enum OptionState {
    case normal
    case selected
}

final class OptionCell: UITableViewCell {
    
    static let identifier = "OptionCell"
    
    private let optionView = OptionView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        optionView.isUserInteractionEnabled = false
        contentView.addSubview(optionView)
        
        optionView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    func configure(text: String, state: OptionState) {
        optionView.configure(text: text)
        optionView.setState(state)
    }
}

final class OptionView: UIControl {
    
    private let iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .pretenMedium(16)
        $0.textColor = .grayScale900
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setState(.normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String) {
        titleLabel.text = text
    }
    
    func setState(_ state: OptionState) {
        let tintColor: UIColor = (state == .selected) ? .orange : .lightGray
        iconImageView.image = UIImage(systemName: "record.circle")?
            .withTintColor(tintColor, renderingMode: .alwaysOriginal)
    }
    
    private func setupUI() {
        backgroundColor = .grayScale25
        layer.cornerRadius = 8
        clipsToBounds = true
        
        [iconImageView, titleLabel].forEach { addSubview($0) }
        
        self.snp.makeConstraints {
            $0.height.equalTo(64)
        }
        
        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
}
