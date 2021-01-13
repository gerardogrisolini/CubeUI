import XCTest
@testable import CubeUI

final class CubeUITests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(CubeUI().version, "1.1.2")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
