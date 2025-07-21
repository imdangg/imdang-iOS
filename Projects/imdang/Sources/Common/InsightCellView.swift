//
//  InsightCellView.swift
//  SharedLibraries
//
//  Created by 임대진 on 12/8/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

enum DirectionType {
    case vertical
    case horizontal
}

final class InsightCellView: UIView {
    var directionType: DirectionType? {
        didSet {
            guard let type = directionType else { return }
            resetConstraints()
            configureLayout(type: type)
        }
    }
    
    let titleImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
    }
    
    let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = ImdangImages.Image(resource: .person)
        $0.clipsToBounds = true
    }
    
    // 라밸 패딩이 adressLabel는 이미지 들어가서 상하 기준이 안맞음.. 피그마로 비교해서 맞춰놨어여
    let adressLabel = PaddingLabel().then {
        $0.textAlignment = .center
        $0.backgroundColor = .grayScale50
        $0.layer.cornerRadius = 2
        $0.clipsToBounds = true
        $0.padding = UIEdgeInsets(top: 2.5, left: 8, bottom: 2.5, right: 8)
    }
    
    let likeLabel = PaddingLabel().then {
        $0.textAlignment = .center
        $0.backgroundColor = .mainOrange50
        $0.layer.cornerRadius = 2
        $0.textColor = .mainOrange500
        $0.font = UIFont.pretenMedium(12)
        $0.clipsToBounds = true
    }
    
    let titleLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .grayScale900
        $0.font = UIFont.pretenMedium(16)
    }
    
    let userNameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .grayScale700
        $0.font = UIFont.pretenMedium(14)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubView() {
        [titleImageView, profileImageView, adressLabel, likeLabel, titleLabel, userNameLabel].forEach {
            self.addSubview($0)
        }
    }
    
    func resetConstraints() {
        [titleImageView, profileImageView, adressLabel, likeLabel, titleLabel, userNameLabel].forEach {
            $0.snp.removeConstraints()
        }
    }

    private func createAttributedString(image: UIImage, text: String) -> NSAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = image.withRenderingMode(.alwaysOriginal)
        attachment.bounds = CGRect(x: 0, y: 0, width: 12, height: 12)
        
        let imageString = NSAttributedString(attachment: attachment)
        let textString = NSAttributedString(string: " \(text)", attributes: [
            .font: UIFont.pretenMedium(12),
            .foregroundColor: UIColor.grayScale700,
            .baselineOffset: 2
        ])
        
        let combined = NSMutableAttributedString()
        combined.append(imageString)
        combined.append(textString)
        
        return combined
    }
    
    private func configureLayout(type: DirectionType) {
        switch type {
        case .horizontal:
            configureHorizontalLayout()
        case .vertical:
            configureVerticalLayout()
        }
    }

    private func configureHorizontalLayout() {
        titleImageView.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.top.leading.equalToSuperview()
        }
        adressLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(2.5)
            $0.leading.equalTo(titleImageView.snp.trailing).offset(16)
        }
        likeLabel.snp.makeConstraints {
            $0.top.equalTo(adressLabel.snp.top)
            $0.leading.equalTo(adressLabel.snp.trailing).offset(4)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(adressLabel.snp.bottom).offset(12)
            $0.leading.equalTo(adressLabel.snp.leading)
        }
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(22)
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalTo(adressLabel.snp.leading)
        }
        userNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(4)
        }
    }

    private func configureVerticalLayout() {
        titleImageView.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(160)
            $0.centerX.top.equalToSuperview()
        }
        adressLabel.snp.makeConstraints {
            $0.top.equalTo(titleImageView.snp.bottom).offset(16)
            $0.leading.equalTo(titleImageView)
        }
        likeLabel.snp.makeConstraints {
            $0.top.equalTo(titleImageView.snp.bottom).offset(16)
            $0.leading.equalTo(adressLabel.snp.trailing).offset(4)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(adressLabel.snp.bottom).offset(12)
            $0.leading.equalTo(titleImageView)
        }
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(22)
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalTo(titleImageView)
        }
        userNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(4)
        }
    }
    
    func configure(insight: Insight, layoutType: DirectionType) {
        self.directionType = layoutType
        if let imageUrl = insight.mainImageUrl, let url = URL(string: imageUrl) {
            titleImageView.kf.setImage(with: url)
        } else {
            titleImageView.image = UIImage()
        }
        profileImageView.image = ImdangImages.Image(resource: .person)
        
        adressLabel.attributedText = createAttributedString(image: ImdangImages.Image(resource: .location), text: insight.adress)
        likeLabel.text = "추천 \(insight.likeCount)"
        titleLabel.text = insight.titleName
        userNameLabel.text = insight.userName
    }
}
