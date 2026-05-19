//
//  SwiftUIView.swift
//  GHFollowers
//
//  Created by Unthinkable-Mac on 11/05/26.
//

import SwiftUI


struct FavListCell: View {
    
    var username: String
    @State var imageUrl: String?
    
    init(_ username: String) {
        self.username = username
    }
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: imageUrl ?? ""), content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }, placeholder: {
                Image(GFImages.avatarPlaceholder)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            })
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            
            Text(username)
                .padding(.leading, 10)
            
                .task {
                    loadAvatar()
                }
        }
    }
    
    
    private func loadAvatar(){
        NetworkManager.shared.getUserData(of: username) { result in
            switch result {
            case .success(let user):
                imageUrl = user.avatarUrl
                
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
}


#Preview {
    FavListCell("sallen0400")
}
