import XCTest
@testable import AirTrafficControl

class HttpClientTest: XCTestCase {
    let error = MockError.SessionError
    let url = URL(string: "some-url")
    let data = "[{\"id\":1,\"name\":\"name-1\"},".data(using: .utf8)
    let dataTask = MockUrlSessionDataTask()
    var request: XCTestExpectation!

    enum MockError : Error {
        case SessionError
    }

    class MockUrlSessionDataTask: PUrlSessionDataTask {
        var resumed: Bool = false

        func resume() {
            resumed = true
        }
    }

    class MockUrlSession: PUrlSession {
        let data: Data?, response: URLResponse?, error: Error?, dataTask: PUrlSessionDataTask
        var url: URL?

        init(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil, dataTask: PUrlSessionDataTask) {
            self.data = data
            self.response = response
            self.error = error
            self.dataTask = dataTask
        }

        func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> PUrlSessionDataTask {
            self.url = url
            completionHandler(self.data, self.response, self.error)
            return self.dataTask
        }
    }

    override func setUp() {
        super.setUp()
        self.request = expectation(description: "request")
    }

    func testWithSuccessfulRequest() {
        let session = MockUrlSession(data: data, dataTask: dataTask)

        let httpClient = HttpClient(session: session)

        httpClient.request(url: url!) {(data, response, error) in
            XCTAssertEqual(self.data, data)
            XCTAssertNil(error)

            self.request.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)

        XCTAssertEqual(self.url, session.url)
        XCTAssertTrue(self.dataTask.resumed)
    }

    func testWithFailedlRequest() {
        let session = MockUrlSession(error: error, dataTask: dataTask)

        let httpClient = HttpClient(session: session)

        httpClient.request(url: url!) {(data, response, error) in
            XCTAssertNil(data)
            XCTAssertEqual(self.error, error as! HttpClientTest.MockError)

            self.request.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)

        XCTAssertEqual(self.url, session.url)
        XCTAssertTrue(self.dataTask.resumed)
    }
}
