//
//  EntryListTableViewController.swift
//  CK_Journal_27
//
//  Created by Leah Cluff on 7/8/19.
//  Copyright © 2019 Leah Cluff. All rights reserved.
//

import UIKit

class EntryListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EntryController.sharedInstance.fetchEntries { (success) in
            if success{
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return EntryController.sharedInstance.entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        let entry = EntryController.sharedInstance.entries[indexPath.row]
        cell.textLabel?.text = entry.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entryController = EntryController.sharedInstance
            let entry = entryController.entries[indexPath.row]
            entryController.delete(entry: entry)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toExistingVC"{
            let destinationVC = segue.destination as? EntryDetailViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let entry = EntryController.sharedInstance.entries[indexPath.row]
            destinationVC?.entry = entry
        }
    }
}

