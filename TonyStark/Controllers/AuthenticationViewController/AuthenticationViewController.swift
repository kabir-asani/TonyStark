//
//  AuthenticationViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 30/04/22.
//

import UIKit

class AuthenticationViewController: TXViewController {
    // Declare
    private let tableView: TXTableView = {
        let tableView = TXTableView()
        
        tableView.enableAutolayout()
        
        return tableView
    }()
    
    // Configure
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        
        configureNavigationBar()
        configureTableView()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func configureNavigationBar() {
        let titleImage = TXImageView(image: TXBundledImage.twitterX)
        titleImage.contentMode = .scaleAspectFit
        
        navigationItem.backButtonTitle = ""
        navigationItem.titleView = titleImage
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.addBufferOnHeader(withHeight: 0)
        
        tableView.register(
            TwitterXLogoTableViewCell.self,
            forCellReuseIdentifier: TwitterXLogoTableViewCell.reuseIdentifier
        )
        tableView.register(
            TaglineTableViewCell.self,
            forCellReuseIdentifier: TaglineTableViewCell.reuseIdentifier
        )
        tableView.register(
            AuthenticationActionsTableViewCell.self,
            forCellReuseIdentifier: AuthenticationActionsTableViewCell.reuseIdentifier
        )
        
        tableView.pin(
            to: view,
            byBeingSafeAreaAware: true
        )
    }
    
    // Populate
    
    // Interact
}

// MARK: TXTableViewDataSource
extension AuthenticationViewController: TXTableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return 3
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TwitterXLogoTableViewCell.reuseIdentifier,
                assigning: indexPath
            ) as! TwitterXLogoTableViewCell
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TaglineTableViewCell.reuseIdentifier,
                assigning: indexPath
            ) as! TaglineTableViewCell
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: AuthenticationActionsTableViewCell.reuseIdentifier,
                assigning: indexPath
            ) as! AuthenticationActionsTableViewCell
            
            cell.interactionsHandler = self
            
            return cell
        default:
            fatalError("This row shouldn't be constructured at all")
        }
    }
}

// MARK: TXTableViewDelegate
extension AuthenticationViewController: TXTableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        TXTableView.automaticDimension
    }
}

// MARK: AuthenticationActionsTableViewCellInteractionsHandler
extension AuthenticationViewController: AuthenticationActionsTableViewCellInteractionsHandler {
    func authenticationActionsCellDidContinueWithGoogle() {
        Task {
            let result = await UserProvider.current.logIn(with: .google)
            
            switch result {
            case .success():
                TXEventBroker.shared.emit(event: HomeEvent())
            case .failure(_):
                // TODO: Implement failure cases
                break
            }
        }
    }
    
    func authenticationActionsCellDidContinueWithApple() {
        Task {
            let result = await UserProvider.current.logIn(with: .apple)
            
            switch result {
            case .success():
                TXEventBroker.shared.emit(event: HomeEvent())
            case .failure(_):
                // TODO: Implement failure cases
                break
            }
        }
    }
}
