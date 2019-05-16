//
//  UnuploadedFilesTableViewController.swift
//  B.T.A.P v2
//
//  Created by Lauren Kearley on 2/16/19.
//  Copyright © 2019 btap. All rights reserved.
//
import UIKit
import BoxContentSDK

class UnuploadedFilesTableViewController: UITableViewController {
    
    var fileURLs = [URL]()
    let fileManager = FileManager.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileURLs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = fileURLs[indexPath.row].lastPathComponent
        return cell
    }
    
    @IBAction func uploadFiles(_ sender: Any) {
        for file in fileURLs {
            FileUploadManager.fileUpload(filePath: file.absoluteString,
                                         filename: file.lastPathComponent,
                                         view: self)
        }
        self.tableView.reloadData()
    }
    
    
}
