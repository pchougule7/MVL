//
//  BookingDataModels.swift
//  MVLApp
//
//  Created by Prajyot Prakash Chougule on 18/04/26.
//

import Foundation
struct BookingRequest: Codable {
    let locationA: MapMarkerItem
    let locationB: MapMarkerItem
}

nonisolated struct BookingResponse: Codable {
    let id: String
    let locationA: MapMarkerItem
    let locationB: MapMarkerItem
    let price: Double
}
