//
//  SecondView.swift
//  MVLApp
//
//  Created by Prajyot Prakash Chougule on 17/04/26.
//

import Foundation
import SwiftUI

struct SecondView: View {
    @Bindable var viewModel: ContentViewModel
    @State private var nicknameInput: String = ""
    
    let buttonColor = Color(red: 1, green: 196/255, blue: 0)
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            LocationHeaderView(
                stepLabel: viewModel.currentStepLabel,
                address: viewModel.currentAddress,
                aqi: viewModel.aqiValue
            )
            
            Spacer()
            
            // NickNameInputVIew
            NicknameInputField(text: $nicknameInput)
            
            // Confirm Button
            ConfirmButton(color: buttonColor) {
                viewModel.saveNicknameAndExit(nicknameInput)
            }
        }
    }
    
    struct LocationHeaderView: View {
        let stepLabel: String
        let address: String
        let aqi: Int
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top, spacing: 20) {
                    Text(stepLabel)
                        .font(.system(size: 28, weight: .bold))
                    
                    Text(address)
                        .font(.system(size: 28, weight: .bold))
                        .lineLimit(2)
                }
                
                HStack {
                    Text("aqi")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(aqi)")
                        .fontWeight(.bold)
                }
                .padding(.leading, 38)
            }
            .padding(.top, 40)
            .padding(.horizontal, 24)
        }
    }
    
    struct NicknameInputField: View {
        @Binding var text: String
        
        var body: some View {
            TextField("nickname", text: $text)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2)))
                .padding(.horizontal, 24)
                .onChange(of: text) { _, newValue in
                    if newValue.count > 20 {
                        text = String(newValue.prefix(20))
                    }
                }
                .padding(.bottom, 8)
        }
    }
    
    struct ConfirmButton: View {
        let color: Color
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Text("v")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(color)
                    .foregroundColor(.black)
                    .cornerRadius(12)
            }
            .padding(24)
        }
    }
}
struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        SecondView(viewModel: .init())
    }
}
