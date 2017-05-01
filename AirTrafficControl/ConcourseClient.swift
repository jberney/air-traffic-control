import Foundation

typealias ConcourseGetCompletionHandler = (Error?, Any?) -> Void

protocol PConcourseClient {
    func getTeams(host: String, completionHandler: @escaping ConcourseGetCompletionHandler)
    func getPipelines(host: String, completionHandler: @escaping ConcourseGetCompletionHandler)
    func getJobs(host: String, team: String, pipeline: String, completionHandler: @escaping ConcourseGetCompletionHandler)
}

class ConcourseClient: PConcourseClient {
    let jsonClient: PJsonClient

    init(jsonClient: PJsonClient) {
        self.jsonClient = jsonClient
    }

    func getTeams(host: String, completionHandler: @escaping ConcourseGetCompletionHandler) {
        self.jsonClient.requestJson(host: host, path: "/teams", completionHandler: completionHandler)
    }

    func getPipelines(host: String, completionHandler: @escaping ConcourseGetCompletionHandler) {
        self.jsonClient.requestJson(host: host, path: "/pipelines", completionHandler: completionHandler)
    }

    func getJobs(host: String, team: String, pipeline: String, completionHandler: @escaping ConcourseGetCompletionHandler) {
        let path = "/teams/\(team)/pipelines/\(pipeline)/jobs"
        self.jsonClient.requestJson(host: host, path: path, completionHandler: completionHandler)
    }
}
