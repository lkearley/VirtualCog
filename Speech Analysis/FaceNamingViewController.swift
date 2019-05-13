//
//  FaceNamingViewController.swift
//  Speech Analysis
//
//  Created by Lauren Kearley on 2/11/19.
//  Copyright © 2019 btap. All rights reserved.
//

import UIKit
import AVFoundation
import BoxContentSDK

class FaceNamingViewController: UIViewController, AVAudioRecorderDelegate {
    
    //MARK: Variables
    let imageArray : [(name: String, image: UIImage)] = [("Kim",#imageLiteral(resourceName: "Kim")), ("Nancy", #imageLiteral(resourceName: "Nancy")), ("Ralph", #imageLiteral(resourceName: "Ralph")),
                                                         ("George", #imageLiteral(resourceName: "George")), ("Diane", #imageLiteral(resourceName: "Diane")), ("Andrew", #imageLiteral(resourceName: "Andrew")),
                                                         ("Bill", #imageLiteral(resourceName: "Bill")), ("Joan", #imageLiteral(resourceName: "Joan")), ("Sarah", #imageLiteral(resourceName: "Sarah")),
                                                         ("Henry", #imageLiteral(resourceName: "Henry")), ("Fred", #imageLiteral(resourceName: "Fred")), ("Elizabeth", #imageLiteral(resourceName: "Elizabeth"))]
    
    var currImage = 0
    var numTimesPreviewPresented = 0
    weak var timer: Timer?
    var previewComplete = false
    var testComplete = false
    var recorder: AVAudioRecorder!
    var audioFileName = AppDelegate.shared().patientID + "_ImmediateFaceNaming.m4a"
    
    //MARK: Outlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var faceImage: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var recordImage: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        inititalizeTest()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        recordImage.removePulse()
        stopTimer()
        if recorder != nil && recorder.isRecording {
            recorder.stop()
            recorder = nil
        }
        faceImage.image = nil
        resetTest()
    }
    
    //MARK: Actions
    @IBAction func startSession(_ sender: Any) {
        startPreview()
    }
    
    @IBAction func nextTest(_ sender: Any) {
        if testComplete {
            performSegue(withIdentifier: "showPictureTest", sender: self)
        } else if previewComplete && !testComplete && currImage == 0 {
            startTesting()
        }
    }
    
    //MARK: Functions
    /* Function to start testing */
    func startTesting() {
        recordImage.isHidden = false
        recordImage.pulse()
        nextButton.setTitle("Recording...", for: .normal)
        nextButton.isHidden = false
        nextButton.isEnabled = false
        faceImage.image = imageArray[currImage].image
        recordImage.isHidden = false
        recordImage.pulse()
        startTestTimer()
    }
    /* Function to start preview */
    func startPreview() {
        centerLabel.isHidden = false
        recordButton.isHidden = true
        faceImage.image = imageArray[currImage].image
        centerLabel.text = imageArray[currImage].name
        startFacePreviewTimer()
    }
    
    /* Function to control initital face showing */
    func startFacePreviewTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [self] _ in
            self.preview()
        }
    }
    
    func startTestTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [self] _ in
            self.testing()
        }
    }
    
    func preview() {
        if currImage < imageArray.count - 1 {
            currImage += 1
            faceImage.image = imageArray[currImage].image
            centerLabel.text = imageArray[currImage].name
            startFacePreviewTimer()
        } else if currImage == imageArray.count - 1 && numTimesPreviewPresented != 2 {
            currImage = 0
            stopTimer()
            numTimesPreviewPresented += 1
            faceImage.image = imageArray[currImage].image
            centerLabel.text = imageArray[currImage].name
            startFacePreviewTimer()
        } else if numTimesPreviewPresented == 2 {
            currImage = 0
            stopTimer()
            centerLabel.isHidden = true
            faceImage.image = nil
            previewComplete = true
            nextButton.setTitle("Start Test", for: .normal)
            nextButton.isHidden = false
        }
    }
    
    func testing() {
        if currImage == self.imageArray.count - 1 {
            recordImage.isHidden = true
            recordImage.removePulse()
            endRecording()
            recordImage.removePulse()
            testComplete = true
            recordButton.setTitle("Exercise Complete", for: .normal)
            recordButton.isEnabled = false
            recordButton.isHidden = false
            nextButton.setTitle("Next Test", for: .normal)
            nextButton.isEnabled = true
            nextButton.isHidden = false
        }
        if currImage < self.imageArray.count - 1 {
            currImage += 1
            faceImage.image = imageArray[currImage].image
            startTestTimer()
        }
    }
    
    func resetTest() {
        recordButton.setTitle("Begin Session", for: .normal)
        recordButton.isEnabled = true
        nextButton.isHidden = true
        centerLabel.isHidden = true
        recordImage.isHidden = true
        previewComplete = false
        testComplete = false
        numTimesPreviewPresented = 0
        currImage = 0
        audioFileName = AppDelegate.shared().patientID + "_ImmediateFaceNaming.m4a"
        recorder = AudioRecordingManager.setUpRecorder(view: self, fileName: audioFileName)
    }
    
    func inititalizeTest() {
        nextButton.isHidden = true
        centerLabel.isHidden = true
        recordImage.isHidden = true
        recorder = AudioRecordingManager.setUpRecorder(view: self, fileName: audioFileName)
    }
    
    /* Function to stop face showing timer */
    func stopTimer() {
        timer?.invalidate()
    }
    
    /* Function to end a recording session */
    func endRecording() {
        recorder.stop()
        faceImage.image = nil
        FileUploadManager.fileUpload(filePath: AudioRecordingManager.getURL(fileName: audioFileName).absoluteString,
                                     filename: audioFileName,
                                     view: self)
    }

}
