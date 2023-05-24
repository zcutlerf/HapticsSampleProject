//
//  HapticsService.swift
//  HapticsSampleProject
//
//  Created by Zoe Cutler on 5/24/23.
//

import CoreHaptics

/// Class to handle initialization of haptics engine and playing various haptics. Methods can be accessed via the singleton HapticsService.shared, which is optional and will be `nil` if the engine fails to start or the hardware does not support haptics.
class HapticService {
    /// The shared instance of HapticService. Singleton pattern.
    static var shared: HapticService? = HapticService()
    
    private var engine: CHHapticEngine?
    
    /// A failable initializer that returns a HapticService or nil if the engine fails to start or the hardware does not support haptics.
    private init?() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return nil }
        
        do {
            try startEngine()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
            return nil
        }
    }
    
    func refresh() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            try startEngine()
        } catch {
            print("There was an error restarting the engine: \(error.localizedDescription)")
        }
    }
    
    private func startEngine() throws {
        engine = try CHHapticEngine()
        try engine?.start()
        
        engine?.resetHandler = {
            try? self.engine?.start()
        }
    }
    
    /// Play a haptic composed of one transient event.
    func simpleHaptic() {
        var events = [CHHapticEvent]()
        
        // create one intense, sharp tap
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)
        
        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play Switch Row haptic pattern: \(error.localizedDescription).")
        }
    }
    
    /// Play a haptic composed of multiple transient events.
    func multiHaptic() {
        var events = [CHHapticEvent]()
        
        let intensity1 = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.6)
        let sharpness1 = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
        let event1 = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity1, sharpness1], relativeTime: 0)
        events.append(event1)
        
        let intensity2 = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8)
        let sharpness2 = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
        let event2 = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity2, sharpness2], relativeTime: 0.10)
        events.append(event2)
        
        let intensity3 = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let sharpness3 = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
        let event3 = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity3, sharpness3], relativeTime: 0.24)
        events.append(event3)
        
        let intensity4 = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let sharpness4 = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.2)
        let event4 = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity4, sharpness4], relativeTime: 0.25)
        events.append(event4)
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play Word Success haptic pattern: \(error.localizedDescription).")
        }
    }
    
    /// Play a haptic composed of multiple transient events and continuous events.
    func transientAndContinuous() {
        let short1 = CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 0)
        let short2 = CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 0.2)
        let short3 = CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 0.4)
        let long1 = CHHapticEvent(eventType: .hapticContinuous, parameters: [], relativeTime: 0.6, duration: 0.5)
        let long2 = CHHapticEvent(eventType: .hapticContinuous, parameters: [], relativeTime: 1.2, duration: 0.5)
        let long3 = CHHapticEvent(eventType: .hapticContinuous, parameters: [], relativeTime: 1.8, duration: 0.5)
        let short4 = CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 2.4)
        let short5 = CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 2.6)
        let short6 = CHHapticEvent(eventType: .hapticTransient, parameters: [], relativeTime: 2.8)
        
        do {
            let pattern = try CHHapticPattern(events: [short1, short2, short3, long1, long2, long3, short4, short5, short6], parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
}
