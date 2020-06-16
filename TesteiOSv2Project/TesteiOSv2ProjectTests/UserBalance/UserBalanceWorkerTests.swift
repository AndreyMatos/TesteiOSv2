//
//  UserBalanceWorkerTests.swift
//  TesteiOSv2Project
//
//  Created by Andrey on 16/06/20.
//  Copyright (c) 2020 Andrey Matos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import TesteiOSv2Project
import XCTest

class UserBalanceWorkerTests: XCTestCase
{
    // MARK: Subject under test
    
    var sut: UserBalanceWorker!
    
    // MARK: Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        setupUserBalanceWorker()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupUserBalanceWorker()
    {
        sut = UserBalanceWorker(bankStore: BankAPI())
    }
    
    // MARK: Test doubles
    
    // MARK: Tests
    
    func testFechBalanceStatements()
    {
        // Given
        let expect = expectation(description: "Wait for fetchStatements() to return")
        var statements: [Statement] = []
        // When
        sut.fetchStatements(userAccount: UserAccount(userId: 1, name: "John", bankAccount: "0000", agency: "0123456", balance: 11.0), completionHandler: { response, error in
            if let stmts = response?.statements{
                statements = stmts
            }
            expect.fulfill()
        })
        waitForExpectations(timeout: 2.0)
        // Then
        
        XCTAssertTrue(statements.count > 0, "After fetching, the statements list should have 1 or more elements")
    }
}