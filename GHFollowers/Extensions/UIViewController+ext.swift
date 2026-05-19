import SafariServices
import UIKit

fileprivate var containerView: UIView!

extension UIViewController {
    
    func presentGFAlertOnMainThread(title: String, message: String?, buttonTitle: String){
        DispatchQueue.main.async {
            
            let alertVC = GFAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            
            self.present(alertVC, animated: true)
        }
    }
    
    func showLoadingView(){
        
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            containerView.alpha = 0.8
        }
        
        let loader = UIActivityIndicatorView(style: .large)
        containerView.addSubview(loader)
        
        loader.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
        
        loader.startAnimating()
    }
    
    func dismissLoadingView(){
        DispatchQueue.main.async {
            containerView.removeFromSuperview()
            containerView = nil
        }
    }
    
    func showEmptyStateView(with message: String){
        let emptyStateView = EmptyStateView(with: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
    
    func add(childVc: UIViewController, parentView containerView: UIView, parentVC: UIViewController){
        parentVC.addChild(childVc)
        containerView.addSubview(childVc.view)
        childVc.view.frame = containerView.bounds
        childVc.didMove(toParent: parentVC)
    }
    
    func presentSafariVC(with url: String?){
        guard let url = URL(string: url ?? "") else {
            presentGFAlertOnMainThread(title: "Invalid URL", message: "The URL is not valid", buttonTitle: "Ok")
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}

