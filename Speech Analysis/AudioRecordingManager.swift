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
        let recordingSettings = [AVFormatIDKey: kAudioFormatAppleLossless,
                                 AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
                                 AVEncoderBitRateKey: 256000,
                                 AVNumberOfChannelsKey: 2,
                                 AVSampleRateKey: 44100.0 ] as [String : Any]
    
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
    static func getCacheDirectory() -> String {
        // Paths for where audio files are held represented as an array of strings
        // Will change to dropbox later
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                        FileManager.SearchPathDomainMask.userDomainMask,
                                                        true)
    
        // Return first path
        return paths[0]
    }

    /*
     Function to convert path to recording to a URL with file type as specified by self.audioFileName
     */
    static func getURL(fileName: String) -> URL {
        let path = getCacheDirectory().appending(fileName)
        let filePath = URL(fileURLWithPath: path)
        return filePath
    }
}
