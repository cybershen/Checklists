//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Назар Жиленко on 17.07.2022.
//

import UIKit

protocol ItemViewControllerDelegate: AnyObject {
    func ItemViewControllerDidCancel(_ controller: ItemViewController)
    func ItemViewController(_ controller: ItemViewController, didFinishAdding item: ChecklistItem)
    func ItemViewController(_ controller: ItemViewController, didFinishEditing item: ChecklistItem)
}

class ItemViewController: UITableViewController {

    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var delegate: ItemViewControllerDelegate?
    
    var itemToEdit: ChecklistItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneBarButton.isEnabled = false
        
        if let itemToEdit = itemToEdit {
            title = "Edit Item"
            textField.text = itemToEdit.text
            doneBarButton.isEnabled = true
            shouldRemindSwitch.isOn = itemToEdit.shouldRemind
            datePicker.date = itemToEdit.dueDate
        }
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    //MARK: - Actions
    
    @IBAction func cancel() {
        delegate?.ItemViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textField.text!
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = datePicker.date
            item.scheduleNotification()
            delegate?.ItemViewController(self, didFinishEditing: item)
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = datePicker.date
            item.scheduleNotification()
            delegate?.ItemViewController(self, didFinishAdding: item)
        }
    }
    
    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
        textField.resignFirstResponder()
        if switchControl.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) {_, _
                in
            } }
    }
    
    //MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

//MARK: - Text Field Delegate

extension ItemViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //1. We take text from textField
        let oldText = textField.text!
        //2 Change NSRange into swift range
        let stringRange = Range(range, in: oldText)!
        //3 We replace NSString with string, and activate method
        let newText = oldText.replacingCharacters(
            in: stringRange,
            with: string)
        /*
        if newText.isEmpty {
            doneBarButton.isEnabled = false
        } else {
            doneBarButton.isEnabled = true
        } Same construction, but more simply.
         */
        
        // So if the text is empty, doneBarButton is disabled, otherwise it is enabled.
        doneBarButton.isEnabled = !newText.isEmpty
        
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
}
