//
//  ViewController.swift
//  Speech Analysis
//
//  Created by Lauren Kearley on 11/2/18.
//  Copyright © 2018 btap. All rights reserved.
//

import UIKit
import SideMenu

class MainMenuViewController: UIViewController {
    
    //MARK: Setup
    let isMenuShowing = false
    
    //MARK: Outlets
    @IBOutlet weak var beginTestButton: UIButton!
    
    
    //MARK: Actions
    @IBAction func openMenu(_ sender: Any) {
        present(SideMenuManager.default.menuLeftNavigationController!,
                animated: true,
                completion: nil)
    }
    
    override func viewDidLoad() {
        self.navigationItem.title = "Dashboard"
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        formatButton(button: beginTestButton)
        let sideMenuViewController = SideMenuViewController()
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: sideMenuViewController)
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
    }
    
    //MARK: Functions
    func formatButton(button: UIButton) {
        //Create button gradient
        let gradient = CAGradientLayer()
        gradient.frame.size = button.frame.size
        button.layer.cornerRadius = button.frame.height / 5
        let grayCGColor = UIColor.uicolorFromHex(rgbValue: 0x333333).cgColor
        let whiteCGColor = UIColor.uicolorFromHex(rgbValue: 0xffffff).cgColor
        gradient.colors = [grayCGColor,
                           grayCGColor,
                           whiteCGColor,
                           whiteCGColor]
        gradient.locations = [0.0,0.6,0.6,1.0]
        gradient.cornerRadius = button.layer.cornerRadius
        gradient.borderWidth = 0.5
        gradient.borderColor = grayCGColor
        button.layer.insertSublayer(gradient, at: 0)
        //Align text to left and format it
        button.contentHorizontalAlignment = .left
        let heightOffset = button.frame.height / 30
        button.titleEdgeInsets = UIEdgeInsets(top: 0,
                                              left: 10,
                                              bottom: -heightOffset,
                                              right: 0)
        //Create button shadow
        button.layer.shadowColor = UIColor(red: 0,
                                           green: 0,
                                           blue: 0,
                                           alpha: 0.25).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 0.0
        button.layer.masksToBounds = false
        //Add arrow picture
        let arrowImageView = UIImageView(image: #imageLiteral(resourceName: "MainMenuArrow"))
        let yOffset = button.frame.height * 0.44
        let xOffset =  button.frame.width - (button.frame.width / 4)
        let arrowSize = button.frame.height / 3
        arrowImageView.frame = CGRect(x: xOffset,
                                      y: yOffset,
                                      width: arrowSize,
                                      height: arrowSize)
        button.addSubview(arrowImageView)
    }
    
}

