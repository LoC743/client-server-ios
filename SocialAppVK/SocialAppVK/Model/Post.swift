//
//  Post.swift
//  SocialAppVK
//
//  Created by Алексей Морозов on 11.10.2020.
//

import UIKit

enum LikeState {
    case like
    case dislike
}

protocol PostModel {
    var ownerId: Int { get }
    
    var date: Date { get set }
    var image: UIImage { get set }
    var likeState: LikeState { get set }
    var text: String { get set }
}

struct Post: PostModel {
    let id: Int
    let ownerId: Int
    
    var image: UIImage
    var likeState: LikeState
    var date: Date
    var text: String
    
    var likesCount: Int
    var commentsCount: Int
    var viewsCount: Int
    var repostsCount: Int
    
    mutating func changeLikeState() {
        if likeState == .dislike {
            likeState = .like
            likesCount += 1
        } else {
            likeState = .dislike
            likesCount -= 1
        }
    }
}

// Временно
func getUpdatedPost(id: Int) -> Post? {
    for user in User.database {
        for post in user.posts {
            if post.id == id {
                return post
            }
        }
    }
    return nil
}

