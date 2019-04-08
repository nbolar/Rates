//
//  Constants.swift
//  Rates
//
//  Created by Nikhil Bolar on 4/8/19.
//  Copyright © 2019 Nikhil Bolar. All rights reserved.
//

import Foundation


typealias DownloadComplete = () -> ()

let NOTIF_DOWNLOAD_COMPLETE = NSNotification.Name("dataDownloaded")

var API_KEY = "9b954de2417aeb0f703b799680e7d4f4"
var API_URL = "http://data.fixer.io/api/latest?access_key=\(API_KEY)"
var API_URL_FULL_FORM = "http://data.fixer.io/api/symbols?access_key=\(API_KEY)"
var FULL_FORM = [String : String]()
var count = 0
