
import Foundation

enum GFError: String, Error {
     case someErrorOccurred         = "Some error occurred"
     case unableToCompleteRequest   = "Unable to complete the request"
     case invalidData               = "Invalid data received"
     case invalidResponse           = "Invalid Response"
     case invalidURL                = "Invalid URL"
     case decodeError               = "Failed to decode data"
    
}
