import Foundation

typealias RequestCompletionHandler = (Data?, URLResponse?, Error?) -> Void

protocol PHttpClient {
    func request(url: URL, completionHandler: @escaping RequestCompletionHandler)
}

class HttpClient: PHttpClient {
    let session: PUrlSession

    init(session: PUrlSession = URLSession.shared) {
        self.session = session
    }

    func request(url: URL, completionHandler: @escaping RequestCompletionHandler) {
        self.session.dataTask(with: url, completionHandler: completionHandler).resume()
    }
}
