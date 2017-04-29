import Foundation

protocol PJsonClient {
    func requestJson(host: String, path: String, completionHandler: @escaping (Error?, Any?) -> Void)
}

class JsonClient: PJsonClient {
    let httpClient: PHttpClient
    
    init(httpClient: PHttpClient) {
        self.httpClient = httpClient
    }
    
    func requestJson(host: String, path: String, completionHandler: @escaping (Error?, Any?) -> Void) {
        let url = URL(string: "https://\(host)/api/v1\(path)")
        
        self.httpClient.request(url: url!) {(data, response, error) in
            if error != nil {return completionHandler(error, nil)}
            do {completionHandler(nil, try JSONSerialization.jsonObject(with: data!))}
            catch {completionHandler(error, nil)}
        }
    }
}
