//
//  FriendsTableViewController.swift
//  SocialAppVK
//
//  Created by Алексей Морозов on 05.10.2020.
//

import UIKit
import RealmSwift

class FriendsTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    lazy var loadingView: UIView = {
        return LoadingView(frame: CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.maxX, height: view.frame.maxY))
    }()
    
    var sections: [Character] = []             // Массив букв для выделения секций
    var userData: [Character: [User]] = [:]    // Словарь для получения массива пользователей по букве секции
    var searchData: [Character: [User]] = [:]  // Такой же как и userData, только при использовании UISearchBar
    var searchSections: [Character] = []       // Такой же как и sections, используется при UISearchBar
    var friendList: [User] = []
    
    var friendsData: Results<User>!
    var friendToken: NotificationToken?
    
    private let reuseIdentifier = "CustomTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLoadingView()
        
        searchBar.delegate = self
        
        tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        view.backgroundColor = Colors.palePurplePantone
        tableView.sectionIndexBackgroundColor = Colors.palePurplePantone
        
        getUserData()
    }
    
    private func setupLoadingView() {
        view.addSubview(loadingView)
        loadingView.isHidden = true
    }
    
    private func getUserData() {
        self.friendsData = DatabaseManager.shared.loadUserData()
        
        resetTableData()
        
        self.friendToken = friendsData.observe(on: DispatchQueue.main, { [weak self] (changes) in
            guard let self = self else { return }
            
            switch changes {
            case .update:
                self.tableView.reloadData()
                break
            case .initial:
                self.tableView.reloadData()
            case .error(let error):
                print("Error in \(#function). Message: \(error.localizedDescription)")
            }
        })
        
        loadFriendList() // Load new data anyways
    }
    
    private func loadFriendList() {
        print("[Network]: Loading friend list..")
        NetworkManager.shared.loadFriendList(count: 0, offset: 0) { friendList in
            DispatchQueue.main.async {
                guard let friendList = friendList else { return }
                DatabaseManager.shared.deleteUserData() // Removing all user data before loading new data from network
                DatabaseManager.shared.saveUserData(users: friendList.friends) // Saving data from network to Realm
            }
        }
    }
    
    private func resetTableData() {
        updateUserData()
        resetSearchTableViewData()
    }
    
    private func updateUserData() {
        userData = [:]
        var sectionSet: Set<Character> = []
        for user in friendsData {
            if let letter = user.name.first {
                sectionSet.insert(letter)

                if userData[letter] == nil {
                    userData[letter] = []
                }

                userData[letter]?.append(user)
            }
        }
        sections = sectionSet.sorted()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return searchSections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionLetter = searchSections[section]
        let users = searchData[sectionLetter] ?? []
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
        return String(searchSections[section])
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CustomTableViewCell
        
        let sectionLetter = searchSections[indexPath.section]
        let user = searchData[sectionLetter]![indexPath.row]
        
        cell.setValues(item: user)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    private func getDatabaseData(userID: Int) -> [Image]? {
        let images = DatabaseManager.shared.loadImageDataBy(ownerID: userID)
        
        guard images.isEmpty else {
            print("[Database]: Returning User Images..")
            return images
        }
        
        return nil
    }
    
    private func loadImages(user: User, network: @escaping (ImageList?) -> Void, database: @escaping (ImageList?) -> Void) {
        print("[Network]: Loading User Images..")
        loadingView.isHidden = false
        NetworkManager.shared.getPhotos(ownerID: String(user.id), count: 30, offset: 0, type: .profile) { [weak self] imageList in
            DispatchQueue.main.async {
                guard let self = self,
                      let imageList = imageList else { return }
                
                DatabaseManager.shared.saveImageData(images: imageList.images)
                
                network(imageList)
                self.loadingView.isHidden = true
            }
        } failure: { [weak self] in
            guard let self = self else { return }
            self.loadingView.isHidden = true
            
            guard let imageData = self.getDatabaseData(userID: user.id) else { return }
            
            database(ImageList(images: imageData))
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "FriendsCollectionViewController") as! FriendsCollectionViewController
        
        let sectionLetter = searchSections[indexPath.section]
        let user = searchData[sectionLetter]![indexPath.row]
        
        vc.title = user.name
        
        loadImages(user: user) { [weak self] (imageList) in
            DispatchQueue.main.async {
                if  let self = self,
                    let imageList = imageList {
                    
                    vc.posts = imageList.images
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        } database: { [weak self] (imageList) in
            DispatchQueue.main.async {
                if  let self = self,
                    let imageList = imageList {
                    
                    vc.posts = imageList.images
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }

    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return searchSections.map { String($0) }
    }
    
    // MARK: - Custom Section View
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeight: CGFloat = 40
        let viewFrame: CGRect = CGRect(x: 0, y: 0, width: tableView.frame.width, height: viewHeight)
        let view = UIView(frame: viewFrame)
        
        view.backgroundColor = Colors.palePurplePantone.withAlphaComponent(0.65)
        
        let sectionLabelFrame: CGRect = CGRect(x: 15, y: 5, width: 15, height: viewHeight/2)
        let sectionLabel = UILabel(frame: sectionLabelFrame)
        sectionLabel.textAlignment = .center
        sectionLabel.textColor = Colors.oxfordBlue
        sectionLabel.text = String(searchSections[section])
        
        view.addSubview(sectionLabel)
        
        return view
    }
    
    // MARK: Cell animation
    
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
    
    // MARK: - SearchBar setup
    
    func resetSearchTableViewData() {
        searchSections = sections
        searchData = userData
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchData = [:]
        searchSections = []
        var sectionSearchSet: Set<Character> = []

        if searchText.isEmpty {
            resetSearchTableViewData()
        } else {
            for section in sections {
                let userArray = userData[section] ?? []

                for user in userArray {
                    if user.name.lowercased().contains(searchText.lowercased()) {
                        if searchData[section] == nil {
                            searchData[section] = []
                        }
                        sectionSearchSet.insert(section)
                        searchData[section]?.append(user)
                    }
                }
            }

            searchSections = Array(sectionSearchSet).sorted()
         }

        self.tableView.reloadData()
    }
}
