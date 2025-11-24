//
//  AudioPlayerImpl.swift
//  VoiceRecordingApp
//
//  Created by Ihor Zabrotsky on 23.11.2025.
//

import Foundation
import AVFoundation

// TODO: Don't forget to handle pausing correctly
final class AudioPlayerImpl: AudioPlayer {
    
    static let shared = AudioPlayerImpl() // TODO: This shuldn't be Singleton. Need proper DI. Left for now.
    private var player: AVAudioPlayer?
    private var isPlaying: Bool = false // or isPaused?
    
    // Formally, this method should also throw. Left for now
    func playRecord(by url: URL) {
        do {
            player? = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("❌❌❌ Player creation failed: \(error)")
        }
    }
    
    // we can use isPlaying and currentTime to properly handle
    // Play/Pause functionality
    func pausePlaying() {
        player?.pause()
    }
    
    func stopPlaying() {
        player?.stop()
        player = nil
    }
}
