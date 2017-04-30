import Foundation

typealias RequestJsonCompletionHandler = (Error?, Any?) -> Void

protocol PJsonClient {
    func requestJson(host: String, path: String, completionHandler: @escaping RequestJsonCompletionHandler)
}

class JsonClient: PJsonClient {
    let httpClient: PHttpClient

    init(httpClient: PHttpClient) {
        self.httpClient = httpClient
    }

    func requestJson(host: String, path: String, completionHandler: @escaping RequestJsonCompletionHandler) {
        let url = URL(string: "https://\(host)/api/v1\(path)")

        self.httpClient.request(url: url!) {(data, response, error) in
            if error != nil {return completionHandler(error, nil)}
            do {completionHandler(nil, try JSONSerialization.jsonObject(with: data!))}
            catch {completionHandler(error, nil)}
        }
    }
}
