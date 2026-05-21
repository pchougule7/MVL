//
//  HistoryCacheManager.swift
//  MVLApp
//
//  Created by Prajyot Prakash Chougule on 21/05/26.
//

import Foundation

class HistoryCacheManager {
    static let shared = HistoryCacheManager()
    private init() {}
    
    private func cacheKey(year: Int, month: Int) -> String {
        return "cached_history_\(year)_\(month)"
    }
    
    // Appends a single new booking into the existing monthly cache matrix
    func appendNewBooking(item: HistoryItem) {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: item.date)
        let month = calendar.component(.month, from: item.date)
        
        // 1. Get current month's array
        if var currentHistory = load(forYear: year, month: month) {
            currentHistory.insert(item, at: 0)
            let key = cacheKey(year: year, month: month)
            if let encoded = try? JSONEncoder().encode(currentHistory) {
                UserDefaults.standard.set(encoded, forKey: key)
            }
        } else {
            let currentHistory : [HistoryItem]? = [item]
            let key = cacheKey(year: year, month: month)
            if let encoded = try? JSONEncoder().encode(currentHistory) {
                UserDefaults.standard.set(encoded, forKey: key)
            }
        }
    }
    
    // Retrieve items from disk
    func load(forYear year: Int, month: Int) -> [HistoryItem]? {
        let key = cacheKey(year: year, month: month)
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode([HistoryItem].self, from: data)
    }
}
