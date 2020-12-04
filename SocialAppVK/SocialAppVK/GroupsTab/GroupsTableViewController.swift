//
//  GroupsTableViewController.swift
//  SocialAppVK
//
//  Created by Алексей Морозов on 05.10.2020.
//

import UIKit

class GroupsTableViewController: UITableViewController {
    
    lazy var loadingView: UIView = {
        return LoadingView(frame: CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.maxX, height: view.frame.maxY))
    }()
    
    var userGroups: [Group] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLoadingView()
        
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
        
        view.backgroundColor = Colors.palePurplePantone
        
        checkLoadedData()
    }
    
    private func setupLoadingView() {
        view.addSubview(loadingView)
        loadingView.isHidden = true
    }
    
    func checkLoadedData() {
        let savedGroupData = DatabaseManager.shared.loadGroupData()
        
        // Show old data from DB
        guard savedGroupData.isEmpty else {
            print("[Database]: Loading group data..")
            self.userGroups = savedGroupData
            self.tableView.reloadData()
            
            loadGroupList() // Load new data
            
            return
        }
        
        loadGroupList()
    }
    
    private func loadGroupList() {
        print("[Network]: Loading group data..")
        NetworkManager.shared.loadGroupsList(count: 0, offset: 0) { [weak self] groupsList in
            DispatchQueue.main.async {
                guard let self = self,
                      let groupsList = groupsList else { return }
                DatabaseManager.shared.deleteGroupData() // Removing all group data before loading new data from network
                self.userGroups = groupsList.groups
                DatabaseManager.shared.saveGroupData(groups: groupsList.groups) // Saving data from network to Realm
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userGroups.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        
        cell.setValues(item: userGroups[indexPath.row])

        return cell
    }
    
    private func getDatabaseData(groupID: Int) -> [Image]? {
        let images = DatabaseManager.shared.loadImageDataBy(ownerID: groupID)
        
        guard images.isEmpty else {
            print("[Database]: Returning Group Images..")
            return images
        }
        
        return nil
    }
    
    private func loadImages(group: Group, network: @escaping (ImageList?) -> Void, database: @escaping (ImageList?) -> Void) {
        print("[Network]: Loading Group Images..")
        loadingView.isHidden = false
        let groupID: Int = Int(-group.id)
        NetworkManager.shared.getPhotos(ownerID: String(groupID), count: 30, offset: 0, type: .wall) { [weak self] imageList in
            DispatchQueue.main.async {
                guard let self = self,
                      let imageList = imageList else { return }
                
                DatabaseManager.shared.saveImageData(images: imageList.images)
                
                self.loadingView.isHidden = true
                network(imageList)
            }
        } failure: { [weak self] in
            guard let self = self else { return }
            self.loadingView.isHidden = true
            
            guard let imageData = self.getDatabaseData(groupID: groupID) else { return }
            
            database(ImageList(images: imageData))
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "GroupsCollectionViewController") as! GroupsCollectionViewController
        
        let group = userGroups[indexPath.row]
        
        vc.title = group.name
        
        loadImages(group: group) { [weak self] (imageList) in
            DispatchQueue.main.async {
                if let self = self,
                   let imageList = imageList {
                    vc.posts = imageList.images
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        } database: { [weak self] (imageList) in
            DispatchQueue.main.async {
                if let self = self,
                   let imageList = imageList {
                    vc.posts = imageList.images
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
//            let id = userGroups[indexPath.row].id
//            Group.changeGroupAdded(by: id)
            
//            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Before animation
        cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        cell.alpha = 0.0
        
        // Animation
        UIView.animate(withDuration: 1.0) {
            cell.transform = .identity
            cell.alpha = 1.0
        }
    }
}
