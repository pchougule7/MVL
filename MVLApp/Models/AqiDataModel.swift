//
//  AqiDataModel.swift
//  MVLApp
//
//  Created by Prajyot Prakash Chougule on 18/04/26.
//

import Foundation
// Maps the top-level API response
struct AQIResponse: Codable {
    let status: String
    let data: AQIData
}

// Maps the inner data object
struct AQIData: Codable {
    let aqi: Int
    let idx: Int
    let city: AQICity
    let dominentpol: String
}

// Maps city details
struct AQICity: Codable {
    let name: String
    let geo: [Double] // [Latitude, Longitude]
}
