import Foundation

protocol PHttpClient {
    func request(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

class HttpClient: PHttpClient {
    let session: PUrlSession
    
    init(session: PUrlSession = URLSession.shared) {
        self.session = session
    }
    
    func request(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.session.dataTask(with: url, completionHandler: completionHandler).resume()
    }
}
