//
//  NewsTableViewCell.swift
//  SocialAppVK
//
//  Created by Алексей Морозов on 16.10.2020.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var repostButton: UIButton!
    
    @IBOutlet weak var viewsCountLabel: UILabel!
    
    private var post: Post?
    
    private let likeImage = UIImage(systemName: "heart.fill")!
    private let dislikeImage = UIImage(systemName: "heart")!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = Colors.palePurplePantone
        setupView()
    }
    
    private func setupView() {
        self.contentView.backgroundColor = Colors.palePurplePantone
        setupAvatarImageView()
        setupNameLabel()
        setupDateLabel()
        setupTextLabel()
        postImageView.contentMode = .scaleAspectFill
    }
    
    private func setupAvatarImageView() {
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
    }
    
    private func setupNameLabel() {
        nameLabel.textColor = Colors.oxfordBlue
        nameLabel.font = .systemFont(ofSize: 16)
    }
    
    private func setupDateLabel() {
        postDateLabel.textColor = Colors.oxfordBlue
        postDateLabel.font = .systemFont(ofSize: 12, weight: .light)
    }
    
    private func setupTextLabel() {
        postTextLabel.textAlignment = .justified
        postTextLabel.textColor = Colors.oxfordBlue
        postTextLabel.font = .systemFont(ofSize: 15)
    }
    
    private func getStringFromDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        let string = dateFormatter.string(from: date)
        
        return string
    }
    
    private func changeLikeButtonImage() {
        guard let post = post else { return }
        
        if post.likeState == .dislike {
            likeButton.setImage(dislikeImage, for: .normal)
        } else {
            likeButton.setImage(likeImage, for: .normal)
        }
    }
    
    func setValues(item: PostModel) {
//        guard let user = User.getUser(by: item.ownerId) else { return }
        
        post = item as? Post
        
        guard let post = post else { return }
//
//        avatarImageView.image = user.image
//        nameLabel.text = user.name
        
        postDateLabel.text = getStringFromDate(post.date)
        postTextLabel.text = post.text
        postImageView.image = post.image
        
        likeButton.setTitle(String(post.likesCount), for: .normal)
        repostButton.setTitle(String(post.repostsCount), for: .normal)
        commentButton.setTitle(String(post.commentsCount), for: .normal)
        
        viewsCountLabel.text = String(post.viewsCount)
        
        changeLikeButtonImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func changeLikeState() {
//        guard let post = post else { return }
//
//        let userId = post.ownerId
//        let postId = post.id
//
//        for i in 0..<User.database[userId].posts.count {
//            if postId == User.database[userId].posts[i].id {
//                User.database[userId].posts[i].changeLikeState()
//            }
//        }
//        self.post?.changeLikeState()
    }
    
    private func setNewLikeValueWithAnimation(post: Post) {
        UIView.transition(with: likeButton, duration: 0.8, options: [.curveEaseOut, .transitionCurlUp]) {
            self.likeButton.setTitle(String(post.likesCount), for: .normal)
        } completion: { (state) in }
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
        
        if let newPost = getUpdatedPost(id: post.id) {
            self.post = newPost
            setNewLikeValueWithAnimation(post: newPost)
        }
    }
    
    @IBAction func commentButtonPressed(_ sender: UIButton) {
        print(#function)
    }
    
    @IBAction func repostButtonPressed(_ sender: UIButton) {
        print(#function)
    }
}
