//
//  AudioRecorderImpl1.swift
//  VoiceRecordingApp
//
//  Created by Ihor Zabrotsky on 22.11.2025.
//

import Foundation
import AVFoundation

// This is implementation of AVAudioRecorder
class AudioRecorderImpl1: AudioRecorder {
    
    static let shared = AudioRecorderImpl1() // TODO: shouldn't be Singleton. Must be correctly injected into Use Cases in future
    
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer? // TODO: remove from here
    private var fileUrl: URL?
    private var isPaused: Bool = false
    
    func startRecording() throws {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        switch status {
        case .authorized:
            print("✅✅✅ Permission granted. Record starting...")
            try startRecord()
            
        case .denied, .restricted:
            print("❌❌❌ Access denied. Please, grant access in settings")
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .audio) { [weak self] success in
                guard let self = self else { return }
                if success {
                    print("✅✅✅ Permission granted. Record starting...")
                    Task {
                        // We're in a scope of closure that's run on background so we need to start recording on main thread - demand of AVAudioRecorder
                        await MainActor.run(body: {
                            do {
                                try self.startRecord() // TODO: how to rethrow?
                            } catch {
                                print("❌❌❌ Record start failed: \(error)")
                            }
                        })
                    }
                } else {
                    print("❌❌❌ Access denied. Please, grant access in settings")
                }
            }
            
        @unknown default:
            break
        }
    }
    
    func pauseRecording() {
        audioRecorder?.pause()
        isPaused = true
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil

        guard let url = fileUrl else {
            print("❌❌❌ Audio file url is nil.")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("❌❌❌ Player creation failed: \(error)")
        }
    }
    
    // MARK: - Private
    
    private func startRecord() throws {
        guard !isPaused else {
            audioRecorder?.record()
            isPaused = false;
            return
        }
        
        let fileName = UUID().uuidString + "m4a"
        let fileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
        self.fileUrl = fileUrl

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileUrl, settings: settings)
            audioRecorder?.prepareToRecord()
            audioRecorder?.record()
            print("✅✅✅ Recording started...")
        } catch {
            print("❌❌❌ Audio Recorder couldn't initialize: \(error)")
        }
    }
    
}

