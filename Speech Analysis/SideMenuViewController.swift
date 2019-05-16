//
//  SideMenuViewController.swift
//  Speech Analysis
//
//  Created by Lauren Kearley on 11/15/18.
//  Copyright © 2018 btap. All rights reserved.
//

import UIKit
import SideMenu
import BoxContentSDK

class SideMenuViewController: UITableViewController {
    
    
    //MARK: Variables
    let menuItems = ["Login to Box", "Set Patient ID", "Upload Files"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.tableView.tableFooterView = UIView()
        
    }
    
    //MARK: TableView Functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel!.text = menuItems[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellNumber = indexPath.row
        if cellNumber == 0 {
            loginToBox()
        } else if cellNumber == 1 {
            changePatientID()
        } else if cellNumber == 2 {
            goToUnUploadedFiles()
        }
    }
    
    //MARK: Functions
    func loginToBox() {
        BOXContentClient.default()?.authenticate(completionBlock: { (user, error) in
            if (error != nil) {
                print("user logged in")
            }
        })
    }
    
    func changePatientID() {
        let alert = UIAlertController(title: "Change ID",
                                      message: "Please enter patient ID",
                                      preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.text = ""
            textfield.keyboardType = UIKeyboardType.numberPad
        }
        let okayAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in
            let textInput = alert.textFields![0]
            if let text = textInput.text {
                AppDelegate.shared().patientID = text
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(okayAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    func goToUnUploadedFiles() {
        guard let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "UnUploadedFiles") as? UnuploadedFilesTableViewController else {
                print("Could not instantiate view controller")
                return
        }
        self.navigationController?.pushViewController(vc, animated:true)
    }
}
