
import Foundation

class PersistanceManager {
    
    static let shared = PersistanceManager()
    
    private init(){}
    
    func getFavs() -> [String] {
        UserDefaults.standard.stringArray(forKey: UserDefaultConstants.favourites) ?? []
    }
    
    func isFav(_ username: String) -> Bool {
        let favs = getFavs()
        return favs.contains(username)
    }
    
    func toggleFav(_ username: String) {
        var favs = getFavs()
        if favs.contains(username) {
            favs.removeAll(where: {$0 == username})
        }
        else {
            favs.append(username)
        }
        UserDefaults.standard.set(favs, forKey: UserDefaultConstants.favourites)

    }
}
