//
//  BeginnerLevelViewControllerTest.swift
//  PictationTests
//
//  Created by Benton on 2017-11-04.
//  Copyright © 2017 Benton. All rights reserved.
//

import XCTest
@testable import Pictation

class BeginnerLevelViewControllerTest: XCTestCase {
    let beginnerView = BeginnerLevelViewController()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_removeLastComponentOfString_happyPath_returnsCorrectStrings() {
        let actualResult = beginnerView.removeLastComponentOfString("test123", "123")
        let expectedResult = "test"
        XCTAssertEqual(actualResult, expectedResult)
    }

    func test_removeLastComponentOfString_emptyString_returnsCorrectStrings() {
        let actualResult = beginnerView.removeLastComponentOfString("test123", "")
        let expectedResult = "test123"
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func test_removeLastComponentOfString_repeatedCase_returnsCorrectStrings() {
        let actualResult = beginnerView.removeLastComponentOfString("e1e1e1e1e1", "1")
        let expectedResult = "e"
        XCTAssertEqual(actualResult, expectedResult)
    }
    
    func test_getFolderPath_happyPath_returnCorrectPath() {
        let url = URL(string: "user/image/hello.jpg")
        let urlArray = [url]
        let actualResult = beginnerView.getFolderPathWithoutLastComponent(imageUrlArray: urlArray as! [URL])
        let expectedResult = "user/image/"
        XCTAssertEqual(actualResult, expectedResult)
    }
}
