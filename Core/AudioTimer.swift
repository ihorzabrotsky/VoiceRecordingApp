//
//  AudioTimer.swift
//  VoiceRecordingApp
//
//  Created by Ihor Zabrotsky on 25.11.2025.
//

import Foundation
import Combine

// Need timer for both recording and playing.
final class AudioTimer: ObservableObject {
    private let minTimeInterval: TimeInterval = 0.1
    
    private var timer: Timer?
    private var startDate: Date?
    
    @Published var duration: TimeInterval = 0
    
    func start() {
        startDate = Date()
        timer = Timer.scheduledTimer(withTimeInterval: minTimeInterval, repeats: true, block: { [weak self] timer in
            guard let self = self else { return }
            self.duration += self.minTimeInterval
        })
    }
    
    // what happens when we pause this? We need to pause the Timer but Timer itself can't pause in macOS and iOS so
    // this means we need to simulate
    func pause() {
        
    }
    
    // when this timer stops we need to delay it a bit on a screen - 2 alternatives here:
    // 1. we delay the disappearance of the Timer View for 1 second on UI side
    // 2. we post duration as the same value for 1 second and after that invalidate
    // Let's go without this functionality for now.
    func stop() {
        timer?.invalidate()
        timer = nil
        
    }
    
}
