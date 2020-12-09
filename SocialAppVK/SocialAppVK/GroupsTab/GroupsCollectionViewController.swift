//
//  GroupsCollectionViewController.swift
//  SocialAppVK
//
//  Created by Алексей Морозов on 25.11.2020.
//

import UIKit
import RealmSwift

class GroupsCollectionViewController: UICollectionViewController {
    
    private let reuseIdentifier = "PostCollectionViewCell"
    
    var posts: Results<Image>!
    var token: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

        view.backgroundColor = Colors.palePurplePantone
    }

    private func loadImages(group: Group, network: @escaping (ImageList?) -> Void) {
        let groupID: Int = Int(-group.id)
        NetworkManager.shared.getPhotos(ownerID: String(groupID), count: 30, offset: 0, type: .wall) { imageList in
            DispatchQueue.main.async {
                guard let imageList = imageList else { return }

                DatabaseManager.shared.saveImageData(images: imageList.images)
                
                network(imageList)
            }
        } failure: {  }
    }
    
    func getImages(group: Group) {
        let groupID: Int = Int(-group.id)
        
        self.posts = DatabaseManager.shared.loadImageDataBy(ownerID: groupID)
        self.token = posts.observe(on: DispatchQueue.main, { [weak self] (changes) in
            guard let self = self else { return }
            
            switch changes {
            case .update:
                self.collectionView.reloadData()
                break
            case .initial:
                self.collectionView.reloadData()
            case .error(let error):
                print("Error in \(#function). Message: \(error.localizedDescription)")
            }
        })
        
        loadImages(group: group) { (imageList) in
            DispatchQueue.main.async {
                   if let imageList = imageList {
                    DatabaseManager.shared.saveImageData(images: imageList.images)
                }
            }
        }
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
        
        let images: [Image] = posts.map { $0 }
        
        vc.getPhotosData(photos: images, currentIndex: indexPath.item)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
