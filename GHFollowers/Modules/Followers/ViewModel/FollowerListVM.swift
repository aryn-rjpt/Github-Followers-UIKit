import Foundation

protocol FollowerVCDelegate: AnyObject {
    func didRequestFollowers(for username: String)
    func didTapToggleFavBtn(_ username: String)
}


class FollowerListVM {
    var username: String
    var followers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false
    var filteredFollowers: [Follower] = []
    
    var isFavourite: Bool {
        PersistanceManager.shared.isFav(username)
    }
    
    init(username: String) {
        self.username = username
    }
}
