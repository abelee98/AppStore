//
//  Models.swift
//  AppStore
//
//  Created by Abraham Lee on 6/10/18.
//  Copyright © 2018 Abraham Lee. All rights reserved.
//

import UIKit

class AppCategory: NSObject {
    var name: String?
    var apps: [App]?
    var type: String?
    
    static func fetchFeaturedApps(completionHandler: @escaping ([AppCategory]) -> ()) {
        let urlString = URL(string: "https://api.letsbuildthatapp.com/appstore/featured")!
        let URLString = URLRequest(url: urlString)
        
        URLSession.shared.dataTask(with: URLString, completionHandler: { (data, response, error) in
            if error != nil {
                print(error ?? "")
                return
            }
            
            do {
                let json = try (JSONSerialization.jsonObject(with: data!, options: .mutableContainers)) as! [String: AnyObject]
                var appCategories = [AppCategory]()
                for dict in json["categories"] as! [[String: Any]] {
                    let appCategory = AppCategory()
                    var appList = [App]()
                    for appDict in dict["apps"] as! [[String: Any]] {
                        let app = App()
                        app.Id = appDict["Id"] as? NSNumber
                        app.ImageName = appDict["ImageName"] as? String
                        app.Name = appDict["Name"] as? String
                        app.Category = appDict["Category"] as? String
                        app.Price = appDict["Price"] as? NSNumber
                        appList.append(app)
                    }
                    appCategory.name = dict["name"] as? String
                    appCategory.type = dict["type"] as? String
                    appCategory.apps = appList
                    appCategories.append(appCategory)
                }
                
                DispatchQueue.main.async {
                    completionHandler(appCategories)
                }
                
            } catch let err {
                print(err)
            }
            
        }).resume()
    }
    
    static func sampleAppCategories() -> [AppCategory] {
        let bestNewApps = AppCategory()
        bestNewApps.name = "Best New Apps"
        
        var apps = [App]()
        
        let ketchup = App()
        ketchup.Name = "Frozen"
        ketchup.Price = NSNumber(value: 3.99)
        ketchup.Category = "Entertainment"
        ketchup.ImageName = "frozen"
        
        apps.append(ketchup)
        
        bestNewApps.apps = apps
        
        let bestNewGames = AppCategory()
        bestNewGames.name = "Best New Games"
        
        var bestNewGamesApp = [App]()
        
        let telepaint = App()
        telepaint.Name = "Telepaint"
        telepaint.Price = NSNumber(value: 2.99)
        telepaint.Category = "Entertainment"
        telepaint.ImageName = "telepaint"
        
        bestNewGamesApp.append(telepaint)
        
        bestNewGames.apps = bestNewGamesApp
        
        return [bestNewApps, bestNewGames]
    }
}

class App: NSObject {
    var Price: NSNumber?
    var Id: NSNumber?
    var Category: String?
    var ImageName: String?
    var Name: String?
}
