
import UIKit
import SafariServices

class UserInfoVC: UIViewController {
        
    private var vm: UserInfoVM
    private var headerView = UIView()
    private var githubCard = UIView()
    private var followersCard = UIView()
    private var userSinceLabel = GFBodyLabel(textAlignment: .center)
    weak var delegate: FollowerVCDelegate?

    init(username: String) {
        vm = UserInfoVM(username: username)
        super.init(nibName: nil, bundle: nil)
        
        vm.getUserData{ [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let user):
                self.vm.user = user 
                DispatchQueue.main.async {
                    self.configureUI()
                    self.layoutUI()
                    self.configureFavToggleBtn()
                }
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        
        guard let user = vm.user else {return}
        
        self.userSinceLabel.text = "Github user since \(user.createdAt?.convertToDisplayFormat() ?? "N/A")"
        
        let githubCardVC = GFDetailCard(
            count1: user.publicRepos,
            count2: user.pubicGists,
            card: .githubCard
        )
        githubCardVC.delegate = self
        
        let followerCardVC = GFDetailCard(
            count1: user.following,
            count2: user.followers,
            card: .FollowerCard
        )
        followerCardVC.delegate = self
        
        self.add(
            childVc: githubCardVC,
            parentView: self.githubCard,
            parentVC: self
        )
        self.add(
            childVc: followerCardVC,
            parentView: self.followersCard,
            parentVC: self
        )
        self.add(
            childVc: GFUserInfoHeaderVC(user: user),
            parentView: self.headerView,
            parentVC: self
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissVC))
    }
    
    private func layoutUI(){
        view.backgroundColor = .systemBackground
        view.addSubview(headerView)
        view.addSubview(githubCard)
        view.addSubview(followersCard)
        view.addSubview(userSinceLabel)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        githubCard.translatesAutoresizingMaskIntoConstraints = false
        followersCard.translatesAutoresizingMaskIntoConstraints = false
        
        let itemHeight = 180.0
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: itemHeight),
            
            githubCard.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            githubCard.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            githubCard.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            githubCard.heightAnchor.constraint(equalToConstant: itemHeight),
            
            followersCard.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            followersCard.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            followersCard.topAnchor.constraint(equalTo: githubCard.bottomAnchor, constant: 20),
            followersCard.heightAnchor.constraint(equalToConstant: itemHeight),
            
            userSinceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userSinceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userSinceLabel.topAnchor.constraint(equalTo: followersCard.bottomAnchor, constant: 20),
            userSinceLabel.heightAnchor.constraint(equalToConstant: 20),
            
            
            
        ])
    }
    
    private func configureFavToggleBtn(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: vm.isFav ? SFSymbols.starFill : SFSymbols.star), style: .plain, target: self, action: #selector(toggleFav))
    }
    
    @objc private func dismissVC(){
        dismiss(animated: true)
    }
    
    @objc private func toggleFav(){
        delegate?.didTapToggleFavBtn(vm.username)
        configureFavToggleBtn()
    }
 
}

protocol UserInfoVCDelegate: AnyObject {
    func didTapActionBtn(for card: GFDetailCardType)
}


extension UserInfoVC: UserInfoVCDelegate {
    func didTapActionBtn(for card: GFDetailCardType) {
        switch card{
        case .FollowerCard:
            dismissVC()
            delegate?.didRequestFollowers(for: vm.username)
            
        case .githubCard:
            presentSafariVC(with: vm.user?.htmlUrl)
        }
    
    }
}
