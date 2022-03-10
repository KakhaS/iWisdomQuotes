//
//  fetchData.swift
//  iWisdom
//
//  Created by Kakha Sepashvili on 1/15/22.
//

import Foundation
import SwiftUI
import UserNotifications
import Network

struct Quotetype: Codable {
    let text: String
    let author: String?
}

class ViewModel: ObservableObject {
    let defaults = UserDefaults.standard
    @Published var quotes: [Quotetype]?
    @Published var isLoading: Bool = true
    
    var quoteText: String = ""
    var quoteAuthor: String = ""
    
    init() {
        fetchQuotes()
        setUpNotificationPermission()
        setUpNotificationTriggers()
    }
 
    func fetchQuotes()  {
       
        guard let url = URL(string: "https://type.fit/api/quotes") else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self]  data, response, error in
            if error == nil {
                if let data = data {
                    do {
                        let jsonContent = try JSONDecoder().decode([Quotetype].self, from: data)
                        DispatchQueue.main.async { [self] in
                            self?.quotes = jsonContent
                            if self?.quotes?.count != nil {
                                let randomNumber = Int.random(in: 0..<self!.quotes!.count )
                                self?.isLoading = false
                                self?.quoteText = self!.quotes?[randomNumber].text ?? ""
                                self?.quoteAuthor = self!.quotes?[randomNumber].author ?? ""
                                let notificationQuote = self?.quoteText
                                self?.defaults.set(notificationQuote, forKey: "quoteText")
                                
                            }
                        }
                      
                    } catch {
                        print("\(error)")
                    }
                } else {
                    print("Data nil")
                }
            } else {
                print("error \(String(describing: error))")
            }
        }.resume()
    }
    func setUpNotificationTriggers() {
        let content = UNMutableNotificationContent()
        content.title = "Quote of the Day"
        let notificationQuote = defaults.string(forKey: "quoteText")
        content.subtitle = notificationQuote ?? "Be Happy"
      
     

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 120, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}

func setUpNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
        if success {
        } else if let error = error {
            print(error.localizedDescription)
        }
    }
}


class NetworkManager: ObservableObject {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "NetworkManager")
    @Published var isConnected = true
    
    
    init() {
        monitor.pathUpdateHandler  = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}
