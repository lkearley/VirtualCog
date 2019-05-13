//
//  CABasicAnimation+Pulse.swift
//  Speech Analysis
//
//  Created by Lauren Kearley on 5/11/19.
//  Copyright © 2019 btap. All rights reserved.
//

import Foundation
import UIKit

func pulse(view: UIImageView) {
    let pulseAnimation = CABasicAnimation(keyPath: "pulse")
    pulseAnimation.duration = 1.0
    pulseAnimation.repeatCount = Float.greatestFiniteMagnitude
    pulseAnimation.autoreverses = true
    pulseAnimation.fromValue = 0.5;
    pulseAnimation.toValue = 1.5;
    view.layer.add(pulseAnimation, forKey: "animatePulse")
}

func removePulse(view: UIView) {
    view.layer.removeAllAnimations()
}

