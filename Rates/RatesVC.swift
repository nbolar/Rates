//
//  RatesVC.swift
//  Rates
//
//  Created by Nikhil Bolar on 4/4/19.
//  Copyright © 2019 Nikhil Bolar. All rights reserved.
//

import Cocoa
import Alamofire
import SwiftyJSON

class RatesVC: NSViewController {

    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var fromCurrency: NSButton!
    @IBOutlet weak var toCurrency: NSButton!
    @IBOutlet weak var fromCurrencyLabel: NSTextField!
    @IBOutlet weak var toCurrencyLabel: NSTextField!
    @IBOutlet weak var selectFirst: NSButton!
    @IBOutlet weak var chooseLabelFrom: NSTextField!
    @IBOutlet weak var chooseLabelTo: NSTextField!
    @IBOutlet weak var convertButton: NSButton!
    @IBOutlet weak var gestureImage: NSImageView!
    @IBOutlet weak var searchBar: NSTextField!
    @IBOutlet weak var baseCurrencyButton: NSPopUpButton!
    @IBOutlet weak var updatedString: NSTextField!
    
    var previousIndexPath : Set<NSIndexPath>!
    var buttonPressed = 2
    var fromCurrencyValue : Double!
    var conversionRate : Double!
    var currentRate : Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = .clear
        let image = NSImage(named: "rates_background")
        self.view.layer?.contents = image
        self.view.layer?.cornerRadius = 8
        
