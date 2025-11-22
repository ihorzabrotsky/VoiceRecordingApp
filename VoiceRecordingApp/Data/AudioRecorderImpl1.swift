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
    
    private var audioRecorder: AVAudioRecorder?
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
                    do {
                        try self.startRecord() // TODO: how to rethrow?
                    } catch {
                        print("❌❌❌ Record start failed: \(error)")
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
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44_100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        audioRecorder = try AVAudioRecorder(url: fileUrl, settings: settings)
        audioRecorder?.prepareToRecord()
        audioRecorder?.record()
    }
    
}

