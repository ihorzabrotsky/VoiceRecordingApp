//
//  AudioPlayerImpl.swift
//  VoiceRecordingApp
//
//  Created by Ihor Zabrotsky on 23.11.2025.
//

import Foundation
import AVFoundation

final class AudioPlayerImpl: NSObject, AudioPlayer {
    private var player: AVAudioPlayer?
    private var isPaused: Bool = false
    fileprivate var onStopCompletion: OnStopCompletion?
    
    static let shared = AudioPlayerImpl() // TODO: This shouldn't be Singleton. Need proper DI. Left for now.
    var activeRecordingUrl: URL?
    
    private var timer: Timer?
    private let timeInterval: TimeInterval = 0.01
    
    private var onDurationUpdateCompletion: DurationUpdater?
    
    // MARK: - AudioPlayer
    
    // TODO: Formally, this method should also throw. Left for now
    // TODO: AVAudioPlayer.play() method returns Bool for success so it would be good to refactor appropriately.
    func playRecord(_ onStopCompletion: @escaping OnStopCompletion, _ onDurationUpdateCompletion: @escaping DurationUpdater) {
        guard !isPaused else {
            isPaused = false
            player?.play()
            return
        }
        
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
            self.onStopCompletion = onStopCompletion
            player?.prepareToPlay()
            self.onDurationUpdateCompletion = onDurationUpdateCompletion
            timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { [weak self] timer in
                guard let self = self,
                      let duration = self.player?.currentTime else { return }
                self.onDurationUpdateCompletion?(duration)
            })
            
            player?.play()
        } catch {
            print("❌❌❌ Player creation failed: \(error)")
        }
    }
    
    // we can use isPlaying and currentTime to properly handle
    // Play/Pause functionality
    func pausePlaying() {
        player?.pause()
        isPaused = true
    }
    
    func stopPlaying() {
        isPaused = false
        player?.stop()
        player = nil
        onStopCompletion?(true)
        onStopCompletion = nil
        onDurationUpdateCompletion = nil
    }
    
    func setActiveRecordingURL(_ url: URL) {
        activeRecordingUrl = url
    }
}

// MARK: - AVAudioPlayerDelegate

extension AudioPlayerImpl: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // ping UI that player finished playing
        print("✅✅✅ AVAudioPlayer finished playing successfully.")
        onStopCompletion?(flag)
        onStopCompletion = nil
        onDurationUpdateCompletion = nil
    }
}
