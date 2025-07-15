//
//  OnboardingPageViewController.swift
//  imdang
//
//  Created by 임대진 on 11/13/24.
//

import UIKit
import RxSwift
import RxRelay

class OnboardingPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    private let pages: [UIViewController]
    private var disposeBag = DisposeBag()
    private var pageControl = UIPageControl()
    let crrentPageIndex = BehaviorRelay<Int>(value: 0)
    
    init() {
        let page1 = OnboardingViewController(title: "가이드로 인사이트 작성하기", description: "가이드라인으로 체계화된 인사이트를\n간편하게 작성할 수 있어요", image: ImdangImages.Image(resource: .guideImage1))
        let page2 = OnboardingViewController(title: "인사이트 교류하기", description: "양질의 인사이트를 주고받으며\n가치 있는 임장 인사이트를 교환하세요", image: ImdangImages.Image(resource: .guideImage2)).then { $0.showButton() }
        let page3 = OnboardingViewController(title: "다양한 인사이트 모으기", description: "추천한 인사이트와 작성한 인사이트를\n보관함에서 편리하게 관리하세요", image: ImdangImages.Image(resource: .guideImage3))
        
        pages = [page1, page2, page3]
        
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .grayScale50
        dataSource = self
        delegate = self
        
        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
        setupPageControl()
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .grayScale100
        pageControl.currentPageIndicatorTintColor = .mainOrange500
        
        view.addSubview(pageControl)
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(8)
            $0.bottom.equalToSuperview().offset(-234)
        }
    }
    
    func goToNextPage() {
        if let currentVC = viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentVC) {
            if currentIndex + 1 < pages.count {
                let nextVC = pages[currentIndex + 1]
                setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
                pageControl.currentPage += 1
                crrentPageIndex.accept(pageControl.currentPage)
            } else {
                let vc = UserInfoEntryViewController(reactor: UserInfoEntryReactor())
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController), currentIndex > 0 else {
            return nil
        }
        return pages[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController), currentIndex < pages.count - 1 else {
            return nil
        }
        return pages[currentIndex + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleVC = viewControllers?.first, let index = pages.firstIndex(of: visibleVC) {
            pageControl.currentPage = index
            crrentPageIndex.accept(index)
        }
    }
}
