import XCTest
@testable import AirTrafficControl

class ConcourseClientTest: XCTestCase {
    let error = MockError.JsonError
    let host = "p-concourse.wings.cf-app.com"
    var request: XCTestExpectation!

    enum MockError : Error {
        case JsonError
    }

    class MockJsonClient: PJsonClient {
        let error: Error?, json: Any?
        var host: String?, path: String?

        init(error: Error? = nil, json: Any? = nil) {
            self.error = error
            self.json = json
        }

        public func requestJson(host: String, path: String, completionHandler: @escaping (Error?, Any?) -> Void) {
            self.host = host
            self.path = path
            completionHandler(self.error, self.json)
        }
    }

    override func setUp() {
        super.setUp()
        self.request = expectation(description: "request")
    }

    func testGetTeamsWithSuccessfulJsonRequest() {
        let expectedJson = [["id": 1, "name": "name-1"]]
        let jsonClient = MockJsonClient(json: expectedJson)

        let concourseClient = ConcourseClient(jsonClient: jsonClient)

        concourseClient.getTeams(host: self.host) {(error, teams) in
            XCTAssertNil(error)
            XCTAssertEqual(1, (teams as! NSArray).count)
            let team = (((teams as! NSArray)[0]) as! Dictionary<String, Any>)
            XCTAssertEqual(1, team["id"] as! Int)
            XCTAssertEqual("name-1", team["name"] as! String)

            self.request.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)

        XCTAssertEqual(self.host, jsonClient.host)
        XCTAssertEqual("/teams", jsonClient.path)
    }

    func testGetTeamsWithFailedJsonRequest() {
        let jsonClient = MockJsonClient(error: self.error)

        let concourseClient = ConcourseClient(jsonClient: jsonClient)

        concourseClient.getTeams(host: self.host) {(error, json) in
            XCTAssertEqual(self.error, error as! ConcourseClientTest.MockError)
            XCTAssertNil(json)

            self.request.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)

        XCTAssertEqual(self.host, jsonClient.host)
        XCTAssertEqual("/teams", jsonClient.path)
    }

    func testGetPipelinesWithSuccessfulJsonRequest() {
        let expectedJson = [["name": "cf-current", "paused": true, "public": true, "team_name": "docs"]]
        let jsonClient = MockJsonClient(json: expectedJson)

        let concourseClient = ConcourseClient(jsonClient: jsonClient)

        concourseClient.getPipelines(host: self.host) {(error, pipelines) in
            XCTAssertNil(error)
            XCTAssertEqual(1, (pipelines as! NSArray).count)
            let pipeline = (((pipelines as! NSArray)[0]) as! Dictionary<String, Any>)
            XCTAssertEqual("cf-current", pipeline["name"] as! String)
            XCTAssertEqual(true, pipeline["paused"] as! Bool)
            XCTAssertEqual(true, pipeline["public"] as! Bool)
            XCTAssertEqual("docs", pipeline["team_name"] as! String)

            self.request.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)

        XCTAssertEqual(self.host, jsonClient.host)
        XCTAssertEqual("/pipelines", jsonClient.path)
    }

    func testGetPipelinesWithFailedJsonRequest() {
        let jsonClient = MockJsonClient(error: self.error)

        let concourseClient = ConcourseClient(jsonClient: jsonClient)

        concourseClient.getPipelines(host: self.host) {(error, pipelines) in
            XCTAssertEqual(self.error, error as! ConcourseClientTest.MockError)
            XCTAssertNil(pipelines)

            self.request.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)

        XCTAssertEqual(self.host, jsonClient.host)
        XCTAssertEqual("/pipelines", jsonClient.path)
    }

    func testGetJobsWithSuccessfulJsonRequest() {
        let expectedJson = [["name": "oss-bind"]]
        let jsonClient = MockJsonClient(json: expectedJson)

        let concourseClient = ConcourseClient(jsonClient: jsonClient)

        concourseClient.getJobs(host: self.host, team: "docs", pipeline: "cf-current") {(error, jobs) in
            XCTAssertNil(error)
            XCTAssertEqual(1, (jobs as! NSArray).count)
            let job = (((jobs as! NSArray)[0]) as! Dictionary<String, Any>)
            XCTAssertEqual("oss-bind", job["name"] as! String)

            self.request.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)

        XCTAssertEqual(self.host, jsonClient.host)
        XCTAssertEqual("/teams/docs/pipelines/cf-current/jobs", jsonClient.path)
    }

    func testGetJobsWithFailedJsonRequest() {
        let jsonClient = MockJsonClient(error: self.error)

        let concourseClient = ConcourseClient(jsonClient: jsonClient)

        concourseClient.getJobs(host: self.host, team: "docs", pipeline: "cf-current") {(error, jobs) in
            XCTAssertEqual(self.error, error as! ConcourseClientTest.MockError)
            XCTAssertNil(jobs)
            
            self.request.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)

        XCTAssertEqual(self.host, jsonClient.host)
        XCTAssertEqual("/teams/docs/pipelines/cf-current/jobs", jsonClient.path)
    }
}
