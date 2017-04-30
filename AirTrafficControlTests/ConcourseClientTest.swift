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
        let path = "/teams"
        let expectedJson = [["id": 1, "name": "name-1"]]
        let jsonClient = MockJsonClient(json: expectedJson)

        let concourseClient = ConcourseClient(jsonClient: jsonClient)

        concourseClient.getTeams(host: host) {(error, json) in
            XCTAssertNil(error)
            XCTAssertEqual(1, (json as! NSArray).count)
            let team = (((json as! NSArray)[0]) as! Dictionary<String, Any>)
            XCTAssertEqual(1, team["id"] as! Int)
            XCTAssertEqual("name-1", team["name"] as! String)

            self.request.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)

        XCTAssertEqual(self.host, jsonClient.host)
        XCTAssertEqual(path, jsonClient.path)
    }

    func testGetTeamsWithFailedJsonRequest() {
        let path = "/teams"
        let jsonClient = MockJsonClient(error: self.error)

        let concourseClient = ConcourseClient(jsonClient: jsonClient)

        concourseClient.getTeams(host: host) {(error, json) in
            XCTAssertEqual(self.error, error as! ConcourseClientTest.MockError)
            XCTAssertNil(json as? String)

            self.request.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)

        XCTAssertEqual(self.host, jsonClient.host)
        XCTAssertEqual(path, jsonClient.path)
    }

    func testGetPipelinesWithSuccessfulJsonRequest() {
        let path = "/pipelines"
        let expectedJson = [["name": "cf-current", "paused": true, "public": true, "team_name": "docs"]]
        let jsonClient = MockJsonClient(json: expectedJson)

        let concourseClient = ConcourseClient(jsonClient: jsonClient)

        concourseClient.getPipelines(host: host) {(error, json) in
            XCTAssertNil(error)
            XCTAssertEqual(1, (json as! NSArray).count)
            let team = (((json as! NSArray)[0]) as! Dictionary<String, Any>)
            XCTAssertEqual("cf-current", team["name"] as! String)
            XCTAssertEqual(true, team["paused"] as! Bool)
            XCTAssertEqual(true, team["public"] as! Bool)
            XCTAssertEqual("docs", team["team_name"] as! String)

            self.request.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)

        XCTAssertEqual(self.host, jsonClient.host)
        XCTAssertEqual(path, jsonClient.path)
    }

    func testGetPipelinesWithFailedJsonRequest() {
        let path = "/pipelines"
        let jsonClient = MockJsonClient(error: self.error)

        let concourseClient = ConcourseClient(jsonClient: jsonClient)

        concourseClient.getPipelines(host: host) {(error, json) in
            XCTAssertEqual(self.error, error as! ConcourseClientTest.MockError)
            XCTAssertNil(json as? String)

            self.request.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertEqual(self.host, jsonClient.host)
        XCTAssertEqual(path, jsonClient.path)
    }
}
