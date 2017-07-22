//
//  WebviewPreviewViewContoller.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 16/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import UIKit
import WebKit

/// Webview for rendering items QuickLook will struggle with.
class WebviewPreviewViewContoller: UIViewController {
    
    var webView = WKWebView()

    var file: FBFile? {
        didSet {
            self.title = file?.displayName
            self.processForDisplay()
        }
    }
    
    var fileData: Data?

    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)
        
        // Add share button
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(WebviewPreviewViewContoller.shareFile))
        self.navigationItem.rightBarButtonItem = shareButton
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        webView.frame = self.view.bounds
    }
    
    //MARK: Share
    
    func shareFile() {
        guard let file = file else {
            return
        }
        
        let activityItems: [Any]
        if let data = fileData {
            activityItems = [data]
        } else if let url = file.resourceUrl {
            activityItems = [url]
        } else {
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)

    }

    //MARK: Processing
    
    func processForDisplay() {
        guard let file = file else {
            print("file is not set!")
            return
        }
        
        let data: Data
        if let fileData = fileData {
            data = fileData
        } else if let localFileUrl = file.resourceUrl,
            localFileUrl.scheme == "file",
            let fileData = try? Data(contentsOf: localFileUrl) {
            data = fileData
        } else {
            print("Could not find data for file!")
            return
        }
        
        var rawString: String?
        
        // Prepare plist for display
        if file.type == .PLIST {
            do {
                if let plistDescription = try (PropertyListSerialization.propertyList(from: data, options: [], format: nil) as AnyObject).description {
                    rawString = plistDescription
                }
            } catch {}
        }
        
        // Prepare json file for display
        else if file.type == .JSON {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                if JSONSerialization.isValidJSONObject(jsonObject) {
                    let prettyJSON = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                    var jsonString = String(data: prettyJSON, encoding: String.Encoding.utf8)
                    // Unescape forward slashes
                    jsonString = jsonString?.replacingOccurrences(of: "\\/", with: "/")
                    rawString = jsonString
                }
            } catch {}
        }
        
        // Default prepare for display
        if rawString == nil {
            rawString = String(data: data, encoding: String.Encoding.utf8)
        }
        
        // Convert and display string
        if let convertedString = convertSpecialCharacters(rawString) {
            let htmlString = "<html><head><meta name='viewport' content='initial-scale=1.0, user-scalable=no'></head><body><pre>\(convertedString)</pre></body></html>"
            webView.loadHTMLString(htmlString, baseURL: nil)
        }
        
    }
    

    // Make sure we convert HTML special characters
    // Code from https://gist.github.com/mikesteele/70ae98d04fdc35cb1d5f
    func convertSpecialCharacters(_ string: String?) -> String? {
        guard let string = string else {
            return nil
        }
        var newString = string
        let char_dictionary = [
            "&amp;": "&",
            "&lt;": "<",
            "&gt;": ">",
            "&quot;": "\"",
            "&apos;": "'"
        ];
        for (escaped_char, unescaped_char) in char_dictionary {
            newString = newString.replacingOccurrences(of: escaped_char, with: unescaped_char, options: NSString.CompareOptions.regularExpression, range: nil)
        }
        return newString
    }
}
