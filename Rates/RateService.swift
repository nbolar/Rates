//
//  RateService.swift
//  Rates
//
//  Created by Nikhil Bolar on 4/8/19.
//  Copyright © 2019 Nikhil Bolar. All rights reserved.
//

import Foundation
import Alamofire

class RateService
{
    
    static let instance = RateService()
    fileprivate var _rates = [Rates]()
    
    var rates: [Rates]{
        get{
            return _rates
        } set {
            _rates = newValue
        }
        
    }
    
    func downloadForecast(completed: @escaping DownloadComplete) {
        
        let url = URL(string: API_URL)
        AF.request(url!).responseData { (response) in
            
            if response.data != nil
            {
                self.rates = Rates.loadRatesFromData(response.data!)
            }
            
            completed()
        }
        
        
    }
    
    
}
