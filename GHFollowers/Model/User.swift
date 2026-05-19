import Foundation

struct User: Codable{
    var login: String?
    var avatarUrl: String?
    var name: String?
    var location: String?
    var bio: String?
    var publicRepos: Int?
    var pubicGists: Int?
    var htmlUrl: String?
    var following: Int?
    var followers: Int?
    var createdAt: String?
}
