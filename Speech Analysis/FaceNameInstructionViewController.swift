//
//  FaceNameInstructionViewController.swift
//  Speech Analysis
//
//  Created by Lauren Kearley on 11/25/18.
//  Copyright © 2018 btap. All rights reserved.
//

import UIKit
import AVFoundation

class FaceNameInstructionViewController: UIViewController {
    
    let speechSynthesizer = AVSpeechSynthesizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Face-Name Recall Test"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let instructions = "You will see a series of pictures with names for five seconds each three times. Remember the names of each picture you see. You will be asked to name the pictures after they are all shown. You will again be asked to name each picture once all other tests are complete."
        let speechUtterance = AVSpeechUtterance(string: instructions)
        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        self.speechSynthesizer.speak(speechUtterance)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.speechSynthesizer.stopSpeaking(at: .immediate)
    }

}
