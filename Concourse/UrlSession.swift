import Foundation

typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

protocol PUrlSession {
    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask
}

extension URLSession: PUrlSession {}
