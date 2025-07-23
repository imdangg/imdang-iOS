//
//  StorageBoxContainerViewController.swift
//  imdang
//
//  Created by 임대진 on 2/2/25.
//

import UIKit
import SnapKit
import Then
import RxSwift

class StorageBoxContainerViewController: UIViewController {
    private var disposeBag = DisposeBag()
    private let serverService = ServerJoinService.shared
    private let emptyView = StorageBoxEmptyViewController()
    private let storageBoxViewController = StorageBoxViewController()
    private let storageBoxViewModel = StorageBoxViewModel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        serverService.checkTokenExpired()
    }
    
    private func addSubviews() {
        addChild(emptyView)
        addChild(storageBoxViewController)
        
        [emptyView.view, storageBoxViewController.view].forEach { view.addSubview($0) }
        
        emptyView.didMove(toParent: self)
        storageBoxViewController.didMove(toParent: self)
    }
    
    private func setView() {
        storageBoxViewModel.loadMyDistricts()
            .subscribe(with: self) { owner, data in
                if let data = data, !data.isEmpty {
                    owner.emptyView.view.isHidden = true
                    owner.storageBoxViewController.config(addresses: data)
                } else {
                    owner.storageBoxViewController.view.isHidden = true
                }
            }
            .disposed(by: disposeBag)
    }
}
