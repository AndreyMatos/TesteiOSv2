//
//  UserBalanceViewControllerTests.swift
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

class UserBalanceViewControllerTests: XCTestCase
{
    // MARK: Subject under test
    
    var sut: UserBalanceViewController!
    var window: UIWindow!
    
    // MARK: Test lifecycle
    
    override func setUp()
    {
        super.setUp()
        window = UIWindow()
        setupUserBalanceViewController()
    }
    
    override func tearDown()
    {
        window = nil
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupUserBalanceViewController()
    {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        sut = storyboard.instantiateViewController(withIdentifier: "UserBalanceViewController") as? UserBalanceViewController
    }
    
    func loadView()
    {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: Test doubles
    
    class TableViewSpy: UITableView
    {
        // MARK: Method call expectations
        
        var reloadDataCalled = false
        
        // MARK: Spied methods
        
        override func reloadData(){
            reloadDataCalled = true
        }
    }
    
    class UserBalanceBusinessLogicSpy: UserBalanceBusinessLogic
    {
        var fetchStatementsCalled = false
        var displayUserInfoCalled = false
        var logoutCalled = false
        
        func fetchStatements() {
            fetchStatementsCalled = true
        }
        
        func displayUserInfo() {
            displayUserInfoCalled = true
        }
        
        func logout() {
            logoutCalled = true
        }
    }
    
    // MARK: Tests
    func testShouldShowUserInfoAndFetchStatementsWhenViewIsLoaded()
    {
        // Given
        let spy = UserBalanceBusinessLogicSpy()
        sut.interactor = spy
        
        // When
        loadView()
        
        // Then
        XCTAssertTrue(spy.displayUserInfoCalled, "viewDidLoad() should ask the interactor to display the user info")
        XCTAssertTrue(spy.fetchStatementsCalled, "viewDidLoad() should ask the interactor to fetch the statements")
    }
    
    func testDisplayUserInfo(){
        // Given
        //        let viewModel = UserBalance.FetchStatements.ViewModel(displayedStatements: [])
        let userInfo = UserBalance.FetchStatements.ViewModel.DisplayedUser(id: 1,
                                                                           name: "John",
                                                                           account: "0000 / 1234",
                                                                           balance: "R$ 1000.00")
        
        // When
        loadView()
        sut.displayUserInfo(userInfo: userInfo)
        
        // Then
        XCTAssertEqual(sut.clientNameUILabel.text, "John")
        XCTAssertEqual(sut.clientAccountUILabel.text, "0000 / 1234")
        XCTAssertEqual(sut.clientBalanceUILabel.text, "R$ 1000.00")
    }
    
    func testShouldDisplayStatements(){
        // Given
        let tableSpy = TableViewSpy()
        
        //When
        loadView()
        sut.tableView = tableSpy
        let viewModel = UserBalance.FetchStatements.ViewModel(displayedStatements: [
            UserBalance.FetchStatements.ViewModel.DisplayedStatement(title: "Stmt 1",
                                                                     desc: "Cool Stmt",
                                                                     date: "1999-10-10",
                                                                     value: "R$ 11,00"),
            UserBalance.FetchStatements.ViewModel.DisplayedStatement(title: "Stmt 2",
                                                                     desc: "Cool Stmt 2",
                                                                     date: "2000-10-11",
                                                                     value: "R$ 110,00")])
        sut.displayStatements(viewModel: viewModel)
        
        // Then
        XCTAssertTrue(tableSpy.reloadDataCalled, "Should reload tableview when displaying data")
    }
    
    func testNumberOfSectionsInTableViewShouldAlwaysBeOne()
    {
        // Given
        loadView()
        let tableView = sut.tableView
        
        // When
        let numberOfSections = tableView?.numberOfSections
        
        // Then
        XCTAssertEqual(numberOfSections, 1, "The number of table view sections should always be 1")
    }
    
    func testNumberOfRowsInAnySectionShouldEqaulNumberOfStatementsToDisplay()
    {
        // Given
        loadView()
        let tableView = sut.tableView
        let viewModel = UserBalance.FetchStatements.ViewModel(displayedStatements: [
            UserBalance.FetchStatements.ViewModel.DisplayedStatement(title: "Stmt 1",
                                                                     desc: "Cool Stmt",
                                                                     date: "1999-10-10",
                                                                     value: "R$ 11,00"),
            UserBalance.FetchStatements.ViewModel.DisplayedStatement(title: "Stmt 2",
                                                                     desc: "Cool Stmt 2",
                                                                     date: "2000-10-11",
                                                                     value: "R$ 110,00")])
        sut.displayStatements(viewModel: viewModel)
        
        // When
        let numberOfRows = sut.tableView(tableView!, numberOfRowsInSection: 0)
        
        // Then
        XCTAssertEqual(numberOfRows, viewModel.displayedStatements.count, "The number of table view rows should equal the number of statements to display")
    }
    
    func testShouldConfigureTableViewCellToDisplayStatement() {
        // Given
        loadView()
        let tableView = sut.tableView
        let viewModel = UserBalance.FetchStatements.ViewModel(displayedStatements: [
            UserBalance.FetchStatements.ViewModel.DisplayedStatement(title: "Stmt 1",
                                                                     desc: "Cool Stmt",
                                                                     date: "1999-10-10",
                                                                     value: "R$ 11,00"),
            UserBalance.FetchStatements.ViewModel.DisplayedStatement(title: "Stmt 2",
                                                                     desc: "Cool Stmt 2",
                                                                     date: "2000-10-11",
                                                                     value: "R$ 110,00")])
        // When
        sut.displayStatements(viewModel: viewModel)
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView(tableView!, cellForRowAt: indexPath) as? StatementTableViewCell
        
        // Then
        XCTAssertEqual(cell?.titleUILabel.text, "Stmt 1")
        XCTAssertEqual(cell?.descUILabel.text, "Cool Stmt")
        XCTAssertEqual(cell?.valueUILabel.text, "R$ 11,00")
        XCTAssertEqual(cell?.dateUILabel.text, "1999-10-10")
    }
}