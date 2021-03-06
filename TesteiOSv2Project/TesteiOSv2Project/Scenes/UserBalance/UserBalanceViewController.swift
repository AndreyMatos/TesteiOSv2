//
//  UserBalanceViewController.swift
//  TesteiOSv2Project
//
//  Created by Andrey on 15/06/20.
//  Copyright (c) 2020 Andrey Matos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol UserBalanceDisplayLogic: class
{
    func displayStatements(viewModel: UserBalance.FetchStatements.ViewModel)
    func displayUserInfo(userInfo: UserBalance.FetchStatements.ViewModel.DisplayedUser)
    func navigateBack()
}

class UserBalanceViewController: UIViewController, UserBalanceDisplayLogic, UITableViewDataSource
{
    var interactor: UserBalanceBusinessLogic?
    var router: (NSObjectProtocol & UserBalanceRoutingLogic & UserBalanceDataPassing)?
    @IBOutlet weak var clientNameUILabel: UILabel!
    @IBOutlet weak var clientAccountUILabel: UILabel!
    @IBOutlet weak var clientBalanceUILabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var displayedStatements: [UserBalance.FetchStatements.ViewModel.DisplayedStatement] = []
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = UserBalanceInteractor()
        let presenter = UserBalancePresenter()
        let router = UserBalanceRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.rowHeight = 90
        displayUserInfo()
        fetchStatements()
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    @IBAction func didTapLogoutButton(_ sender: Any) {
        interactor?.logout()
    }
    
    func navigateBack(){
        navigationController?.popViewController(animated: true)
    }
    
    func displayUserInfo(){
        interactor?.displayUserInfo()
    }
    
    func fetchStatements(){
        activityIndicator.startAnimating()
        interactor?.fetchStatements()
    }
    
    func displayStatements(viewModel: UserBalance.FetchStatements.ViewModel)
    {
        activityIndicator.stopAnimating()
        displayedStatements = viewModel.displayedStatements
        tableView.reloadData()
    }
    
    func displayUserInfo(userInfo: UserBalance.FetchStatements.ViewModel.DisplayedUser){
        clientNameUILabel.text = userInfo.name
        clientAccountUILabel.text = userInfo.account
        clientBalanceUILabel.text = userInfo.balance
    }
    
    // MARK: TableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        displayedStatements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StatementTableViewCell.reuseIdentifier)
            as? StatementTableViewCell else { return UITableViewCell() }
        let statement = displayedStatements[indexPath.row]
        cell.setup(displayedStatement: statement)
        return cell
    }
    
}
