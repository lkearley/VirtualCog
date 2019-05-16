//
//  AudioRecordingManager.swift
//  Speech Analysis
//
//  Created by Lauren Kearley on 5/10/19.
//  Copyright © 2019 btap. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit


class AudioRecordingManager {
    /*
     Function to set up recording session
     */
    static func setUpRecorder(view: AVAudioRecorderDelegate, fileName: String) ->  AVAudioRecorder? {
        // Record settings
        var recorder : AVAudioRecorder?
        let recordingSettings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
    
        do {
            recorder = try AVAudioRecorder(url: getURL(fileName: fileName),
                                           settings: (recordingSettings as [String: Any]))
        } catch {
            print("Could not initialize sound recorder")
        }
    
        // Prepare recorder to record
        recorder?.delegate = view
    
        // Enable metering
        recorder?.isMeteringEnabled = true
        recorder?.prepareToRecord()
        return recorder
    }

    /*
     Function to grab the path to the audio recording
     */
    static func getDocumentsDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return path
    }

    /*
     Function to convert path to recording to a URL with file type as specified by audioFileName
     */
    static func getURL(fileName: String) -> URL {
        let path = getDocumentsDirectory().appendingPathComponent(fileName)
        return path
    }
}
