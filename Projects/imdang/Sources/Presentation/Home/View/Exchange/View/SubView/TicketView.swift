//
//  TicketView.swift
//  imdang
//
//  Created by daye on 12/4/24.
//

import UIKit
import SnapKit
import Then

final class TicketView: UIView {
    
    private let iconImageView = UIImageView().then {
        $0.image = UIImage(named: "Ticket")
        $0.contentMode = .scaleAspectFit
    }
    
    private let textLabel = UILabel().then {
        $0.text = "보유 패스권"
        $0.font = .pretenSemiBold(16)
        $0.textColor = .grayScale600
        $0.numberOfLines = 0
    }
    
    private let ticketNumberLabel = UILabel().then {
        $0.text = "2개"
        $0.font = .pretenSemiBold(16)
        $0.textColor = .mainOrange500
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .mainOrange50
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        
        addSubview(iconImageView)
        addSubview(textLabel)
        addSubview(ticketNumberLabel)
        
         iconImageView.snp.makeConstraints {
             $0.size.equalTo(CGSize(width: 20, height: 20))
             $0.leading.equalToSuperview().inset(20)
             $0.top.bottom.equalToSuperview().inset(17)
         }
         
         textLabel.snp.makeConstraints {
             $0.leading.equalTo(iconImageView.snp.trailing).offset(4)
             $0.top.bottom.equalToSuperview().inset(16)
         }
        
        ticketNumberLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview().inset(16)
        }
    }
    
    func configure(ticketNum: Int) {
        ticketNumberLabel.text = "\(ticketNum)개"
    }
}