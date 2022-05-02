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
            ActionsTableViewCell.self,
            forCellReuseIdentifier: ActionsTableViewCell.reuseIdentifier
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
            let cell = tableView.dequeueReusableCellWithIndexPath(
                withIdentifier: TwitterXLogoTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! TwitterXLogoTableViewCell
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIndexPath(
                withIdentifier: TaglineTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! TaglineTableViewCell
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIndexPath(
                withIdentifier: ActionsTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! ActionsTableViewCell
            
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


extension AuthenticationViewController: ActionsTableViewCellInteractionsHandler {
    func onContinueWithGooglePressed() {
        Task {
            await UserProvider.current.logIn()
            
            if UserProvider.current.isLoggedIn {
                TXEventBroker.shared.emit(event: HomeEvent())
            }
        }
    }
    
    func onContinueWithApplePressed() {
        Task {
            await UserProvider.current.logIn()
            
            if UserProvider.current.isLoggedIn {
                TXEventBroker.shared.emit(event: HomeEvent())
            }
        }
    }
}
