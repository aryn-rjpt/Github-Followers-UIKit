

import UIKit

enum FollowerSection {
    case main
}

class FollowerListVC: UIViewController {
    
    var followers: [Follower] = []
    var followersCollectionView: UICollectionView!
    var followersDataSource: UICollectionViewDiffableDataSource<FollowerSection, Follower>!
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false
    var filteredFollowers: [Follower] = []
    
    var vm: FollowerListVM
    
    init(username: String){
        self.vm = FollowerListVM(username: username)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVC()
        configureCollectionView()
        configureSearchController()
        getFollowers(page: page)
        configureDataSource()
        configureFavToggleBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureVC(){
        title = vm.username
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureCollectionView(){

        followersCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        followersCollectionView.delegate = self
        
        view.addSubview(followersCollectionView)

        followersCollectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseId)
      
    }
    
    private func configureSearchController(){
        let searchController                    = UISearchController()
        searchController.searchResultsUpdater   = self
        searchController.searchBar.placeholder  = "Search for a user"
        navigationItem.searchController = searchController
    }
    
    private func getFollowers(page: Int){
        
        showLoadingView()
        
        NetworkManager.shared.getFollowers(for: vm.username, page: page) { [weak self] result in
            
            guard let self = self else {return}
            
            dismissLoadingView()
            
            switch result {
            case .success(let followers):
                
                if followers.count < 100 {
                    self.hasMoreFollowers = false
                }
                self.followers.append(contentsOf: followers )
                if self.followers.isEmpty  {
                    DispatchQueue.main.async { [weak self] in
                        self?.showEmptyStateView(with: "This user has got no followers.")
                    }
                }
                else {
                    self.updateData(on: self.followers)
                }
                
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Some Error Occurred", message: error.rawValue , buttonTitle: "ok")
                
            }
        }
        
    }
    
    private func configureDataSource(){
        followersDataSource = UICollectionViewDiffableDataSource<FollowerSection, Follower>(collectionView: followersCollectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseId, for: indexPath) as! FollowerCell
            
            cell.set(follower: follower)
            
            return cell
            
        })
    }
    
    private func updateData(on followers: [Follower]){
        var snapshot = NSDiffableDataSourceSnapshot<FollowerSection, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        
        DispatchQueue.main.async { [weak self] in
            self?.followersDataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    private func configureFavToggleBtn(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: vm.isFavourite ? SFSymbols.starFill : SFSymbols.star), style: .plain, target: self, action: #selector(toggleFav))
    }
    
    @objc private func toggleFav(){
        self.didTapToggleFavBtn(vm.username)
        configureFavToggleBtn()
    }
}

extension FollowerListVC: UICollectionViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers else { return }
            page += 1
            
            getFollowers(page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let follower = isSearching ? filteredFollowers[indexPath.item] : followers[indexPath.item]
        
        guard let followerUsername = follower.login else {return}
        
        let userInfoVC = UserInfoVC(username: followerUsername)
        userInfoVC.delegate = self
        
        let navController = UINavigationController(rootViewController: userInfoVC)
        
        present(navController, animated: true) 
            
        
    }
}


extension FollowerListVC: UISearchResultsUpdating, UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text else { return }
        
        if filter.isEmpty {
            isSearching = false
            updateData(on: followers)
        }
        else {
            isSearching = true
            filteredFollowers = followers.filter({
                $0.login?.lowercased().contains(filter.lowercased()) ?? false
            })
            
            updateData(on: filteredFollowers)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false;
    }
}
    


extension FollowerListVC: FollowerVCDelegate {
    
    func didTapToggleFavBtn(_ username: String) {
        PersistanceManager.shared.toggleFav(username)
    }
    
    func didRequestFollowers(for username: String){
        self.vm.username = username
        title = username
        followers.removeAll()
        page = 1
        hasMoreFollowers = true
        isSearching = false
        filteredFollowers.removeAll()
        navigationItem.searchController?.searchBar.text = ""
        
        
        getFollowers(page: page)
        
    }
}
