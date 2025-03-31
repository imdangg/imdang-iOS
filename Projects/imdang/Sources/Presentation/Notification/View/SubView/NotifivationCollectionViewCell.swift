//
//  CustomCollectionViewCell.swift
//  segmentedControl
//
//  Created by daye on 1/20/25.
//

import UIKit
import SnapKit
import Then
import RxSwift

class NotifivationCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "NotifivationCollectionViewCell"
    
    private let paddingView = UIView().then {
        $0.layer.cornerRadius = 4
        $0.layer.masksToBounds = true
    }

    private let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .pretenSemiBold(12)
        $0.textAlignment = .center
    }
    
    private let timeLabel = UILabel().then {
        $0.textColor = .grayScale500
        $0.font = .pretenMedium(12)
    }
    
    private let scriptLabel = UILabel().then {
        $0.textColor = .grayScale900
        $0.font = .pretenMedium(16)
        $0.numberOfLines = 0
    }
    
    private let actionButton = CommonButton(title: "", initialButtonType: .unselectedBorderStyle).then {
        $0.setButtonTitleColor(color: .grayScale700)
    }
    
    private var imdangNoti: ImdangNotification?
    var tapAction: ((ImdangNotification) -> Void)?
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.grayScale200.cgColor
        setupViews()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [paddingView, titleLabel, timeLabel, scriptLabel, actionButton].forEach {addSubview($0)}
        
        paddingView.snp.makeConstraints {
            $0.edges.equalTo(titleLabel).inset(UIEdgeInsets(top: -1, left: -8, bottom: -1, right: -8))
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(24)
            $0.height.equalTo(25)
        }
        
        timeLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        scriptLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        actionButton.snp.makeConstraints {
            $0.top.equalTo(scriptLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(42)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
//    enum NotificationCategory: String {
//        case requested = "REQUESTED"
//        case accepted = "ACCEPTED"
//        case rejected = "REJECTED"
//        case requestedByCoupon = "REQUESTED_BY_COUPON"
//    }

    
    func configure(notification: ImdangNotification) {
        let category = notification.category
        
        func formatTimeAgo(from date: Date) -> String {
            let now = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.minute, .hour, .day, .month], from: date, to: now)
            
            if let minute = components.minute, minute < 1 {
                return "방금 전"
            } else if let minute = components.minute, minute < 60 {
                return "\(minute)분 전"
            } else if let hour = components.hour, hour < 24 {
                return "\(hour)시간 전"
            } else if let day = components.day, day < 30 {
                return "\(day)일 전"
            } else if let month = components.month, month < 12 {
                return "\(month)개월 전"
            } else {
                return "오래 전"
            }
        }
        
        switch category {
        case NotificationCategory.requestedByCoupon.rawValue, NotificationCategory.requested.rawValue :
            titleLabel.text = "내가 요청한 내역"
            titleLabel.textColor = .darkBlue
            paddingView.backgroundColor = .lightBlue
            timeLabel.text = formatTimeAgo(from: notification.createdAt)
            scriptLabel.text = notification.message
            actionButton.setButtonTitle(title: "보관함 확인하기")
            
        case NotificationCategory.rejected.rawValue:
            titleLabel.text = "내가 요청한 내역"
            titleLabel.textColor = .darkBlue
            paddingView.backgroundColor = .lightBlue
            timeLabel.text = formatTimeAgo(from: notification.createdAt)
            scriptLabel.text = notification.message
            actionButton.setButtonTitle(title: "다시 요청하기")
            
        case NotificationCategory.accepted.rawValue:
            titleLabel.text = "요청 받은 내역"
            titleLabel.textColor = .mainOrange500
            paddingView.backgroundColor = .mainOrange50
            timeLabel.text = formatTimeAgo(from: notification.createdAt)
            scriptLabel.text = notification.message
            actionButton.setButtonTitle(title: "인사이트 확인하기")
            
        default:
            break
        }
    }
    
    private func bind() {
        actionButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self, let notification = self.imdangNoti else { return }
                self.tapAction?(notification)
            })
            .disposed(by: disposeBag)
    }
}
