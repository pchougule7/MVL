//
//  MapView.swift
//  MVLApp
//
//  Created by Prajyot Prakash Chougule on 16/04/26.
//

import Foundation
internal import MapKit
import SwiftUI

struct MapView: View {
    @Bindable var viewModel: ContentViewModel
    
    @StateObject private var locationManager = LocationManager()
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    var body: some View {
        MapReader { proxy in
            ZStack {
                Map(position: $locationManager.position)
                    .onMapCameraChange { context in
                        // Sync map center to ViewModel so "Set A/B" captures the right spot
                        viewModel.region = context.region
                    }
                    .mapControls {
                        MapUserLocationButton()
                        MapCompass()
                    }
                    .edgesIgnoringSafeArea(.all)
                    .onChange(of: locationManager.location?.coordinate.latitude) { _, _ in
                        if let newCoord = locationManager.location?.coordinate {
                            let zoomedRegion = MKCoordinateRegion(
                                center: newCoord,
                                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                            )
                            withAnimation {
                                locationManager.position = .region(zoomedRegion)
                            }
                        }
                    }
                
                Image("icon-pin")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(.bottom, 40)
                    .allowsHitTesting(false)
            }
        }
    }
}
