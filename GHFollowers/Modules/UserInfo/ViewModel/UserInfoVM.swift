import UIKit

class UserInfoVM {
    
    var user: User?
    var username: String
    
    var isFav: Bool {
        PersistanceManager.shared.isFav(username)
    }
    
    init(username: String) {
        self.username = username
    }
    
    func getUserData(completionHandler: @escaping (Result<User, GFError>) -> Void){
        NetworkManager.shared.getUserData(of: username, completionHandler: completionHandler)
    }
    
}

