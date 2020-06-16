//
//  UserBalanceInteractorTests.swift
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

class UserBalanceInteractorTests: XCTestCase
{
    // MARK: Subject under test
    
    var sut: UserBalanceInteractor!
    
    // MARK: Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        setupUserBalanceInteractor()
    }
    
    override func tearDown()
    {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupUserBalanceInteractor()
    {
        sut = UserBalanceInteractor()
        sut.userAccount = UserAccount(userId: 1,
                                      name: "",
                                      bankAccount: "",
                                      agency: "",
                                      balance: 0.0)
    }
    
    // MARK: Test doubles
    
    class UserBalanceWorkerSpy: UserBalanceWorker{
        
        var fetchStatementsCalled = false
        
        override func fetchStatements(userAccount: UserAccount, completionHandler: @escaping (UserBalance.FetchStatements.Response?, UserBalanceError?) -> Void) {
            print("worker fetching statements")
            fetchStatementsCalled = true
            let response = UserBalance.FetchStatements.Response(statements: [Statement(title: "Statement",
                                                                                       desc: "Statement Desc",
                                                                                       date: "2018-01-18",
                                                                                       value: 1.0),
                                                                             Statement(title: "Statement 2",
                                                                                       desc: "Statement Desc 2",
                                                                                       date: "2018-01-22",
                                                                                       value: 5.0)])
            completionHandler(response, nil)
        }
    }
    
    class UserBalancePresentationLogicSpy: UserBalancePresentationLogic
    {
        var presentStatementsCalled = false
        var presentUserInfoCalled = false
        var logoutCalled = false
        
        func presentStatements(response: UserBalance.FetchStatements.Response) {
            presentStatementsCalled = true
        }
        
        func presentUserInfo(userAccount: UserAccount) {
            presentUserInfoCalled = true
        }
        
        func logout() {
            logoutCalled = true
        }
    }
    
    // MARK: Tests
    
    func testPresentStatementsAfterFetching(){
        // Given
        let spy = UserBalancePresentationLogicSpy()
        sut.presenter = spy
        let workerSpy = UserBalanceWorkerSpy(bankStore: BankAPI())
        sut.worker = workerSpy
        
        // When
        sut.fetchStatements()
        
        // Then
        XCTAssertTrue(workerSpy.fetchStatementsCalled, "Should call fetch statements on the worker")
        XCTAssertTrue(spy.presentStatementsCalled, "Should call present statements on the presenter")
    }
    
    func testFillUserInfo(){
        // Given
        let spy = UserBalancePresentationLogicSpy()
        sut.presenter = spy
        
        // When
        sut.displayUserInfo()
        
        // Then
        XCTAssertTrue(spy.presentUserInfoCalled, "Should call presenter to show user info")
    }
    
    func testLogout(){
        // Given
        let spy = UserBalancePresentationLogicSpy()
        sut.presenter = spy
        
        // When
        sut.logout()
        
        // Then
        XCTAssertTrue(spy.logoutCalled, "Should call logout on the presenter")
    }
    
}