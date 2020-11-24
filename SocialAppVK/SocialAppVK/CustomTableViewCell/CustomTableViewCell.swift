//
//  CustomTableViewCell.swift
//  SocialAppVK
//
//  Created by Алексей Морозов on 11.10.2020.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarView: CustomAvatarView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = Colors.palePurplePantone
        
        setupAvatarView()
    }
    
    func setValues(item: CellModel) {
        let imageData = NetworkManager.shared.loadImageFrom(url: item.photo.photo_100)
        if let imageData = imageData,
           let image = UIImage(data: imageData) {
            avatarView.setImage(image)
        } else {
            if let image = UIImage(named: "default-profile") {
                avatarView.setImage(image)
            }
        }
        
        
        nameLabel.text = item.name
    }
    
    func setupAvatarView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.avatarViewTapped(_:)))
        avatarView.addGestureRecognizer(tap)
    }
    
    @objc func avatarViewTapped(_ sender: UITapGestureRecognizer) {
        animateAvatarView()
    }
    
    private func animateAvatarView() {
        UIView.animate(withDuration: 1.3, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: [.autoreverse]) {
            self.avatarView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        } completion: { (state) in
            self.avatarView.transform = .identity
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
