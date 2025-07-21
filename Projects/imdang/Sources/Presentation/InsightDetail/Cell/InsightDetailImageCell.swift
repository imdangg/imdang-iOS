//
//  InsightDetailImageCell.swift
//  imdang
//
//  Created by 임대진 on 1/14/25.
//

import UIKit
import Then
import SnapKit
import RxSwift

final class InsightDetailImageCell: UITableViewCell {
    static let identifier = "InsightDetailImageCell"
    
    private let disposeBag = DisposeBag()
    private let currentPage = PublishSubject<Int>()
    private var images: [UIImage]?
    private var imageUrlStrings: [String] = []
    private var imageCount: Int = 0

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 300)
        layout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
            $0.register(cell: HorizontalImageCell.self)
            $0.showsHorizontalScrollIndicator = false
            $0.isPagingEnabled = true
            $0.dataSource = self
            $0.delegate = self
        }
        return collectionView
    }()
    
    private let pageControl = UIPageControl().then {
        $0.currentPage = 0
        $0.pageIndicatorTintColor = .grayScale100
        $0.currentPageIndicatorTintColor = .mainOrange500
        $0.isUserInteractionEnabled = false
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        contentView.addSubview(pageControl)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(300).priority(999)
        }
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(collectionView.snp.bottom).offset(-8)
        }
        
        bindAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindAction() {
        currentPage
            .subscribe(onNext: { [weak self] currentPage in
                self?.pageControl.currentPage = currentPage
            })
            .disposed(by: disposeBag)
    }
    
    func config(url: [String], mainImage: [UIImage]? = nil) {
        // 인사이트 작성후 보여지는 이미지 필요시
        if let image = mainImage {
            images = image
            imageCount = image.count
        } else {
            imageUrlStrings = url + url + url
            imageCount = imageUrlStrings.count
        }
        pageControl.numberOfPages = imageCount
    }

}

extension InsightDetailImageCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath, cellType: HorizontalImageCell.self)
        if let images = images {
            cell.config(url: "", mainImage: images[indexPath.item])
        } else {
            cell.config(url: imageUrlStrings[indexPath.item])
        }
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        currentPage.onNext(page)
    }
}

class HorizontalImageCell: UICollectionViewCell {
    static let identifier = "HorizontalImageCell"
    
    private let insightImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(insightImageView)
        
        insightImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        insightImageView.image = UIImage()
    }
    
    func config(url: String, mainImage: UIImage? = nil) {
        // 인사이트 작성후 보여지는 이미지 필요시
        if let image = mainImage {
            insightImageView.image = image
        } else {
            guard let url = URL(string: url) else {
                insightImageView.image = UIImage()
                return
            }
            insightImageView.kf.setImage(with: url)
        }
    }
}
