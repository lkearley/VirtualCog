//
//  NamingViewController.swift
//  
//
//  Created by Lauren Kearley on 2/10/19.
//

import UIKit
import AVFoundation
import BoxContentSDK

class NamingViewController: UIViewController, AVAudioRecorderDelegate {
    
    //MARK: Variables
    let imageArray : [(name: String, image: UIImage)] = [ ("butterfly", #imageLiteral(resourceName: "butterfly")), ("glove", #imageLiteral(resourceName: "glove")), ("watch", #imageLiteral(resourceName: "watch")),
                                                           ("seesaw", #imageLiteral(resourceName: "seesaw")), ("flashlight", #imageLiteral(resourceName: "flashlight")), ("plug", #imageLiteral(resourceName: "plug")),
                                                           ("parachute", #imageLiteral(resourceName: "parachute")), ("axel", #imageLiteral(resourceName: "axel")), ("lightbulb", #imageLiteral(resourceName: "lightbulb")),
                                                           ("kite", #imageLiteral(resourceName: "kite")), ("witch", #imageLiteral(resourceName: "witch")), ("screw", #imageLiteral(resourceName: "screw")),
                                                           ("funnel", #imageLiteral(resourceName: "funnel")),  ("dustpan", #imageLiteral(resourceName: "dustpan")), ("porthole", #imageLiteral(resourceName: "porthole")),
                                                           ("mortar", #imageLiteral(resourceName: "mortar")), ("candle", #imageLiteral(resourceName: "candle")), ("rainbow", #imageLiteral(resourceName: "rainbow")),
                                                           ("peacock", #imageLiteral(resourceName: "peacock")), ("cage", #imageLiteral(resourceName: "cage")), ("wig", #imageLiteral(resourceName: "wig")),
                                                           ("scarf", #imageLiteral(resourceName: "scarf")), ("hinge", #imageLiteral(resourceName: "hinge")), ("anvil", #imageLiteral(resourceName: "anvil"))]
    var setNumber : Int?
    var currImage = 0 //keeps track of current image displayed
    var hintHash : [String : String] = [:]
    var isTestDone = false
    
    //Audio setup
    var recordingSession: AVAudioSession!
    var recorder: AVAudioRecorder!
    var isPaused = false
    
    //Speach synthesizer for hints
    let speechSynthesizer = AVSpeechSynthesizer()
    
    //File system setup
    var audioFileName = AppDelegate.shared().patientID + "_Naming.m4a"
    var textFileName = AppDelegate.shared().patientID + "_Naming.txt"
    var textFileOutput = ""
    
    //Timer
    weak var timer:Timer?
    
    //MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var recordImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTest()
        //Load hints from csv
        readCSV()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopTimer()
        recordImage.removePulse()
        if recorder != nil && recorder.isRecording {
            recorder.stop()
            recorder = nil
        }
        imageView.image = nil
        resetTest()
    }
    
    //MARK: Actions
    @IBAction func hintPressed(_ sender: Any) {
        provideHint()
    }
    
    @IBAction func startSession(_ sender: Any) {
        if recorder != nil && !isPaused {
            recorder.record()
            recordImage.isHidden = false
            recordImage.pulse()
            startNextTimer()
            recordButton.setTitle("Pause Session", for: .normal)
            hintButton.isEnabled = true
            nextButton.isEnabled = true
            currImage = 0
            imageView.image = imageArray[currImage].image
            textFileOutput += imageArray[currImage].name + "\n"
            textFileOutput += "Timestamp: 0 Seconds\n"
        } else if recorder.isRecording && !isPaused {
            pauseRecording()
            isPaused = true
        } else if recorder.isRecording && isPaused {
            resumeRecording()
            isPaused = false
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        if isTestDone {
            performSegue(withIdentifier: "showPictureScan", sender: self)
        } else {
            goToNextImage()
        }
    }
    
    //Mark: Functions
    
    //Loads hint data from CSV
    func readCSV() {
        guard let csvPath = Bundle.main.path(forResource: "naming", ofType: "csv") else {return}
        do {
            let csvData = try String(contentsOfFile: csvPath, encoding: String.Encoding.utf8)
            let csv = csvData.components(separatedBy: "\n")
            
            for row in csv {
                let pair = row.components(separatedBy: ",")
                let key = pair[0]
                let value = pair[1]
                hintHash[key] = value
            }
        } catch {
            print("There was an error reading the csv")
        }
    }
    
    func finishRecording(success: Bool) {
        if let audioRecorder = recorder {
            audioRecorder.stop()
        }
        recordImage.isHidden = true
        recordImage.removePulse()
        timer?.invalidate()
        recorder = nil
        hintButton.isEnabled = false
        hintButton.isHidden = true
        nextButton.isEnabled = true
        nextButton.setTitle("Next Test", for: .normal)
        isTestDone = true
        recordButton.isEnabled = false
        recordButton.setTitle("Excercise Complete", for: .normal)
        recordButton.isHidden = false 
        currImage = 0
        imageView.image = nil
        isPaused = false
        if success {
            FileUploadManager.fileUpload(filePath: AudioRecordingManager.getURL(fileName: audioFileName).absoluteString,
                                         filename: audioFileName,
                                         view: self)
            do {
                try textFileOutput.write(to: AudioRecordingManager.getURL(fileName: textFileName),
                                         atomically: false,
                                         encoding: .utf8)
            } catch {
                print("Picture naming text did not write to file")
            }
            FileUploadManager.fileUpload(filePath: AudioRecordingManager.getURL(fileName: textFileName).absoluteString,
                                         filename: textFileName,
                                         view: self)
        } else {
            let errorMessage = UIAlertController(title: "Error",
                                                 message: "Error Recording\n Please Try Again",
                                                 preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay",
                                       style: .default,
                                       handler: nil)
            errorMessage.addAction(action)
            self.present(errorMessage, animated: true)
        }
    }
    
    func pauseRecording() {
        if let recorder = recorder {
            stopTimer()
            recorder.pause()
            imageView.image = nil
            recordButton.setTitle("Resume Recording", for: .normal)
            nextButton.isEnabled = false
            hintButton.isEnabled = false
        }
    }
    
    func resumeRecording() {
        if let recorder = recorder {
            startNextTimer()
            recorder.record()
            imageView.image = imageArray[currImage].image
            recordButton.setTitle("Pause Recording", for: .normal)
            nextButton.isEnabled = true
            hintButton.isEnabled = true
        }
    }
    
    func provideHint() {
        if let hint = hintHash[imageArray[currImage].name] {
            let speechUtterance = AVSpeechUtterance(string: hint)
            speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
            speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            self.speechSynthesizer.speak(speechUtterance)
            textFileOutput += "Hint used\n"
            hintLabel.text = hint
        }
    }
    
    func goToNextImage() {
        stopTimer()
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
        if currImage < imageArray.count - 1 {
            currImage += 1
            hintLabel.text = ""
            imageView.image = imageArray[currImage].image
            textFileOutput += imageArray[currImage].name + "\n"
            textFileOutput += "Timestamp: " + "\(recorder.currentTime) Seconds\n"
            startNextTimer()
        }
        //special cases, make next a finish button if last photo or stop recording if finished pressed
        if currImage == imageArray.count - 1 {
            nextButton.setTitle("Finish", for: .normal)
            currImage += 1
            startNextTimer()
        } else if currImage == imageArray.count {
            finishRecording(success: true)
            isTestDone = true
            imageView.image = nil
            currImage = 0
            hintButton.isEnabled = false
            nextButton.isEnabled = true
            hintLabel.text = ""
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    func startNextTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [self] _ in
            self.goToNextImage()
        }
    }
    
    func resetTest() {
        recordImage.isHidden = true
        recordButton.setTitle("Begin Session", for: .normal)
        recordButton.isEnabled = true
        isPaused = false
        nextButton.isEnabled = false
        hintButton.isEnabled = false
        audioFileName = AppDelegate.shared().patientID + "_Naming.m4a"
        textFileName = AppDelegate.shared().patientID + "_Naming.txt"
        textFileOutput = ""
        currImage = 0
        recorder = AudioRecordingManager.setUpRecorder(view: self, fileName: audioFileName)
        isTestDone = false
    }
    
    func initializeTest() {
        recordImage.isHidden = true
        nextButton.isEnabled = false
        hintButton.isEnabled = false
        recorder = AudioRecordingManager.setUpRecorder(view: self, fileName: audioFileName)
        isTestDone = false
    }
}
