//
//  OnboardingView.swift
//  PuffLess
//
//  Created by Mertcan Kırcı on 26.09.2024.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboardingCompleted: Bool
    @State private var dailyGoal: Int = 10
    @EnvironmentObject var viewModel: PersistanceViewModel
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Rectangle()
                    .fill(.orange)
                    .cornerRadius(8)
                    .frame(width: 150, height: 150)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                    .padding(.bottom, 250)
                    .padding(.leading, 32)
                    
                    
                GeometryReader { geometry in
                    Path { path in
                        let width = geometry.size.width
                        path.move(to: CGPoint(x: width, y: 0))
                        path.addLine(to: CGPoint(x: width - 250, y: 0))
                        path.addLine(to: CGPoint(x: width, y: 250)) 
                        path.closeSubpath()
                    }
                    .fill(Color.pink)
                    .frame(width: 250, height: 250)
                    .padding(.trailing, 128)
                }
                .frame(height: 250)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            }
            .opacity(0.5)
            .blur(radius: 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            
            Circle()
                .fill(.pink)
                .frame(width: 300, height: 300)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(.bottom, 90)
                .opacity(0.5)
                .blur(radius: 20)
                
            
            VStack {
                Text("Welcome to PuffLess")
                    .font(.system(size: 28, weight: .bold))
                    .padding()
                
                Text("Track your smoking habits and reduce consumption over time.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("Set Your Daily Goal")
                    .font(.system(size: 22, weight: .semibold))
                    .padding(.top, 20)
                
                VStack {
                    TextField("Cigarette amount", value: $dailyGoal, format: .number)
                        .font(.system(size: 22, weight: .medium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                        .keyboardType(.numberPad)
                        .focused($isInputFocused)
                        .padding(.horizontal, 32)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 32)
                }
                .padding(.bottom, 20)
                
                Spacer()
                
                Button(action: {
                    viewModel.saveDailyGoals(dailyGoal: dailyGoal)
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isOnboardingCompleted = true
                    }
                }) {
                    Text("Get Started")
                        .font(.system(size: 18, weight: .bold))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 32)
                }
                .padding(.bottom, 40)
            }
        }
        .tint(.pink)
        .contentShape(Rectangle())
        .onTapGesture {
            isInputFocused = false
        }
    }
}

#Preview {
    OnboardingView(isOnboardingCompleted: .constant(false))
        .environmentObject(PersistanceViewModel())
}