        gestureImage.isHidden = false
        gestureImage.wantsLayer = true
        gestureImage.layer?.backgroundColor = CGColor.init(gray: 0.1, alpha: 0.5)
        gestureImage.layer?.cornerRadius = 5
        Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.dismissText), userInfo: nil, repeats: false)
        
        fromCurrencyLabel.wantsLayer = true
        fromCurrencyLabel.layer?.backgroundColor = .clear
        fromCurrencyLabel.layer?.borderColor = .white
        fromCurrencyLabel.layer?.borderWidth = 1
        fromCurrencyLabel.layer?.cornerRadius = 5
        fromCurrencyLabel.textColor = NSColor.white
        fromCurrencyLabel.drawsBackground = false
        

        
        toCurrencyLabel.wantsLayer = true
        toCurrencyLabel.layer?.backgroundColor = .clear
        toCurrencyLabel.layer?.borderColor = .white
        toCurrencyLabel.layer?.borderWidth = 1
        toCurrencyLabel.layer?.cornerRadius = 5
        toCurrencyLabel.textColor = NSColor.white

        toCurrencyLabel.drawsBackground = false
        
        
        searchBar.wantsLayer = true
        searchBar.layer?.backgroundColor = .clear
        searchBar.layer?.borderColor = .white
        searchBar.layer?.borderWidth = 1
        searchBar.layer?.cornerRadius = 5
        searchBar.textColor = NSColor.white
        searchBar.drawsBackground = false
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = false
        chooseLabelTo.isHidden = true
        chooseLabelFrom.isHidden = true
        toCurrency.isHidden = true
        toCurrencyLabel.isHidden = true
        fromCurrencyLabel.isHidden = true
        fromCurrency.isHidden = true
        convertButton.isHidden = true
        convertButton.isEnabled = false
        
        fillPopUpButton()
        downloadRates()
        
        
    }
    
    func fillPopUpButton()
    {
        
        baseCurrencyButton.removeAllItems()
        let sortedList = FULL_FORM.sorted(by: <)
        for (key,_) in sortedList{
            baseCurrencyButton.addItems(withTitles: [key])
        }
        baseCurrencyButton.selectItem(withTitle: baseCurrency)
        
    }
    
    @IBAction func popUpButtonClicked(_ sender: NSPopUpButton) {
        baseCurrency = baseCurrencyButton.titleOfSelectedItem ?? "USD"
        RateService.instance.downloadForecast(completed: {
            NotificationCenter.default.post(name: NOTIF_DOWNLOAD_COMPLETE, object: nil)
        })
        collectionView.reloadData()
        let indexItem = NSIndexPath(forItem: 0, inSection: 0)
        collectionView.animator().scrollToItems(at: [indexItem as IndexPath] , scrollPosition: .right)
    }
    
    @objc func dismissText()
    {
        gestureImage.isHidden = true
    }
    
    override func viewDidAppear() {
        NotificationCenter.default.addObserver(self, selector: #selector(RatesVC.dataDownloadedNotif(_:)), name: NOTIF_DOWNLOAD_COMPLETE, object: nil)
    }
    override func viewDidDisappear() {
        NotificationCenter.default.removeObserver(self, name: NOTIF_DOWNLOAD_COMPLETE, object: nil)
    }
    @objc func dataDownloadedNotif(_ notif: Notification){
        viewDidLoad()
        
    }
    
    
    func downloadRates()
    {

        collectionView.reloadData()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        updatedString.stringValue = "Prices last updated at : \(dateFormatter.string(from: Date(timeIntervalSince1970: updatedTime)))"
    }
    
    func highlightItems(selected: Bool, atIndexPaths: Set<NSIndexPath>) {
        
        for indexPath in atIndexPaths {
            guard let item = collectionView.item(at: indexPath as IndexPath) else {continue}
            (item as! RateCell).setHighlight(selected: selected)

            
        }
        previousIndexPath = atIndexPaths
        unhideToCurrency()
        if buttonPressed == 0
        {
            fromMoney(atIndexPaths: previousIndexPath)
            chooseLabelFrom.isHidden = true
            toCurrencyLabel.isHidden = false
            
        }else if buttonPressed == 1
        {
            chooseLabelTo.isHidden = true
            toMoney(atIndexPaths: previousIndexPath)
            
            
        }

    }
    
    
    @IBAction func fromButtonClicked(_ sender: NSButton) {
        if previousIndexPath != nil{
            highlightItems(selected: false, atIndexPaths: previousIndexPath)
            collectionView.reloadItems(at: previousIndexPath! as Set<IndexPath>)
        }

        chooseLabelFrom.isHidden = false
        collectionView.isSelectable = true
        toCurrency.isHidden = true
        toCurrencyLabel.isHidden = true
        selectFirst.isHidden = true
        selectFirst.isEnabled = false
        buttonPressed = 0
        
        
    }
    
    func fromMoney(atIndexPaths: Set<NSIndexPath>)
    {
        for indexPath in atIndexPaths {
            guard let item = collectionView.item(at: indexPath as IndexPath) else {continue}
            let fromString = "\((item as! RateCell).rateName.stringValue)"
            currentRate = (item as! RateCell).rateAmt.doubleValue
            fromCurrencyLabel.placeholderAttributedString = NSAttributedString(string: fromString, attributes: [NSAttributedString.Key.foregroundColor: NSColor.white])        
        }
        
    }
    
    func toMoney(atIndexPaths: Set<NSIndexPath>)
    {
        for indexPath in atIndexPaths {
            guard let item = collectionView.item(at: indexPath as IndexPath) else {continue}
            let toString = "\((item as! RateCell).rateName.stringValue)"
            conversionRate = (item as! RateCell).rateAmt.doubleValue
            toCurrencyLabel.stringValue = toString
            
            
        }

    }
    
    func unhideToCurrency()
    {
        chooseLabelFrom.isHidden = true
        toCurrency.isHidden = false
        fromCurrencyLabel.isHidden = false
        fromCurrency.isHidden = false
    }
    
    @IBAction func toButtonClicked(_ sender: NSButton) {
        highlightItems(selected: false, atIndexPaths: previousIndexPath)
        collectionView.reloadItems(at: previousIndexPath! as Set<IndexPath>)
        chooseLabelTo.isHidden = false
        toCurrencyLabel.isHidden = false
        buttonPressed = 1
        convertButton.isHidden = false
        convertButton.isEnabled = true

        

    }
    @IBAction func performConversion(_ sender: Any) {
        if (fromCurrencyLabel.stringValue.count) != 0{
            toCurrencyLabel.stringValue = "\(String(format: "%0.4f", ((fromCurrencyLabel.doubleValue) / currentRate) * conversionRate))"
        }
        
        
        
    }
    
    @IBAction func searchItem(_ sender: Any) {
        count = 0
        
        let sortedList = FULL_FORM.sorted(by: <)
        for (key,value) in sortedList{
            if searchBar.stringValue.count != 0{
                if key == searchBar.stringValue.uppercased(){
                    scroll(position: count)
                    break
                    
                }else if value.uppercased() == searchBar.stringValue.uppercased()
                {
                    scroll(position: count)
                    break
                }
                count = count + 1
            }

        }

        
    }
    
    func scroll(position : Int)
    {
        searchBar.stringValue = ""
        let itemIndex = NSIndexPath(forItem: count, inSection: 0)
        let ctx = NSAnimationContext.current
        ctx.allowsImplicitAnimation = true
        collectionView.animator().scrollToItems(at: [itemIndex as IndexPath], scrollPosition: .right)
        let item = collectionView.item(at: itemIndex as IndexPath)
        (item as! RateCell).setHighlight(selected: true)
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.unhighlight), userInfo: nil, repeats: false)
        
        
    }
    
    @objc func unhighlight()
    {
        let itemIndex = NSIndexPath(forItem: count, inSection: 0)
        let item = collectionView.item(at: itemIndex as IndexPath)
        (item as! RateCell).setHighlight(selected: false)
    }
    
    @IBAction func quitButtonClicked(_ sender: NSButton) {
        NSApp.terminate(nil)
    }
    
}




extension RatesVC: NSCollectionViewDelegate, NSCollectionViewDataSource, NSCollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let forecastItem = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "RateCell"), for: indexPath)
        guard let forecastCell = forecastItem as? RateCell else {
            return forecastItem
        }
        
        forecastCell.configureCell(rateCell: RateService.instance.rates[indexPath.item])
 
        
        return forecastCell
        

    }
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        collectionView.isSelectable = false
        return 1
    }
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return RateService.instance.rates.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        return NSSize(width: 190, height: 35)
    }
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        highlightItems(selected: true, atIndexPaths: indexPaths as Set<NSIndexPath>)
    }
    func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        highlightItems(selected: false, atIndexPaths: indexPaths as Set<NSIndexPath>)
    }
    


}

