//
//  GroupsViewController.swift
//  VocMemory
//
//  Created by mendel bellaiche on 29/12/2019.
//  Copyright © 2019 mendel bellaiche. All rights reserved.
//

import UIKit
import Toast_Swift

class GroupsViewController: UIViewController {

    var groups: [Group]?
    
    @IBOutlet weak var groupsTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.groupsTV.delegate = self
        self.groupsTV.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.groups = CoreDataHelper.shared.readGroup()
        self.groupsTV.reloadData()
    }

    @IBAction func addGroupTapped(_ sender: UIButton) {
        let addGroupPopUp = UIAlertController(title: "Add a new group", message: "What the title of the group ?", preferredStyle: .alert)
        
        addGroupPopUp.addTextField { textfield in
            textfield.placeholder = "Title of group"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { alert in
            if let tf = addGroupPopUp.textFields?.first, let text = tf.text {
                if text != "" {
                    CoreDataHelper.shared.createGroup(name: text) { (result, error) in
                        if error != nil {
                            return
                        }
                        self.groups?.append(result)
                        self.groupsTV.reloadData()
                        
                        DispatchQueue.main.async {
                            ToastUtils.shared.displayMessage(view: self, message: "Group added from the list", duration: 3.0, position: .bottom)
                        }
                    }
                    
                } else {
                    ToastUtils.shared.displayMessage(view: self, message: "Error occured during creation of group", duration: 3.0, position: .bottom)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        addGroupPopUp.addAction(addAction)
        addGroupPopUp.addAction(cancelAction)
        self.present(addGroupPopUp, animated: true, completion: nil)
    }
    
}


extension GroupsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groups!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.groups![indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataHelper.shared.deleteGroup(group: self.groups![indexPath.row]) { error in
                if error != nil {
                    return
                }
                self.groups?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                DispatchQueue.main.async {
                    ToastUtils.shared.displayMessage(view: self, message: "Group deleted from the list", duration: 3.0, position: .bottom)
                }
            }
        }
    }
    
}
