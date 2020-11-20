//
//  FriendsTableViewController.swift
//  SocialAppVK
//
//  Created by Алексей Морозов on 05.10.2020.
//

import UIKit

class FriendsTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var sections: [Character] = []             // Массив букв для выделения секций
    var userData: [Character: [User]] = [:]    // Словарь для получения массива пользователей по букве секции
    var searchData: [Character: [User]] = [:]  // Такой же как и userData, только при использовании UISearchBar
    var searchSections: [Character] = []       // Такой же как и sections, используется при UISearchBar
    
    private let reuseIdentifier = "CustomTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        view.backgroundColor = Colors.palePurplePantone
        tableView.sectionIndexBackgroundColor = Colors.palePurplePantone
        
        getUserData()
        resetSearchTableViewData()
        
        // MARK: - Запрос на получение списка друзей
        print("---------------FRIEND LIST---------------")
        NetworkManager.shared.loadFriendList() { json in
            if let json = json {
                print(json)
            }
        }
        
        // MARK: - Запрос на получение данных(фото) пользователя по ID
        print("---------------FRIEND LIST---------------")
        NetworkManager.shared.getUserDataBy(id: "4046880")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserData()
        resetSearchTableViewData()
    }
    
    func getUserData() {
        userData = [:]
        var sectionSet: Set<Character> = []
        for user in User.database {
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "FriendsCollectionViewController") as! FriendsCollectionViewController
        
        let sectionLetter = searchSections[indexPath.section]
        let user = searchData[sectionLetter]![indexPath.row]
        
        vc.posts = user.posts
        vc.title = user.name
        
        self.navigationController?.pushViewController(vc, animated: true)
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
