import Foundation

typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

protocol PUrlSession {
    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> PUrlSessionDataTask
}

extension URLSession: PUrlSession {
    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> PUrlSessionDataTask {
        return (dataTask(with: url, completionHandler: completionHandler)
            as URLSessionDataTask) as PUrlSessionDataTask
    }
}
