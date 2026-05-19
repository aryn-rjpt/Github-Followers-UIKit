import UIKit

struct NetworkManager {
    
    static var shared   = NetworkManager()
    private let baseUrl         = "https://api.github.com/users/"
    let cache           = NSCache<NSString, UIImage>()
    
    private init(){}
    
    func getFollowers(for username: String, page: Int, completionHandler: @escaping (Result<[Follower], GFError>) -> Void ){
        let endPoint = baseUrl + "\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endPoint) else {
            completionHandler(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completionHandler(.failure(.unableToCompleteRequest))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                debugPrint(response.debugDescription)
                completionHandler(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completionHandler(.success(followers))
            } catch {
                completionHandler(.failure(.decodeError))
                return
            }
        }
        
        task.resume()
    }
    
    func getUserData(of username: String, completionHandler: @escaping (Result<User, GFError>) -> Void){
        
        let url = baseUrl + "\(username)"
        
        guard let url = URL(string: url) else {
            completionHandler(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard error == nil else {
                debugPrint(error.debugDescription)
                completionHandler(.failure(.someErrorOccurred))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                debugPrint(response.debugDescription)
                completionHandler(.failure((.invalidResponse)))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let user = try decoder.decode(User.self, from: data)
                completionHandler(.success(user))
            } catch {
                completionHandler(.failure(.decodeError))
                return
            }
            
            

        }
        
        task.resume()
            
        
        
    }
    
}
