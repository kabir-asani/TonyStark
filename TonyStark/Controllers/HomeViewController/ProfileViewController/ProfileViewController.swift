//
//  ProfileViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

enum ProfileViewSegmentedItem: String {
    case tweets = "Tweets"
    case bookmarks = "Bookmarks"
}

class ProfileViewController: TXTableViewController {
    let user = User(
        id: "ar93hdk4",
        name: "Zain Khan",
        username: "mzaink",
        image: "https://pbs.twimg.com/profile_images/1483797876522512385/9CcO904A_400x400.jpg",
        bio: """
        Hungry for knowledge. Satiated with life. ✌️
        """,
        creationDate: Date(),
        socialDetails: UserSocialDetails(
            followersCount: 0,
            followingsCount: 0
        ),
        activityDetails: UserActivityDetails(
            tweetsCount: 0
        ),
        viewables: UserViewables(follower: true)
    )
    
    let segmentedControl: TXSegmentedControl = {
        let segmentedControl = TXSegmentedControl(
            items: [
                ProfileViewSegmentedItem.tweets.rawValue,
                ProfileViewSegmentedItem.bookmarks.rawValue
            ]
        )
        
        segmentedControl.selectedSegmentIndex = 0
        
        return segmentedControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
        configureSegmentedControl()
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = TXBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal"),
            style: .plain,
            target: self,
            action: #selector(onActionPressed(_:))
        )
        
    }
    
    private func configureTableView() {
        tableView.register(
            ProfileTableViewCell.self,
            forCellReuseIdentifier: ProfileTableViewCell.reuseIdentifier
        )
    }
    
    private func configureSegmentedControl() {
        segmentedControl.addTarget(
            self,
            action: #selector(onSegmentedControlPressed(_:)),
            for: .valueChanged
        )
    }
    
    @objc private func onActionPressed(_ sender: UIBarButtonItem) {
        print(#function)
    }
    
    @objc private func onSegmentedControlPressed(_ sender: UISegmentedControl) {
        print(#function)
    }
}

// MARK: UITableViewDataSource
extension ProfileViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: UITableViewDelegate
extension ProfileViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ProfileTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! ProfileTableViewCell
        
        cell.populate(with: user)
        
        return cell
    }
}
