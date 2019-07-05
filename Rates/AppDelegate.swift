//
//  AppDelegate.swift
//  Rates
//
//  Created by Nikhil Bolar on 4/3/19.
//  Copyright © 2019 Nikhil Bolar. All rights reserved.
//

import Cocoa
import Alamofire
import SwiftyJSON

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let menu = NSMenu()


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        let statusButton = statusItem.button
        statusButton?.image = NSImage(named: "rates_menubar")
        statusButton?.action = #selector(self.displayPopUp)
        
        let url = URL(string: API_URL_FULL_FORM)
        AF.request(url!).responseData { (response) in
            
            if response.data != nil{
                let json = try! JSON(data: response.data!)
                if let list = json["symbols"].dictionary
                {
                    let sortedList = list.sorted(by: <)
                    for (key, value) in sortedList
                    {
//                        print(key)
                        FULL_FORM[key] = value.stringValue
                    }
                }

            }
        }
        
        if UserDefaults.standard.bool(forKey: "Gesture") == false{
            UserDefaults.standard.set(1, forKey: "Gesture")
        }

        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func displayPopUp() {
        RateService.instance.downloadForecast(completed: {
            NotificationCenter.default.post(name: NOTIF_DOWNLOAD_COMPLETE, object: nil)
        })
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        guard let vc =  storyboard.instantiateController(withIdentifier: "RatesVC") as? NSViewController else { return }
        let popoverView = NSPopover()
        popoverView.contentViewController = vc
        popoverView.behavior = .transient
        popoverView.show(relativeTo: statusItem.button!.bounds, of: statusItem.button!, preferredEdge: .minY)
        
    }


}

