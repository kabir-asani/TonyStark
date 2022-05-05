//
//  Notification.swift
//  TonyStark
//
//  Created by Mohammed Sadiq on 05/05/22.
//

import Foundation

protocol RemoteNotification {
    var actor: User { get }
    var creationDate: Date { get }
}

struct LikeNotification: RemoteNotification {
    let actor: User
    let tweet: Tweet
    let creationDate: Date
}

struct CommentNotification: RemoteNotification {
    let actor: User
    let creationDate: Date
    let tweet: Tweet
    let text: String
}

struct FollowNotification: RemoteNotification {
    let actor: User
    let creationDate: Date
}
