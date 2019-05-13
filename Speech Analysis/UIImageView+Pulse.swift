//
//  UIImageView+Pulse.swift
//  Speech Analysis
//
//  Created by Lauren Kearley on 5/11/19.
//  Copyright © 2019 btap. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func pulse() {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 1.0
        pulseAnimation.repeatCount = Float.greatestFiniteMagnitude
        pulseAnimation.autoreverses = true
        pulseAnimation.fromValue = 0.75;
        pulseAnimation.toValue = 1.25;
        self.layer.add(pulseAnimation, forKey: "animatePulse")
        self.layoutIfNeeded()
    }
    
    func removePulse() {
        self.layer.removeAllAnimations()
    }

}
