//
//  AreaListTableCell.swift
//  imdang
//
//  Created by 임대진 on 12/16/24.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

class AreaListTableCell: UITableViewCell {
    static let identifier = "AreaListTableCell"
    private let disposeBag = DisposeBag()
    
    private let locationnLabel = UILabel().then {
        $0.font = .pretenMedium(16)
        $0.textColor = .grayScale900
    }
    
    private let zoneLabel = UILabel().then {
        $0.text = "단지"
        $0.font = .pretenMedium(14)
        $0.textColor = .grayScale700
    }
    
    private let insightLabel = UILabel().then {
        $0.text = "인사이트"
        $0.font = .pretenMedium(14)
        $0.textColor = .grayScale700
    }
    
    private let zoneCountLabel = UILabel().then {
        $0.font = .pretenMedium(14)
        $0.textColor = .mainOrange500
    }
    
    private let insightCountLabel = UILabel().then {
        $0.font = .pretenMedium(14)
        $0.textColor = .mainOrange500
    }
    
    private let lineView = UIImageView().then {
        $0.backgroundColor = .grayScale100
    }
    
    private let selectButton = RadioButtonView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview()
        makeConstraints()
    }
    
    override func prepareForReuse() {
        locationnLabel.text =  ""
        zoneCountLabel.text = ""
        insightCountLabel.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        self.selectButton.isSelect = selected ? true : false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        [locationnLabel, zoneLabel, zoneCountLabel, insightLabel, insightCountLabel, lineView, selectButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func makeConstraints() {
        locationnLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        zoneLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        zoneCountLabel.snp.makeConstraints {
            $0.leading.equalTo(zoneLabel.snp.trailing).offset(4)
            $0.centerY.equalTo(zoneLabel.snp.centerY)
        }
        
        lineView.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(14)
            $0.leading.equalTo(zoneCountLabel.snp.trailing).offset(8)
            $0.centerY.equalTo(zoneLabel.snp.centerY)
        }
        
        insightLabel.snp.makeConstraints {
            $0.leading.equalTo(lineView.snp.trailing).offset(8)
            $0.centerY.equalTo(zoneLabel.snp.centerY)
        }
        
        insightCountLabel.snp.makeConstraints {
            $0.leading.equalTo(insightLabel.snp.trailing).offset(4)
            $0.centerY.equalTo(zoneLabel.snp.centerY)
        }
        
        selectButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
    
    func config(address: AddressData) {
        locationnLabel.text =  address.toAddress()
        zoneCountLabel.text = "\(address.apartmentComplexCount)개"
        insightCountLabel.text = "\(address.insightCount)개"
    }
}
