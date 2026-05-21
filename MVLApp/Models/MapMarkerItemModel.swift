//
//  MapMarkerItemModel.swift
//  MVLAppTests
//
//  Created by Prajyot Prakash Chougule on 18/04/26.
//

import Foundation
import CoreLocation

struct MapMarkerItem: Identifiable, Equatable, Codable {
    let id: UUID
    let latitude: Double
    let longitude: Double
    var nickname: String?
    var address: String
    var aqi: Int?
    var label: String?
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(coordinate: CLLocationCoordinate2D, address: String, nickname: String? = nil, aqi: Int? = 0, label: String) {
        self.id = UUID()
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.address = address
        self.nickname = nickname
        self.aqi = aqi
        self.label = label
    }
}
