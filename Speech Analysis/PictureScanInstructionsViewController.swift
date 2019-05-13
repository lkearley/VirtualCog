//
//  PictureScanInstructionsViewController.swift
//  Speech Analysis
//
//  Created by Lauren Kearley on 2/11/19.
//  Copyright © 2019 btap. All rights reserved.
//

import UIKit
import AVFoundation

class PictureScanInstructionsViewController: UIViewController {

    let speechSynthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Picture Scan Test"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let instructions = "You will see a series of pictures for one minutes each, Describe what you see in the picture. You can pinch the screen to zoom in or out on sections of the picture."
        
        let speechUtterance = AVSpeechUtterance(string: instructions)
        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        self.speechSynthesizer.speak(speechUtterance)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.speechSynthesizer.stopSpeaking(at: .immediate)
    }
    

}
