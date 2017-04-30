import Foundation

protocol PUrlSessionDataTask {
    func resume()
}

extension URLSessionDataTask: PUrlSessionDataTask {}
