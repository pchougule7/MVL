//
//  LocationLocationHistoryViewModel.swift
//  MVLApp
//
//  Created by Prajyot Prakash Chougule on 18/04/26.
//

import Foundation

@Observable
@MainActor
class LocationHistoryViewModel {
    var historyItems: [HistoryItem] = []
    var isFetching: Bool = false
    
    // Properties for the top header
    var totalCount: Int {
        historyItems.count
    }
    
    var totalPrice: Int {
        Int(historyItems.reduce(0) { $0 + $1.price })
    }
    
    private let apiService: APIServiceProtocol = APIServiceManager()
    
    func fetchUsageHistory() {
        isFetching = true
        Task {
            do {
                self.historyItems = try await apiService.fetchHistory(year: 2026, month: 5)
            } catch {
                print("Error fetching history: \(error)")
            }
            isFetching = false
        }
    }
}
