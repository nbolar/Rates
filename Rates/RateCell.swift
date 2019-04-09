//
//  RateCell.swift
//  Rates
//
//  Created by Nikhil Bolar on 4/4/19.
//  Copyright © 2019 Nikhil Bolar. All rights reserved.
//

import Cocoa

class RateCell: NSCollectionViewItem {


    @IBOutlet weak var rateName: NSTextField!
    @IBOutlet weak var rateAmt: NSTextField!
    @IBOutlet weak var currencyFullForm: NSTextField!
    @IBOutlet weak var flagView: NSImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = CGColor.init(gray: 0.9, alpha: 0.2)
        self.view.layer?.cornerRadius = 8
        view.layer?.borderColor = NSColor.white.cgColor
        view.layer?.borderWidth = 0.0
    }
    func setHighlight(selected: Bool) {
        view.layer?.borderWidth = selected ? 3.0 : 0.0
    }
    
    
    func configureCell(rateCell: Rates){
        
        rateName.stringValue = "\(rateCell.rateName)"
        rateAmt.stringValue = "\(rateCell.rateAmt)"
        currencyFullForm.stringValue = "\(rateCell.rateFullForm)"
        flagView.image = NSImage(named: "\(rateCell.rateName)")
        
//        if count < FULL_FORM.count
//        {
//            currencyFullForm.stringValue = FULL_FORM[count]
//            count = count + 1
//        } else {
//            NotificationCenter.default.removeObserver(self, name: NOTIF_DOWNLOAD_COMPLETE, object: nil)
//        }
        

        
        
    }
    
    
    
}
