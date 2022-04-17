//
//  FeedViewController.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 16/03/22.
//

import UIKit

class FeedViewController: TXTableViewController {
    private let tweets: [Tweet] = [
        Tweet(
            id: "ar93hdk4",
            text: """
            English
            """,
            creationDate: Date(),
            meta: TweetMeta(
                likesCount: 0,
                commentsCount: 0
            ),
            author: User(
                id: "ar93hdk4",
                name: "Sadiya Khan",
                username: "sadiyakhan",
                image: "https://www.mirchi9.com/wp-content/uploads/2022/02/Mahesh-Fans-Firing-on-Pooja-Hegde.jpg",
                bio: """
                I'm simple and soft.
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
            ),
            viewables: TweetViewables(
                liked: true,
                bookmarked: true
            )
        ),
        Tweet(
            id: "ar93hdk4",
            text: """
            This is rather fun you know.
            A lot has been said and done about you guys.
            Let's rock and roll people.
            """,
            creationDate: Date(),
            meta: TweetMeta(
                likesCount: 0,
                commentsCount: 0
            ),
            author: User(
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
            ),
            viewables: TweetViewables(
                liked: true,
                bookmarked: true
            )
        ),
        Tweet(
            id: "ar93hdk4",
            text: """
            I agree it's all opinions here.
            I need to agree yours.
            You need to agree mine.
            Because we stand in two different phase of life and speak.
            """,
            creationDate: Date(),
            meta: TweetMeta(
                likesCount: 0,
                commentsCount: 0
            ),
            author: User(
                id: "ar93hdk4",
                name: "Ramya kembal",
                username: "RamyaKembal",
                image: "https://pbs.twimg.com/profile_images/1190200299727851526/A26tGnda_400x400.jpg",
                bio: """
                I'm simple and soft.
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
            ),
            viewables: TweetViewables(
                liked: true,
                bookmarked: true
            )
        ),
        Tweet(
            id: "ar93hdk4",
            text: """
            This is super fun
            """,
            creationDate: Date(),
            meta: TweetMeta(
                likesCount: 0,
                commentsCount: 0
            ),
            author: User(
                id: "ar93hdk4",
                name: "Zain Khan",
                username: "mzaink",
                image: "https://pbs.twimg.com/profile_images/1483797876522512385/9CcO904A_400x400.jpg",
                bio: """
                I'm simple and soft.
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
            ),
            viewables: TweetViewables(
                liked: true,
                bookmarked: true
            )
        ),
        Tweet(
            id: "ar93hdk4",
            text: """
            Every entrepreneur I meet says it’s so difficult to find people to work, and on the other hand the unemployment percentage is so high. Something is broken, and it needs fixing asap.
            """,
            creationDate: Date(),
            meta: TweetMeta(
                likesCount: 0,
                commentsCount: 0
            ),
            author: User(
                id: "ar93hdk4",
                name: "Gabbar",
                username: "GabbbarSingh",
                image: "https://pbs.twimg.com/profile_images/1271082702326784003/1kIF_loZ_400x400.jpg",
                bio: """
                Co-Founder @JoinZorro | Founder @GingerMonkeyIN
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
            ),
            viewables: TweetViewables(
                liked: true,
                bookmarked: true
            )
        ),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureTableView()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "TwitterX"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = TXBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(onComposePressed(_:))
        )
    }
    
    private func configureTableView() {
        tableView.register(
            TweetTableViewCell.self,
            forCellReuseIdentifier: TweetTableViewCell.reuseIdentifier
        )
    }
    
    @objc private func onComposePressed(_ sender: UIBarButtonItem) {
        let composeViewController = TXNavigationController(
            rootViewController: ComposeViewController(style: .insetGrouped)
        )
        
        composeViewController.modalPresentationStyle = .fullScreen
        
        present(composeViewController, animated: true)
    }
}


// MARK: UITableViewDelegate
extension FeedViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: TweetTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! TweetTableViewCell
        
        cell.configure(with: tweets[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: UITableViewDataSource
extension FeedViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
}
