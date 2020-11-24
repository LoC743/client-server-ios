//
//  FriendsCollectionViewController.swift
//  SocialAppVK
//
//  Created by Алексей Морозов on 05.10.2020.
//

import UIKit



class FriendsCollectionViewController: UICollectionViewController {
    
    private let reuseIdentifier = "PostCollectionViewCell"
    
    var posts: [Image] = []
    var loadedImages: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

        view.backgroundColor = Colors.palePurplePantone
    }
    
    func loadEveryImage(completion: @escaping () -> Void) {
        for post in posts {
            let imageData = NetworkManager.shared.loadImageFrom(url: post.photo200.url)
            if let imageData = imageData,
               let image = UIImage(data: imageData) {
                loadedImages.append(image)
            }
        }
        completion()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostCollectionViewCell
        
        cell.setValues(item: posts[indexPath.item])
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "PhotoViewerViewController") as! PhotoViewerViewController
        
        
        loadEveryImage() { [weak self] in
            guard let self = self else { return }
            
            vc.getPhotosData(photos: self.loadedImages, currentIndex: indexPath.item)
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
