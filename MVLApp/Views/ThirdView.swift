//
//  ThirdView.swift
//  MVLApp
//
//  Created by Prajyot Prakash Chougule on 18/04/26.
//

import Foundation
import SwiftUI

struct ThirdView: View {
    let viewModel: ContentViewModel
    let buttonColor = Color(red: 255/255, green: 196/255, blue: 0/255)
    @State private var navigateToForthScreen = false
    

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Marker List
                        ForEach(viewModel.markers.indices, id: \.self) { index in
                            MarkerSummaryRow(
                                marker: viewModel.markers[index],
                                isLast: index == viewModel.markers.count - 1
                            )
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
                // Price Section
                PriceSummaryRow(price: viewModel.bookingResult?.price)
                
                // Confirm/History Button
                Button(action: {
                    viewModel.resetData()
                    navigateToForthScreen = true
                }) {
                    Text("v")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(buttonColor)
                        .foregroundColor(.black)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            .navigationDestination(isPresented: $navigateToForthScreen) {
                LocationHistoryView(isRootPresented: $navigateToForthScreen)
            }
        }
    }
    
    struct MarkerSummaryRow: View {
        let marker: MapMarkerItem
        let isLast: Bool
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 20) {
                    Text(marker.label ?? "p")
                        .font(.headline)
                    Text(marker.address)
                        .font(.headline)
                    Spacer()
                }
                
                // AQI Row
                HStack(spacing: 50) {
                    Text("aqi")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(width: 100, alignment: .leading)
                    if let aqi = marker.aqi {
                        Text("\(aqi)")
                            .font(.subheadline.bold())
                    }
                    Spacer()
                }
                .padding(.leading, 30)
                
                // Nickname Row (Conditional)
                if let nickname = marker.nickname {
                    HStack(spacing: 50) {
                        Text("nickname")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .frame(width: 100, alignment: .leading)
                        Text(nickname)
                            .font(.subheadline.bold())
                        Spacer()
                    }
                    .padding(.leading, 30)
                }
                
                if !isLast {
                    Divider()
                        .padding(.vertical, 8)
                }
            }
        }
    }
    
    struct PriceSummaryRow: View {
        let price: Double?
        
        var body: some View {
            HStack {
                Text("price")
                    .font(.subheadline.bold())
                    .foregroundColor(.secondary)
                Spacer()
                if let price = price {
                    Text("\(Int(price))")
                        .font(.title3.bold())
                }
            }
            .padding()
        }
    }
}

struct ThirdView_Previews: PreviewProvider {
    static var previews: some View {
        ThirdView(viewModel: .init() )
    }
}
