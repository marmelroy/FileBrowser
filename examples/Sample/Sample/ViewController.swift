//
//  ViewController.swift
//  Sample
//
//  Created by Roy Marmelstein on 12/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import UIKit
import FileBrowser

class ViewController: UIViewController {

    @IBAction func showFileBrowser(sender: AnyObject) {
        let fileBrowser = FileBrowser()
        self.presentViewController(fileBrowser, animated: true, completion: nil)
    }

}
