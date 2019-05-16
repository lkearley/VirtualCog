//
//  DelayFaceRecallViewController.swift
//  Speech Analysis
//
//  Created by Lauren Kearley on 4/27/19.
//  Copyright © 2019 btap. All rights reserved.
//

import UIKit
import AVFoundation
import BoxContentSDK

class DelayFaceRecallViewController: UIViewController, AVAudioRecorderDelegate {
    
    //MARK: Variables
    let imageArray : [(name: String, image: UIImage)] = [("Kim",#imageLiteral(resourceName: "Kim")), ("Nancy", #imageLiteral(resourceName: "Nancy")), ("Ralph", #imageLiteral(resourceName: "Ralph")),
                                                         ("George", #imageLiteral(resourceName: "George")), ("Diane", #imageLiteral(resourceName: "Diane")), ("Andrew", #imageLiteral(resourceName: "Andrew")),
                                                         ("Bill", #imageLiteral(resourceName: "Bill")), ("Joan", #imageLiteral(resourceName: "Joan")), ("Sarah", #imageLiteral(resourceName: "Sarah")),
                                                         ("Henry", #imageLiteral(resourceName: "Henry")), ("Fred", #imageLiteral(resourceName: "Fred")), ("Elizabeth", #imageLiteral(resourceName: "Elizabeth"))]
    
    var currImage = 0
    weak var timer: Timer?
    
    //Audio Recorder
    var recorder: AVAudioRecorder!
    
    //File setup
    var audioFileName = AppDelegate.shared().patientID + "_DelayFaceNaming.m4a"

    //MARK: Outlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var faceImage: UIImageView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var recordImage: UIImageView!
    
    
    override func viewDidLoad() {
        initializeTest()
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        recordImage.removePulse()
        if recorder != nil && recorder.isRecording {
            recorder.stop()
            recorder = nil
        }
        faceImage.image = nil
        resetTest()
    }
    
    //MARK: Actions
    @IBAction func startSession(_ sender: Any) {
        setUIForTesting()
        recordImage.pulse()
        faceImage.image = imageArray[currImage].image
        startTestTimer()
    }
    
    @IBAction func nextFace(_ sender: Any) {
        performSegue(withIdentifier: "returnToMenu", sender: self)
    }
    
    //MARK: Functions
    func startTestTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [self] _ in
            self.testing()
        }
    }
    
    func testing() {
        if currImage == self.imageArray.count - 1 {
            endRecording()
            recordImage.removePulse()
            setUIForPostTesting()
        }
        if currImage < self.imageArray.count - 1 {
            currImage += 1
            faceImage.image = imageArray[currImage].image
            startTestTimer()
        }
    }
    
    /*
     Function to stop face showing timer
     */
    func stopTimer() {
        timer?.invalidate()
    }
    
    /*
     Function to end a recording session
     */
    func endRecording() {
        recorder.stop()
        faceImage.image = nil
        FileUploadManager.fileUpload(filePath: AudioRecordingManager.getURL(fileName: audioFileName).absoluteString,
                                     filename: audioFileName,
                                     view: self)
    }
    
    func resetTest() {
        finishButton.isHidden = true
        recordButton.isEnabled = true
        recordButton.isHidden = false
        self.recordButton.setTitle("Begin Session", for: .normal)
        currImage = 0
        audioFileName = AppDelegate.shared().patientID + "_DelayFaceNaming.m4a"
        recorder = AudioRecordingManager.setUpRecorder(view: self, fileName: audioFileName)
    }
    
    func initializeTest() {
        recordImage.isHidden = true
        finishButton.isHidden = true
        recorder = AudioRecordingManager.setUpRecorder(view: self, fileName: audioFileName)
    }
    
    func setUIForTesting() {
        recordButton.isHidden = true
        recordButton.isEnabled = false
        finishButton.setTitle("Recording...", for: .normal)
        finishButton.isEnabled = false
        finishButton.isHidden = false
        recordImage.isHidden = false
    }
    
    func setUIForPostTesting() {
        recordImage.isHidden = true
        recordButton.setTitle("Exercise Complete", for: .normal)
        recordButton.isHidden = false
        finishButton.setTitle("Back To Menu", for: .normal)
        finishButton.isEnabled = true
    }
}

