//
//  PictureAnalysisViewController.swift
//  Speech Analysis
//
//  Created by Lauren Kearley on 11/27/18.
//  Copyright © 2018 btap. All rights reserved.
//

import UIKit
import AVFoundation
import BoxContentSDK

class PictureAnalysisViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIScrollViewDelegate {
    
    //MARK: Variables
    var recorder: AVAudioRecorder!
    var audioFileName = AppDelegate.shared().patientID + "_PictureDescription.m4a"
    var imageTimer: Timer! // Timer for the image
    var isZooming = false
    let imageArray : [UIImage] = [#imageLiteral(resourceName: "PictureAnalysisImage2"), #imageLiteral(resourceName: "PictureAnalysisImage")]
    var currImage = 0
    var isTestDone = false
    var originalImageCenter:CGPoint?
    
    //MARK: Outlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var recordImage: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTest()
        scrollView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        imageTimer?.invalidate()
        recordImage.removePulse()
        if recorder != nil && recorder.isRecording {
            recorder.stop()
            recorder = nil
        }
        ImageView.image = nil
        resetTest()
    }
    
    //MARK: Actions
    @IBAction func startRecordSession(_ sender: UIButton) {
        recorder.record() // Start recording
        ImageView.image = imageArray[currImage]
        setZoomScale(image: imageArray[currImage])
        setUIForTesting()
        recordImage.pulse()
        // Set up timer to limit length of active recording session
        startImageTimer()
    }
    @IBAction func nextTest(_ sender: Any) {
        if isTestDone {
            performSegue(withIdentifier: "showDelayRecall", sender: self)
        }
    }
    
    //MARK: Functions
    func setZoomScale(image: UIImage) {
        let imageViewSize = image.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        let minZoomScale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = minZoomScale
        scrollView.zoomScale = minZoomScale
    }
    
    /* Function to end a recording session */
    @objc func endRecording() {
        if currImage == imageArray.count - 1 {
            recordImage.removePulse()
            setUIForPostTesting()
            isTestDone = true
            imageTimer.invalidate()
            recorder.stop()
            FileUploadManager.fileUpload(filePath: AudioRecordingManager.getURL(fileName: audioFileName).absoluteString,
                                         filename: audioFileName,
                                         view: self)
        } else {
            imageTimer.invalidate()
            currImage += 1
            ImageView.image = imageArray[currImage]
            setZoomScale(image: imageArray[currImage])
            startImageTimer()
        }
    }
    
    func startImageTimer() {
        imageTimer = Timer.scheduledTimer(timeInterval: 30.0,
                                          target: self,
                                          selector: #selector(endRecording),
                                          userInfo: nil,
                                          repeats: false)
    }
    
    func resetTest() {
        audioFileName = AppDelegate.shared().patientID + "_PictureDescription.m4a"
        currImage = 0
        isTestDone = false
        recorder = AudioRecordingManager.setUpRecorder(view: self, fileName: audioFileName)
        recordImage.isHidden = true
        recordButton.isEnabled = true
        recordButton.setTitle("Begin Session", for: .normal)
    }
    
    func initializeTest() {
        recorder = AudioRecordingManager.setUpRecorder(view: self, fileName: audioFileName)
        recordImage.isHidden = true
        nextButton.isHidden = true
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return ImageView
    }
    
    func resetUI() {
        recordImage.isHidden = true
        recordButton.isEnabled = true
        recordButton.setTitle("Begin Session", for: .normal)
        scrollView.isHidden = false
    }
    
    func setUIForTesting() {
        recordButton.isHidden = true
        recordButton.isEnabled = false
        nextButton.setTitle("Recording...", for: .normal)
        nextButton.isEnabled = false
        nextButton.isHidden = false
        recordImage.isHidden = false
    }
    
    func setUIForPostTesting() {
        ImageView.image = nil
        recordImage.isHidden = true
        scrollView.isHidden = true
        nextButton.setTitle("Next Test", for: .normal)
        nextButton.isEnabled = true
        recordButton.isEnabled = false
        recordButton.setTitle("Exercise Complete", for: .normal)
        recordButton.isHidden = false
    }
    
}
