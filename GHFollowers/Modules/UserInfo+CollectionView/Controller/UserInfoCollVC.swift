import UIKit


class UserInfoCollVC: UIViewController {
    
    private let username: String
    
    private let collectionView: UICollectionView
    private let layout: UICollectionViewFlowLayout
    private let vm = UserInfoCollVM()
    
    init(username: String) {
        
        self.username = username
        self.layout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(nibName: nil, bundle: nil)
        
        NetworkManager.shared.getUserData(of: username) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                self.vm.user = user
                DispatchQueue.main.async {
                    self.configureCollectionView()
                    self.layoutCollectionView()
                }
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Some Error Occurred", message: error.rawValue, buttonTitle: "Ok")
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCollectionView(){
        
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = CGSize(width: view.bounds.width, height: 180)
        layout.footerReferenceSize = CGSize(width: view.bounds.width, height: 50)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "defaultCell")
        collectionView.register(GFUserInfoFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: GFUserInfoFooter.resuseId)
        
        collectionView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissVC))
        
    }
    
    @objc private func dismissVC(){
        dismiss(animated: true)
    }
    
    private func layoutCollectionView(){
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

extension UserInfoCollVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "defaultCell", for: indexPath)
        
        let childVc: UIViewController
        
        if indexPath.item == 0 {
            childVc = GFUserInfoHeaderVC(user: vm.user ?? User())
        }
        else if indexPath.item == 1 {
            childVc = GFDetailCard(count1: vm.user?.publicRepos, count2: vm.user?.pubicGists, card: .githubCard)
        }
        else {
            childVc = GFDetailCard(count1: vm.user?.following, count2: vm.user?.followers, card: .FollowerCard)
            
        }
        addChild(childVc)
        cell.contentView.addSubview(childVc.view)
        childVc.view.frame = cell.contentView.bounds
        childVc.didMove(toParent: self)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: GFUserInfoFooter.resuseId, for: indexPath) as! GFUserInfoFooter
            footer.set(date: vm.user?.createdAt?.convertToDisplayFormat() ?? "")
            return footer
        }
        
        return UICollectionReusableView()
    }
    
    
}
