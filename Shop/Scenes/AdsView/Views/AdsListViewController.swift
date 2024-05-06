import UIKit
import RxCocoa
import RxSwift
import RxDataSources

final class AdsListViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: AdsViewModel
    private let disposeBag = DisposeBag()
    
    private lazy var dataSourse = RxTableViewSectionedAnimatedDataSource<AdsSection> { dataSourse, tableView, indexPath, item in
        switch item {
        case .activityIndecator:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ActivityIndicatorCell.identifier,
                for: indexPath
            ) as? ActivityIndicatorCell else {
                return UITableViewCell()
            }
            
            cell.startAnimating()
            return cell
            
        case.ad(let ad):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: AdsListCell.identifier,
                for: indexPath
            ) as? AdsListCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: ad)
            return cell
        }
    }
    
    // MARK: Outlets
    private let adsTableView = UITableView()
    private let headlineActivityIndicator = UIActivityIndicatorView()
    
    // MARK: Init
    
    init(viewModel: AdsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LifeCcyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        embedViews()
        setupAppearance()
        setupLayout()
    }
}

// MARK: - EmbedViews

private extension AdsListViewController {
    func embedViews() {
        adsTableView.translatesAutoresizingMaskIntoConstraints = false
        headlineActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(adsTableView)
        view.addSubview(headlineActivityIndicator)
    }
}

// MARK: - SetupAppearance

private extension AdsListViewController {
    func setupAppearance() {
        title = "News"
        
        view.backgroundColor = .white
        
        adsTableView.backgroundColor = .clear
        
        configureTableView()
    }
    
    func configureTableView() {
        adsTableView.register(AdsListCell.self, forCellReuseIdentifier: AdsListCell.identifier)
        adsTableView.register(ActivityIndicatorCell.self, forCellReuseIdentifier: ActivityIndicatorCell.identifier)
        
        adsTableView.rx
            .contentOffset
            .map(\.y)
            .filter { [unowned self] y in
                let height = adsTableView.frame.size.height
                let distanceFromBottom = adsTableView.contentSize.height - y
                return distanceFromBottom < height
            }
            .throttle(.seconds(3), latest: true, scheduler: MainScheduler.instance)
            .map {_ in }
            .bind(to: viewModel.nextPageLoadingTrigger)
            .disposed(by: disposeBag)
        
        adsTableView.rx
            .itemSelected
            .subscribe { [weak self] indexPath in
                guard let self else { return }
                self.adsTableView.deselectRow(at: indexPath, animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel
            .ads
            .drive(
                adsTableView.rx.items(dataSource: dataSourse)
            )
            .disposed(by: disposeBag)
    }
}

// MARK: - SetupLayout

private extension AdsListViewController {
    func setupLayout() {
        NSLayoutConstraint.activate([
            adsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            adsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            adsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            adsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            headlineActivityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headlineActivityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
