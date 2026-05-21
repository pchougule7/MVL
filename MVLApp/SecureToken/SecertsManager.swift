//
//  SecertsManager.swift
//  MVLApp
//
//  Created by Prajyot Prakash Chougule on 18/04/26.
//

import Foundation
enum APIConfig {
    static var aqiToken: String {
        guard let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath),
              let value = plist.object(forKey: "AQI_TOKEN") as? String else {
            fatalError("Secrets.plist or AQI_TOKEN not found!")
        }
        return value
    }
}
