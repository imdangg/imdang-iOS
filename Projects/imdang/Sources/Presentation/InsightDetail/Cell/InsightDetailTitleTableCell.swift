//
//  InsightDetailTitleTableCell.swift
//  imdang
//
//  Created by 임대진 on 1/13/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class InsightDetailTitleTableCell: UITableViewCell {
    static let identifier = "InsightDetailTitleTableCell"
    private var disposeBag = DisposeBag()
    
    private let backView = UIView()
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = ImdangImages.Image(resource: .person)
        $0.layer.cornerRadius = 28.8 / 2
        $0.clipsToBounds = true
    }
    
    private let userNameLabel = UILabel().then {
        $0.font = .pretenMedium(16)
        $0.textColor = .grayScale700
    }
    
    private let likeButton = ImageTextButton(type: .imageFirst, horizonPadding: 12, spacing: 2).then {
        $0.customText.textColor = .grayScale700
        $0.customText.font = .pretenMedium(14)
        
        $0.customImage.image = ImdangImages.Image(resource: .good).withRenderingMode(.alwaysTemplate)
        $0.customImage.tintColor = .grayScale700
        $0.imageSize = 16
        
        $0.layer.borderColor = UIColor.grayScale100.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 4
    }
    
    private var likeCount = 0
    
    private var isLike: Bool = false {
        didSet {
            if isLike {
                likeButton.backgroundColor = .mainOrange50
                likeButton.customImage.tintColor = .mainOrange500
                likeButton.customText.textColor = .mainOrange500
                likeButton.layer.borderColor = UIColor.mainOrange500.cgColor
                likeButton.customText.text = "추천 \(likeCount + 1)"
            } else {
                likeButton.backgroundColor = .white
                likeButton.customImage.tintColor = .grayScale700
                likeButton.customText.textColor = .grayScale700
                likeButton.layer.borderColor = UIColor.grayScale100.cgColor
                likeButton.customText.text = "추천 \(likeCount)"
            }
        }
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .pretenBold(22)
        $0.textColor = .grayScale900
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        makeConstraints()
        bindAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        [profileImageView, userNameLabel, likeButton, titleLabel].forEach { backView.addSubview($0) }
        contentView.addSubview(backView)
    }
    
    private func makeConstraints() {
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width)
            $0.height.equalTo(123).priority(999)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(26)
            $0.leading.equalToSuperview().offset(21.6)
            $0.width.height.equalTo(28.8)
        }
        userNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(5.6)
        }
        
        likeButton.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(36)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(11.6)
            $0.leading.equalToSuperview().offset(20)
        }
    }
    
    private func bindAction() {
        likeButton.rx.tap
            .subscribe(onNext: {
                self.isLike.toggle()
            })
            .disposed(by: disposeBag)
    }
    
    func config(info: InsightDetail) {
        profileImageView.image = ImdangImages.Image(resource: .person)
        userNameLabel.text = "홍길동"
        likeCount = 0
        likeButton.customText.text = "추천 \(0)"
        titleLabel.text = info.title
    }
}
