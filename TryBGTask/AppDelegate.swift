//
//  AppDelegate.swift
//  TryBGTask
//
//  Created by Salman Soumik on 6/6/22.
//

import UIKit
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
       // let jsonData = try! JSONSerialization.jsonObject(with: data) as! NSDictionary
        // UserDefaults.standard.set(jsonData["link"] as! String, forKey: "SavedFile")
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        let url = URL(string: "http://192.168.2.6:3000/v1/users/57c987df4d8004f71a41fc3e/set_token")
        let param = "token=\(token)"
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url!)
        request.httpBody = param.data(using: .utf8)
        request.httpMethod = "POST"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request) { data, response, err in
            let found = try? JSONSerialization.jsonObject(with: data!,options: .fragmentsAllowed)
            print(found)
        }
        task.resume()
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Push Got")
        
        let url = URL(string: "http://192.168.2.6:3000/v1/users/57c987df4d8004f71a41fc3e/got_alive")
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request) { data, response, err in
            let found = try? JSONSerialization.jsonObject(with: data!,options: .fragmentsAllowed)
            print(found)
        }
        task.resume()
        
        completionHandler(.newData)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("Found:" + (UserDefaults.standard.string(forKey: "SavedFile") ?? ""))
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound]) {(granted, error) in
                // Make sure permission to receive push notifications is granted
                print("Permission is granted: \(granted)")
        }
        UIApplication.shared.registerForRemoteNotifications()
        let path = Bundle.main.url(forResource: "qrIllustration", withExtension: "png")
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
           let fileURL = documentsDirectory.appendingPathComponent("qrIllustration.png")
           do {
               let fileManager = FileManager.default
               try fileManager.copyItem(at: path!, to: fileURL)
           } catch let ex {
               print("an error happened while checking for the file")
           }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

