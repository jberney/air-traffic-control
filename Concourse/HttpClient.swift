import Foundation

protocol PHttpClient {
    func request(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

class HttpClient: PHttpClient {
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func request(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.session.dataTask(with: url, completionHandler: completionHandler).resume()
    }
}
