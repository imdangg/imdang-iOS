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
    
    private var notiType: NotiType?
    var tapAction: ((NotiType) -> Void)?
    
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
    
    func configure(type: NotiType, userName: String) {
        self.notiType = type
        
        switch type {
        case .request_accept :
            titleLabel.text = "내가 요청한 내역"
            titleLabel.textColor = .darkBlue
            paddingView.backgroundColor = .lightBlue
            timeLabel.text = "방금 전"
            scriptLabel.text = "\(userName)님이 인사이트 교환을 수락했어요.\n교환한 인사이트를 보관함에서 확인해보세요."
            actionButton.setButtonTitle(title: "보관함 확인하기")
           
        case .request_reject :
            titleLabel.text = "내가 요청한 내역"
            titleLabel.textColor = .darkBlue
            paddingView.backgroundColor = .lightBlue
            timeLabel.text = "20초 전"
            scriptLabel.text = "\(userName)님이 인사이트 교환을 거절했어요."
            actionButton.setButtonTitle(title: "다시 요청하기")
          
        case .response :
            titleLabel.text = "요청 받은 내역"
            timeLabel.text = "1개월 전"
            titleLabel.textColor = .mainOrange500
            paddingView.backgroundColor = .mainOrange50
            scriptLabel.text = "\(userName)님이 인사이트 교환을 요청했어요.\n인사이트 확인 후 수락 및 거절을 선택해주세요."
            actionButton.setButtonTitle(title: "인사이트 확인하기")
          
        }
    }
    
    private func bind() {
        actionButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self, let type = self.notiType else { return }
                self.tapAction?(type)
            })
            .disposed(by: disposeBag)
    }
}
