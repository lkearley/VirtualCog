//
//  FileUploadManager.swift
//  Speech Analysis
//
//  Created by Lauren Kearley on 5/13/19.
//  Copyright © 2019 btap. All rights reserved.
//

import Foundation
import BoxContentSDK

class FileUploadManager {
    static let client = BOXContentClient.default()
    
    static func fileUpload(filePath: String, filename: String, view: UIViewController) {
        if let client = client {
            let uploadRequest = client.fileUploadRequestToFolder(withID: BOXAPIFolderIDRoot, fromLocalFilePath: filePath)
            uploadRequest?.fileName = filename
            uploadRequest?.perform(progress: nil, completion: { (file, error) in
                if let _ = file {
                    let fileURL = AudioRecordingManager.getURL(fileName: filename)
                    do {
                        try FileManager.default.removeItem(at: fileURL)
                    } catch {
                        print("file failed to delete")
                    }
                } else {
                    let errorMessage = UIAlertController(title: "Error",
                                                         message: "File Upload failed: this file can be uploaded from the main menu",
                                                         preferredStyle: .alert)
                    let action = UIAlertAction(title: "Okay",
                                               style: .default,
                                               handler: nil)
                    errorMessage.addAction(action)
                    view.present(errorMessage, animated: true)
                }
            })
        } else {
            let errorMessage = UIAlertController(title: "Error",
                                                 message: "File Upload failed: Not signed into Box, this file can be uploaded from the main menu",
                                                 preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay",
                                       style: .default,
                                       handler: nil)
            errorMessage.addAction(action)
            view.present(errorMessage, animated: true)
        }
    }
}


