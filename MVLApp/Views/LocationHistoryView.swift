//
//  LocationHistoryView.swift
//  MVLApp
//
//  Created by Prajyot Prakash Chougule on 18/04/26.
//

import SwiftUI

struct LocationHistoryView: View {
    @State private var viewModel = LocationHistoryViewModel()
    @Binding var isRootPresented: Bool


    let buttonColor = Color(red: 1, green: 196/255, blue: 0)
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HistoryHeaderView(count: viewModel.totalCount, price: viewModel.totalPrice)
            
            // Divider
            Rectangle()
                .fill(Color.gray.opacity(0.1))
                .frame(height: 8)
            
            // List
            List(viewModel.historyItems.indices, id: \.self) { index in
                HistoryRowView(item: viewModel.historyItems[index])
                    .listRowSeparator(
                        viewModel.historyItems.count - 1 == index ? .hidden : .visible,
                        edges: .bottom
                    )
            }
            .listStyle(.plain)
            
        }
        .onAppear {
            viewModel.fetchUsageHistory()
        }
    }
    
    struct HistoryHeaderView: View {
        let count: Int
        let price: Int
        
        var body: some View {
            HStack {
                SummaryColumn(label: "Total Count", value: "\(count)")
                SummaryColumn(label: "Total Price", value: "\(price)")
            }
            .padding(.vertical, 24)
            .background(Color.white)
        }
    }
    
    private struct SummaryColumn: View {
        let label: String
        let value: String
        
        var body: some View {
            VStack(spacing: 8) {
                Text(label)
                    .font(.headline)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    struct HistoryRowView: View {
        let item: HistoryItem
        
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                LocationLabelRow(letter: "A", name: item.a.name)
                LocationLabelRow(letter: "B", name: item.b.name)
            }
            .padding(.vertical, 12)
        }
    }
    
    private struct LocationLabelRow: View {
        let letter: String
        let name: String
        
        var body: some View {
            HStack(spacing: 20) {
                Text(letter)
                    .font(.subheadline.bold())
                    .frame(width: 20)
                Text(name)
                    .font(.subheadline.bold())
            }
        }
    }
    
}

struct LocationHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        LocationHistoryView(isRootPresented: .constant(true))
    }
}
