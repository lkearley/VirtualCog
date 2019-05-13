//
//  NamingInstructionsViewController.swift
//  Speech Analysis
//
//  Created by Lauren Kearley on 2/11/19.
//  Copyright © 2019 btap. All rights reserved.
//

import UIKit
import AVFoundation

class NamingInstructionsViewController: UIViewController {

    //MARK: Variables
    let speechSynthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Picture Naming Test"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let instructions = "You will see some pictures of objects, one at a time. Please say out loud the name of each picture. If you need a hint press the hint button in the bottom right corner. If you think you have said the answer, press the next button in the bottom left corner. To begin the session, press the begin session button at the top of the screen."
        
        let speechUtterance = AVSpeechUtterance(string: instructions)
        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        self.speechSynthesizer.speak(speechUtterance)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.speechSynthesizer.stopSpeaking(at: .immediate)
    }

}
