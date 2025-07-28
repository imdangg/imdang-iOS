
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class StepView: UIView {

    let optionSelected = PublishRelay<Void>()
    private let disposeBag = DisposeBag()

    private var options: [String] = []
    private var selectedIndex: Int?

    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(OptionCell.self, forCellReuseIdentifier: OptionCell.identifier)
        $0.separatorStyle = .none
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
        $0.rowHeight = 72
        $0.contentInset.bottom = 40
    }
    
    private let headerContainerView = UIView()
    
    private let titleLabel = UILabel().then {
        $0.font = .pretenBold(24)
        $0.textColor = .grayScale800
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    private let subTitleLabel = UILabel().then {
        $0.font = .pretenMedium(18)
        $0.textAlignment = .left
        $0.textColor = .newLightGrayScale
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with data: StepData) {
        self.options = data.options
        self.selectedIndex = nil
        
        titleLabel.text = data.title
        subTitleLabel.text = data.subTitle
        
        updateHeaderViewHeight()
        
        tableView.reloadData()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        headerContainerView.addSubview(titleLabel)
        headerContainerView.addSubview(subTitleLabel)
        
        tableView.tableHeaderView = headerContainerView
        
        headerContainerView.snp.makeConstraints {
            $0.width.equalTo(tableView.snp.width)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(40)
        }
    }
    
    private func updateHeaderViewHeight() {
        headerContainerView.setNeedsLayout()
        headerContainerView.layoutIfNeeded()
        let height = headerContainerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var frame = headerContainerView.frame
        frame.size.height = height
        headerContainerView.frame = frame
        tableView.tableHeaderView = headerContainerView
    }
}

extension StepView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OptionCell.identifier, for: indexPath) as? OptionCell else {
            return UITableViewCell()
        }
        
        let text = options[indexPath.row]
        let state: OptionState = (indexPath.row == selectedIndex) ? .selected : .normal
        
        cell.configure(text: text, state: state)
        
        return cell
    }
}

extension StepView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard selectedIndex != indexPath.row else { return }
        
        let newIndex = indexPath.row
        var indexPathsToReload: [IndexPath] = []
        
        indexPathsToReload.append(indexPath)
        
        if let oldIndex = selectedIndex {
            indexPathsToReload.append(IndexPath(row: oldIndex, section: 0))
        }
        
        self.selectedIndex = newIndex
        
        tableView.reloadRows(at: indexPathsToReload, with: .none)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.optionSelected.accept(())
        }
    }
}
