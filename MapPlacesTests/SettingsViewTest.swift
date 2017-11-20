//
//  SettingsViewTest.swift
//  MapPlacesTests
//
//  Created by KAK2164 on 15/11/2017.
//  Copyright © 2017 Kulvik Tech Ltd. All rights reserved.
//

import XCTest
import GoogleSignIn
import GoogleAPIClientForREST
import PopupDialog

@testable import MapPlaces

class SettingsViewTest: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func test_getSheetIDfromURL_equal(){
        let URL = "https://docs.google.com/spreadsheets/d/1LzIuJ8snIG5-SUry6LSC5clF1yFxCsVLGt8vIr1zg-8/edit?usp=sharing"
        let sheetID = "1LzIuJ8snIG5-SUry6LSC5clF1yFxCsVLGt8vIr1zg-8"
        let helperF = helpFunctions()
        XCTAssertTrue(sheetID == helperF.get_sheet_id(passedURL: URL))
    }
    
    func test_helperDoubleDigit(){
        let helperF = helpFunctions()
        let thisDouble: Double = 2.000000
        let shouldBeDouble = helperF.doubleDigits(2)
        XCTAssert(thisDouble == shouldBeDouble, "Testing if numbers equal")
    }
    
    
 
    
}
