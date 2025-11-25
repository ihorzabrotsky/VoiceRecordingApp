//
//  AudioPlayerImpl.swift
//  VoiceRecordingApp
//
//  Created by Ihor Zabrotsky on 23.11.2025.
//

import Foundation
import AVFoundation

// TODO: Don't forget to handle pausing correctly
final class AudioPlayerImpl: NSObject, AudioPlayer, AVAudioPlayerDelegate {
    
    private var player: AVAudioPlayer?
    private var isPlaying: Bool = false // or isPaused?
    
    static let shared = AudioPlayerImpl() // TODO: This shouldn't be Singleton. Need proper DI. Left for now.
    var activeRecordingUrl: URL?
    
    // MARK: - AudioPlayer
    
    // Formally, this method should also throw. Left for now
    func playRecord() {
        guard let url = activeRecordingUrl else {
            print("❌❌❌ No active Recording found.")
            return
        }
        
        print("⚠️⚠️⚠️ \(Self.self) Active recording URL: \(url.absoluteString)")
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            guard let duration = player?.duration else {
                print("❌❌❌ \(Self.self) Duration is nil.")
                return
            }
            print("⚠️⚠️⚠️ Audio file's duration: \(duration)")
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
    
    func setActiveRecordingURL(_ url: URL) {
        activeRecordingUrl = url
    }
    
    // MARK: - AVAudioPlayerDelegate
    
    // AVAudioPlayer did finish playing
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
    }
}
