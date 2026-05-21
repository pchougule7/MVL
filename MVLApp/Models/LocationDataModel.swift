//
//  LocationDataModel.swift
//  MVLApp
//
//  Created by Prajyot Prakash Chougule on 17/04/26.
//

import Foundation

nonisolated struct LocationData: Codable, Sendable {
    let city: String
    let locality: String
    
    var displayName: String {
        city.isEmpty ?  locality : "\(locality),\(city)"
    }
}



