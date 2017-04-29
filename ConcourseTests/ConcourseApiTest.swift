import XCTest
@testable import Concourse

class ConcourseApiTest: XCTestCase {
    let host = "p-concourse.wings.cf-app.com"
    let path = "/teams"
    var getTeams: XCTestExpectation!
    
    enum MockError : Error {
        case RuntimeError(String)
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
        self.getTeams = expectation(description: "getTeams")
    }
    
    func testWithSuccessfulJsonRequest() {
        let expectedJson = "{\"some-key\": \"some-value\"}"
        let jsonClient = MockJsonClient(json: expectedJson)
        
        let concourseApi = ConcourseApi(jsonClient: jsonClient)
        
        concourseApi.getTeams(host: host) {(error, json) in
            XCTAssertEqual(self.host, jsonClient.host)
            XCTAssertEqual(self.path, jsonClient.path)
            
            XCTAssertNil(error)
            XCTAssertEqual(expectedJson, json as? String)
            
            self.getTeams.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testWithFailedJsonRequest() {
        let expectedError : Error? = MockError.RuntimeError("some-error")
        let jsonClient = MockJsonClient(error: expectedError)
        
        let concourseApi = ConcourseApi(jsonClient: jsonClient)
        
        concourseApi.getTeams(host: host) {(error, json) in
            XCTAssertEqual(self.host, jsonClient.host)
            XCTAssertEqual(self.path, jsonClient.path)
            
            XCTAssertNotNil(error)
            XCTAssertNil(json as? String)
            
            self.getTeams.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
