//
//  ContentViewModel.swift
//  MVLApp
//
//  Created by Prajyot Prakash Chougule on 17/04/26.
//

import Foundation
internal import MapKit

@Observable
@MainActor
class ContentViewModel {
    private let apiService: APIServiceProtocol = APIServiceManager()
    
    init(aqi: Int = 0, markers: [MapMarkerItem] = [], isFetching: Bool = false) {
        self.aqiValue = aqi
        self.markers = markers
        self.isFetching = isFetching
        
        // Update button title based on marker count
        if markers.count == 1 {
            self.vButtonTitle = "Set B"
            self.currentStep = 1
        } else if markers.count >= 2 {
            self.vButtonTitle = "Book"
            self.currentStep = 2
        } else {
            self.vButtonTitle = "Set A"
            self.currentStep = 0
        }
    }
    var aLabelText: String {
        markers.indices.contains(0) ? (markers[0].nickname ?? markers[0].address) : "Location A"
    }
    
    var bLabelText: String {
        markers.indices.contains(1) ? (markers[1].nickname ?? markers[1].address) : "Location B"
    }
    
    // Helper for SecondView Header
    var currentStepLabel: String {
        return currentStep == 1 ? "A" : "B"
    }
    
    var currentAddress: String {
        markers.last?.address ?? "Unknown"
    }
    
    var vButtonTitle: String = "Set A"
    var aqiValue: Int = 0
    var isFetching: Bool = false
    var showNicknameScreen: Bool = false
    var showThirdScreen: Bool = false
    var bookingResult: BookingResponse?
    
    
    // Tracks the current center of the map
    var region = MKCoordinateRegion(center: .init(latitude: 0, longitude: 0), span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    // Storage for the pins dropped at A and B
    var markers: [MapMarkerItem] = []
    
    private var currentStep: Int = 0
    private let aqiToken = APIConfig.aqiToken
    
    func handleVButtonPress() {
        if currentStep == 2 {
            guard markers.count >= 2 else { return }
            isFetching = true
            Task {
                do {
                    bookingResult = try await self.apiService.performBooking(markers: markers)
                    showThirdScreen = true
                    print("Booking Successful: \(bookingResult)")
                    isFetching = false
                    return
                } catch {
                    print("Error: \(error)")
                }
                isFetching = false
            }
            return
        }
        isFetching = false
        let capturedCoordinate = region.center // Save the exact center where user is looking
        Task {
            do {
                async let locTask = apiService.fetchLocation(lat: capturedCoordinate.latitude, lon: capturedCoordinate.longitude)
                async let airTask = apiService.fetchAirQuality(lat: capturedCoordinate.latitude, lon: capturedCoordinate.longitude, token: aqiToken)
                
                let (location, air) = try await (locTask, airTask)
                
                // Add a new marker at the captured coordinate
                updateUI(address: location.displayName, aqi: air.aqi)
            } catch {
                print("Error: \(error)")
            }
            isFetching = false
        }
    }
    
    func resetData() {
        currentStep = 0
        vButtonTitle = "Set A"
        self.markers.removeAll()
    }
    
    private func updateUI(address: String, aqi: Int) {
        let capturedCoordinate = region.center
        self.aqiValue = aqi
        if currentStep == 0 {
            vButtonTitle = "Set B"
            showNicknameScreen = true
            currentStep = 1
        } else if currentStep == 1 {
            vButtonTitle = "Book"
            showNicknameScreen = true
            currentStep = 2
        }
        self.markers.append(MapMarkerItem(coordinate: capturedCoordinate, address: address, aqi: aqi, label: currentStepLabel))
        
    }
    
    @MainActor
    func saveNicknameAndExit(_ name: String) {
        guard !markers.isEmpty else {
            showNicknameScreen = false
            return
        }
        
        let targetIndex = currentStep == 1 ? 0 : 1
        
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedName.isEmpty {
            markers[targetIndex].nickname = nil
        } else {
            markers[targetIndex].nickname = String(trimmedName.prefix(20))
        }
        
        showNicknameScreen = false
    }
}
