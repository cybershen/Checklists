//
//  IconPickerController.swift
//  Checklists
//
//  Created by Назар Жиленко on 23.07.2022.
//

import UIKit

protocol IconPickerViewControllerDelegate: AnyObject {
    func iconPicker(_ picker: IconPickerController, didPick iconName: String)
}

class IconPickerController: UITableViewController {
    
    weak var delegate: IconPickerViewControllerDelegate?
    
    let icons = [
      "No Icon", "Appointments", "Birthdays", "Chores",
      "Drinks", "Folder", "Groceries", "Inbox", "Photos", "Trips"
    ]
    
    //MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
        let iconName = icons[indexPath.row]
        cell.textLabel?.text = iconName
        cell.imageView?.image = UIImage(named: iconName)
        return cell
    }
    
    //MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            let iconName = icons[indexPath.row]
            delegate.iconPicker(self, didPick: iconName)
        }
    }
}
