
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
    private let newView = PrioritySettingView()
    private let doneView = DoneView()
    
    init(reactor: OnboardingSetOptionReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        [stepView, newView, doneView].forEach { view.addSubview($0) }
        view.addSubview(backButton)
        
        newView.isHidden = true
        doneView.isHidden = true
        
        [stepView, newView, doneView].forEach { view in
            view.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.leading.equalToSuperview().inset(20)
        }
    }
    
    func bind(reactor: OnboardingSetOptionReactor) {
        stepView.optionSelected.map { OnboardingSetOptionReactor.Action.optionSelected }.bind(to: reactor.action).disposed(by: disposeBag)
        newView.nextButton.rx.tap.map { OnboardingSetOptionReactor.Action.completeNewView }.bind(to: reactor.action).disposed(by: disposeBag)
        backButton.rx.tap.map { OnboardingSetOptionReactor.Action.goBack }.bind(to: reactor.action).disposed(by: disposeBag)
        
        reactor.state.map { $0.stepData }.distinctUntilChanged().observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] data in
                guard let self = self else { return }
                UIView.transition(with: self.stepView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    self.stepView.configure(with: data)
                })
            }).disposed(by: disposeBag)
        
        reactor.state.map { $0.currentPage }.distinctUntilChanged().observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] page in
                guard let self = self else { return }
                self.stepView.isHidden = (page != .step)
                self.newView.isHidden = (page != .new)
                self.doneView.isHidden = (page != .done)
                
                if page == .done {
                    self.doneView.play { finished in
                        if finished {
                            print("온보딩 완")
                        }
                    }
                }
            }).disposed(by: disposeBag)
        
        reactor.state.map { $0.currentPage == .step && $0.currentStep == 0 }.distinctUntilChanged()
            .bind(to: backButton.rx.isHidden).disposed(by: disposeBag)
    }
}
