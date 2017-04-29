import XCTest
@testable import Concourse

class JsonClientTest: XCTestCase {
    var requestJson: XCTestExpectation!
    
    enum MockError : Error {
        case HttpError
    }
    
    class MockHttpClient: PHttpClient {
        let data: Data?, urlResponse: URLResponse?, error: Error?
        var url: URL?
        
        init(data: Data? = nil, urlResponse: URLResponse? = nil, error: Error? = nil) {
            self.data = data
            self.urlResponse = urlResponse
            self.error = error
        }
        
        public func request(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
            self.url = url
            completionHandler(self.data, self.urlResponse, self.error)
        }
    }
    
    override func setUp() {
        super.setUp()
        self.requestJson = expectation(description: "requestJson")
    }
    
    func testWithFailedHttpRequest() {
        let host = "some-host"
        let path = "/some-path"
        let error = MockError.HttpError
        let httpClient = MockHttpClient(error: error)
        
        let jsonClient = JsonClient(httpClient: httpClient)
        
        jsonClient.requestJson(host: host, path: path) {(actualError, parsed) in
            XCTAssertEqual(URL(string: "https://some-host/api/v1/some-path"), httpClient.url)
            
            XCTAssertNotNil(actualError)
            XCTAssertNil(parsed)
            
            self.requestJson.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testWithFailedJsonParsing() {
        let host = "some-host"
        let path = "/some-path"
        let data = "[{\"id\":1,\"name\":\"name-1\"},".data(using: .utf8)
        let httpClient = MockHttpClient(data: data)
        
        let jsonClient = JsonClient(httpClient: httpClient)
        
        jsonClient.requestJson(host: host, path: path) {(error, parsed) in
            XCTAssertEqual(URL(string: "https://some-host/api/v1/some-path"), httpClient.url)
            
            XCTAssertNotNil(error)
            XCTAssertNil(parsed)
            
            self.requestJson.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testWithSuccessfulHttpRequest() {
        let host = "some-host"
        let path = "/some-path"
        let data = "[{\"id\":1,\"name\":\"name-1\"},{\"id\":2,\"name\":\"name-2\"}]".data(using: .utf8)
        let httpClient = MockHttpClient(data: data)
        
        let jsonClient = JsonClient(httpClient: httpClient)
        
        jsonClient.requestJson(host: host, path: path) {(error, parsed) in
            XCTAssertEqual(URL(string: "https://some-host/api/v1/some-path"), httpClient.url)
            
            XCTAssertNil(error)
            XCTAssertEqual([["id": 1, "name": "name-1"], ["id": 2, "name": "name-2"]], parsed as? NSArray)
            
            self.requestJson.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
