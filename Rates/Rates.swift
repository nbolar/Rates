//
//  Rates.swift
//  Rates
//
//  Created by Nikhil Bolar on 4/8/19.
//  Copyright © 2019 Nikhil Bolar. All rights reserved.
//

import Foundation
import SwiftyJSON

class Rates {
    
    fileprivate var _rateName: String!
    fileprivate var _rateAmt: String!
    fileprivate var _rateFullForm: String!
    fileprivate var _USDAmt: String!
    
    var rateName: String {
        get{
            return _rateName
        } set {
            _rateName = newValue
        }
    }
    var rateAmt: String {
        get{
            return _rateAmt
        } set {
            _rateAmt = newValue
        }
    }
    var rateFullForm: String {
        get{
            return _rateFullForm
        } set {
            _rateFullForm = newValue
        }
    }
    var USDAmt: String {
        get{
            return _USDAmt
        } set {
            _USDAmt = newValue
        }
    }
    
    class func loadRatesFromData(_ APIData: Data) -> [Rates]{
    
        var rates = [Rates]()
        var usdAmt : Double!
        let json = try! JSON(data: APIData)
        
        if let list = json["rates"].dictionary{
            let sortedList = list.sorted(by: <)
            for (key, value) in sortedList
            {
                let newRates = Rates()
                usdAmt = list["USD"]?.doubleValue
                newRates.rateAmt = "\(String(format: "%0.4f",(Double(value.doubleValue) / usdAmt)))"
                newRates.rateName = "\(key)"
                if FULL_FORM.count != 0
                {
                    newRates.rateFullForm = FULL_FORM["\(key)"]!
                }else {
                    newRates.rateFullForm = ""
                }
                
                rates.append(newRates)
            }
        }
        return rates
    }
    

    
}
