
import SwiftUI

struct FavListVC: View {
    
    let vm: FavListVM
    
    @State var favs: [String]
    
    init() {
        vm = FavListVM()
        favs = vm.favList
    }
    
    var body: some View {
        List(favs, id: \.self){ username in
            FavListCell(username).swipeActions {
                Button (role: .destructive) {
                    PersistanceManager.shared.toggleFav(username)
                    favs.removeAll(where: {$0 == username})
                } label: {
                    Image(systemName: "trash")
                }

            }
        }
        .onAppear(){
            vm.favList = PersistanceManager.shared.getFavs()
            favs = vm.favList
        }
    }
}


