//
//  ContentView.swift
//  MVLApp
//
//  Created by Prajyot Prakash Chougule on 16/04/26.
//

import SwiftUI
internal import MapKit

struct ContentView: View {
    @State private var viewModel = ContentViewModel()
    let buttonColor = Color(red: 1, green: 196/255, blue: 0)
    let lightBgColor = Color(red: 242/255, green: 245/255, blue: 247/255)
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                // Background Map
                MapView(viewModel: viewModel)
                    .edgesIgnoringSafeArea(.bottom)
                
                // AQI Overlay (Only redraws when aqiValue changes)
                AQIOverlay(aqiValue: viewModel.aqiValue)
                
                VStack {
                    Spacer()
                    
                    // Bottom Control Panel
                    HStack(spacing: 16) {
                        LocationLabelsView(
                            aLabel: viewModel.aLabelText,
                            bLabel: viewModel.bLabelText,
                            bgColor: lightBgColor
                        )
                        .containerRelativeFrame(.horizontal) { size, axis in
                                size * 0.6
                            }
                        
                        ActionButton(
                            title: viewModel.vButtonTitle,
                            isFetching: viewModel.isFetching,
                            color: buttonColor,
                            action: viewModel.handleVButtonPress
                        )
                    }
                    .padding(18)
                    .frame(height: 160)
                    .background(Color.white)
                }
            }
            .fullScreenCover(isPresented: $viewModel.showNicknameScreen) {
                SecondView(viewModel: viewModel)
            }
            .navigationDestination(isPresented: $viewModel.showThirdScreen) {
                if viewModel.bookingResult != nil {
                    ThirdView(viewModel: viewModel)
                }
            }
        }
    }
    
    struct AQIOverlay: View {
        let aqiValue: Int
        
        var body: some View {
            HStack {
                Spacer()
                Text("aqi: \(aqiValue)")
                    .padding(.top, -36)
                    .padding(.horizontal, 16)
            }
            .background(Color.white)
        }
    }
    
    struct LocationLabelsView: View {
        let aLabel: String
        let bLabel: String
        let bgColor: Color
        
        var body: some View {
            VStack {
                Text(aLabel)
                    .font(.caption2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(bgColor)
                    .foregroundStyle(.black)
                    .cornerRadius(8)
                Text(bLabel)
                    .font(.caption2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(bgColor)
                    .foregroundStyle(.black)
                    .cornerRadius(8)
            }
        }
    }

    struct ActionButton: View {
        let title: String
        let isFetching: Bool
        let color: Color
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                if isFetching {
                    ProgressView().tint(.black)
                } else {
                    Text(title)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundStyle(.black)
            .background(color)
            .cornerRadius(8)
        }
    }
}
