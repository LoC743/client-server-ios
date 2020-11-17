//
//  PostCollectionViewCell.swift
//  SocialAppVK
//
//  Created by Алексей Морозов on 11.10.2020.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    private var post: Post?
    
    private let likeImage = UIImage(systemName: "heart.fill")!
    private let dislikeImage = UIImage(systemName: "heart")!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = .cyan
        
        setupImageView()
    }
    
    private func setupImageView() {
        imageView.contentMode = .scaleAspectFill
    }
    
    private func setupLikeButton() {
        guard let post = post else { return }
        
        if post.likeState == .dislike {
            likeButton.setImage(dislikeImage, for: .normal)
        } else {
            likeButton.setImage(likeImage, for: .normal)
        }
    }
    
    func setValues(item: PostModel) {
        post = item as? Post
        
        imageView.image = item.image
        
        setupLikeButton()
    }
    
    private func changeLikeState() {
        guard let post = post else { return }
        
        let userId = post.ownerId
        let postId = post.id
        
        for i in 0..<User.database[userId].posts.count {
            if postId == User.database[userId].posts[i].id {
                User.database[userId].posts[i].changeLikeState()
            }
        }
        
        self.post?.changeLikeState()
    }

    @IBAction func likeButtonPressed(_ sender: UIButton) {
        guard let post = self.post else { return }
        
        if post.likeState == .dislike {
            likeButton.setImage(likeImage, for: .normal)
            changeLikeState()
        } else {
            likeButton.setImage(dislikeImage, for: .normal)
            changeLikeState()
        }
        
        print(#function)
    }
}
