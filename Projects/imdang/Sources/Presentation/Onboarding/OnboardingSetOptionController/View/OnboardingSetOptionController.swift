
import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import SnapKit
import Then

final class OnboardingSetOptionController: UIViewController, View {

    var disposeBag = DisposeBag()

    private let backButton = UIButton(type: .system).then {
        $0.setTitle("뒤로가기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16)
    }

    private let stepView = StepView()

    init(reactor: OnboardingSetOptionReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground

        view.addSubview(backButton)
        view.addSubview(stepView)

        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.leading.equalToSuperview().inset(20)
        }

        stepView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func bind(reactor: OnboardingSetOptionReactor) {
        stepView.optionSelected
            .map { Reactor.Action.optionSelected }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        backButton.rx.tap
            .map { Reactor.Action.goBack }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.stepData }
            .distinctUntilChanged { $0.title == $1.title }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                UIView.transition(with: self.stepView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    self.stepView.configure(with: data)
                })
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.currentStep == 0 }
            .distinctUntilChanged()
            .bind(to: backButton.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
