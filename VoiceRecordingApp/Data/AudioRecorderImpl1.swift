//
//  AudioRecorderImpl1.swift
//  VoiceRecordingApp
//
//  Created by Ihor Zabrotsky on 22.11.2025.
//

import Foundation
import AVFoundation

enum AudioRecorderError: Error {
    case recordingFailed
}

// This is implementation of AVAudioRecorder
class AudioRecorderImpl1: AudioRecorder {
    static let shared = AudioRecorderImpl1() // TODO: shouldn't be Singleton. Must be correctly injected into Use Cases in future
    
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer? // TODO: remove from here
    var fileUrl: URL?
    private var isPaused: Bool = false
    private var audioRecordingID: UUID?
    
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
                        await MainActor.run {
                            do {
                                try self.startRecord() // TODO: how to rethrow?
                            } catch {
                                print("❌❌❌ Record start failed: \(error)")
                            }
                        }
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
    
    func stopRecording() throws -> Recording {
        // Duration can be correctly obtained only before AVAudioRecorder().stop()
        guard let duration = audioRecorder?.currentTime,
              let id = audioRecordingID else {
            audioRecorder?.stop()
            throw AudioRecorderError.recordingFailed
        }
               
        audioRecorder?.stop()
        audioRecorder = nil
        audioRecordingID = nil
        
        print("⚠️⚠️⚠️ Record duration: \(duration)")
        
        guard let url = fileUrl else {
            print("❌❌❌ Audio file url is nil.")
            throw AudioRecorderError.recordingFailed
        }

        print("⚠️⚠️⚠️ Recorded URL: \(url.absoluteString)")
        
        // TODO: Playing here for testing. Will be removed
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("❌❌❌ Player creation failed: \(error)")
        }
        
        return Recording(id: id, title: id.uuidString, duration: duration, date: Date())
    }
    
    // MARK: - Private
    
    private func startRecord() throws {
        guard !isPaused else {
            audioRecorder?.record()
            isPaused = false;
            return
        }
        
        let uuid = UUID()
        audioRecordingID = uuid
        // TODO: good to have some enum for audio file's type (MP3, M4A, WAV)
        let fileName = uuid.uuidString + "m4a"
        // TODO: FileManager shouldn't be here.
        // It would be better to just give away the audio file and Repository itself should manager FileManager or whatever else
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

