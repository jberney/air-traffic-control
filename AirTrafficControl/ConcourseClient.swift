import Foundation

typealias ConcourseGetTeamsCompletionHandler = (Error?, Any?) -> Void

protocol PConcourseClient {
    func getTeams(host: String, completionHandler: @escaping ConcourseGetTeamsCompletionHandler)
}

class ConcourseClient: PConcourseClient {
    let jsonClient: PJsonClient
    
    init(jsonClient: PJsonClient) {
        self.jsonClient = jsonClient
    }
    
    func getTeams(host: String, completionHandler: @escaping ConcourseGetTeamsCompletionHandler) {
        self.jsonClient.requestJson(host: host, path: "/teams", completionHandler: completionHandler)
    }
}
