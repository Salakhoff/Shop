import UIKit

final class ActivityIndicatorCell: UITableViewCell {
    
    static var identifier = "ActivityIndicatorCell"
    
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard superview != nil else {
            return
        }
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimation() {
        activityIndicator.stopAnimating()
    }
}

