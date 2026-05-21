//
//  APIServiceManager.swift
//  MVLApp
//
//  Created by Prajyot Prakash Chougule on 17/04/26.
//

import Alamofire
import CoreLocation
import Foundation
import WeatherKit

internal import Combine
internal import MapKit

protocol APIServiceProtocol {
    func fetchLocation(lat: Double, lon: Double) async throws -> LocationData
    func fetchAirQuality(lat: Double, lon: Double, token: String) async throws -> AQIData
    func performBooking(markers: [MapMarkerItem]) async throws -> BookingResponse
    func fetchHistory(year: Int, month: Int) async throws -> [HistoryItem]
}

// Example implementation

enum AQIError: Error {
    case invalidURL
    case invalidResponse
    case requestFailed
}

@MainActor
class APIServiceManager: APIServiceProtocol {
    private let weatherService = WeatherService.shared
    @Published var aqiScale: String = "--"
    @Published var aqiCategory: String = "Loading..."
    @Published var isLoading: Bool = false
    
    
    func fetchAirQuality(lat latitude: Double, lon longitude: Double, token: String) async throws -> AQIData {
        // Fix: Added 'api.', '/feed/geo', and removed the stray colon after info
        let urlString = "https://api.waqi.info/feed/here/?token=\(token)"
        
        guard let url = URL(string: urlString) else {
            throw AQIError.invalidURL
        }
        
        // Perform the network request
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Verify the HTTP response status code is 200 (OK)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw AQIError.invalidResponse
        }
        
        // Decode the JSON data into our Swift models
        let decodedResponse = try JSONDecoder().decode(AQIResponse.self, from: data)
        
        // Ensure the API itself returned an "ok" status
        guard decodedResponse.status == "ok" else {
            throw AQIError.requestFailed
        }
        
        return decodedResponse.data
        
    }
    
    func fetchLocation(lat: Double, lon: Double) async throws -> LocationData {
        return await fetchLocationName(latitude: lat, longitude: lon)
    }
    
    func fetchLocationName(latitude: Double, longitude: Double) async -> LocationData {
        // 1. Convert coordinate to a CLLocation object
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        guard let request = MKReverseGeocodingRequest(location: location) else {
            return LocationData(city: "Mock City", locality: "Fake Neighborhood")
        }
        
        do {
            let mapItems = try await request.mapItems
            
            if let firstItem = mapItems.first {
                // 1. Get the direct place name/POI (e.g., "Apple Park")
                let placeName = firstItem.name ?? ""
                
                // 2. Use addressRepresentations for the city/locality context
                let city = firstItem.addressRepresentations?.cityWithContext(.automatic) ?? ""
                
                // FIX: Return directly to the main function scope. No MainActor closure needed.
                if city.isEmpty {
                    return LocationData(city: "Unknown City", locality: placeName)
                } else {
                    return LocationData(city: city, locality: placeName)
                }
            }
            
            // Hits this if mapItems array was completely empty
            return LocationData(city: "Unknown City", locality: "Unknown Locality")
            
        } catch {
            print("MapKit Geocoding failed: \(error.localizedDescription)")
            return LocationData(city: "Error City", locality: "Error Locality")
        }
    }
    
    func performBooking(markers: [MapMarkerItem]) async throws -> BookingResponse {
        let locationA = markers[0]
        let locationB = markers[1]
        
        // 1. Prepare Request Data
        let parameters: [String: Any] = [
            "locationA": ["address": locationA.address, "lat": locationA.coordinate.latitude],
            "locationB": ["address": locationB.address, "lat": locationB.coordinate.latitude]
        ]
        let newHistoryItem = HistoryItem(
            a: HistoryItem.LocationDetail(latitude: locationA.coordinate.latitude, longitude: locationA.coordinate.longitude, aqi: locationA.aqi ?? 0 ,name: locationA.nickname ?? locationA.address, date:  Date()),
            b: HistoryItem.LocationDetail(latitude: locationB.coordinate.latitude, longitude: locationB.coordinate.longitude, aqi: locationB.aqi ?? 0 ,name: locationB.nickname ?? locationB.address, date:  Date()),
            price: 2000,
            date: Date() // Captures current system timestamp
        )
        HistoryCacheManager.shared.appendNewBooking(item: newHistoryItem)
        
        let request = BookingRequest(locationA: markers[0], locationB: markers[1])
        
        //        let results =  try await AF.request("https://dummy.com",
        //                                                      method: .post,
        //                                                      parameters: parameters,
        //                                                      encoding: JSONEncoding.default)
        //                        .serializingDecodable(BookingResponse.self)
        //                        .value
        //
        //dummy results:
        try await Task.sleep(nanoseconds: 100_000_000)
        return BookingResponse(id: "1", locationA: markers[0], locationB: markers[1], price: 1000)
        
    }
    
    func fetchHistory(year: Int, month: Int) async throws -> [HistoryItem] {
        
        if let cachedItems = HistoryCacheManager.shared.load(forYear: year, month: month) {
            return cachedItems
        }
        
        let baseUrl: String = "https://dummy.com" //as per server 
        let url = "/books?year=2026&month=5."
        
        let parameters: [String: Any] = [
            "year": year,
            "month": month
        ]
        
        return try await AF.request(url, method: .get, parameters: parameters)
            .serializingDecodable([HistoryItem].self)
            .value
    }
    
}
