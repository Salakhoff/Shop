import UIKit

final class AdsListCell: UITableViewCell {
    
    static var identifier: String {
        "AdsListCell"
    }
    
    // MARK: Outlets
    
    private let adTitleLabel = UILabel()
    private let adDescriptionLabel = UILabel()
    private let adCategotyLabel = UILabel()
    private let stackView = UIStackView()
    
    // MARK: Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        embedViews()
        setupAppearance()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LiveCycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.adTitleLabel.text = nil
        self.adDescriptionLabel.text = nil
        self.adCategotyLabel.text = nil
    }
    
    // MARK: Configure
    
    func configure(with viewModel: Ad) {
        self.adTitleLabel.text = viewModel.title
        self.adDescriptionLabel.text = viewModel.description
        self.adCategotyLabel.text = viewModel.category.title
    }
}

// MARK: - EmbedViews

private extension AdsListCell {
    func embedViews() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(adTitleLabel)
        stackView.addArrangedSubview(adDescriptionLabel)
        stackView.addArrangedSubview(adCategotyLabel)
        
        contentView.addSubview(stackView)
    }
}

// MARK: - SetupAppearance

private extension AdsListCell {
    func setupAppearance() {
        
        stackView.axis = .vertical
        stackView.spacing = 5
        
        adTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        adDescriptionLabel.font = UIFont.systemFont(ofSize: 15)
        adCategotyLabel.font = UIFont.systemFont(ofSize: 13)
        
        adTitleLabel.numberOfLines = 0
        adDescriptionLabel.numberOfLines = 0
        adCategotyLabel.numberOfLines = 0
        
    }
}

// MARK: - SetupLayout

private extension AdsListCell {
    func setupLayout() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
}
