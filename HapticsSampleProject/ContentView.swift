//
//  ContentView.swift
//  HapticsSampleProject
//
//  Created by Zoe Cutler on 5/24/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        VStack {
            Button {
                HapticService.shared?.simpleHaptic()
            } label: {
                Text("Simple Haptic")
            }
            
            Button {
                HapticService.shared?.multiHaptic()
            } label: {
                Text("Multi-Event Haptic")
            }
            
            Button {
                HapticService.shared?.transientAndContinuous()
            } label: {
                Text("Haptic with Transient and Continuous Events")
            }
        }
        .buttonStyle(.bordered)
        .padding()
        .onChange(of: scenePhase) { newValue in
            // When the app comes back into the foreground, restart the haptics engine so they will continue to play.
            if newValue == .active {
                HapticService.shared?.refresh()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
