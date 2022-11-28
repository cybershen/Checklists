//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Назар Жиленко on 17.07.2022.
//

import Foundation
import UserNotifications

class ChecklistItem: NSObject, Codable {
    var text = ""
    var checked = false
    
    var dueDate = Date()
    var shouldRemind = false
    var itemID = -1
    
    func scheduleNotification() {
        if shouldRemind && dueDate > Date() {
            // 1
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = UNNotificationSound.default
            // 2
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: dueDate)
            // 3
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: components,
                repeats: false)
            // 4
            let request = UNNotificationRequest(
                identifier: "\(itemID)",content: content, trigger: trigger)
            // 5
            let center = UNUserNotificationCenter.current()
            center.add(request)
            print("Scheduled: \(request) for itemID: \(itemID)")
        }
        removeNotification()
    }
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
    
    override init() {
        super.init()
        itemID = DataModel.nextChecklistItemID()
    }
    
    deinit {
     removeNotification()
   }
}
