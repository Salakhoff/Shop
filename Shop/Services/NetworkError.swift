import UIKit

enum NetworkError: Error {
    case badUrl
    case badData
    case badResponse
    case badRequest
    case badDecode
    case unknown(String)
}
