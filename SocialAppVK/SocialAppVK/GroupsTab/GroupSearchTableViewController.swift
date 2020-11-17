//
//  GroupSearchTableViewController.swift
//  SocialAppVK
//
//  Created by Алексей Морозов on 11.10.2020.
//

import UIKit

class GroupSearchTableViewController: UITableViewController {
    var groups: [Group] {
        get {
            return Group.database.filter { $0.isAdded == false }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
        
        view.backgroundColor = Colors.palePurplePantone
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        
        cell.setValues(item: groups[indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = groups[indexPath.row].id
        Group.changeGroupAdded(by: id)
        
        self.navigationController?.popViewController(animated: true)
    }

}
