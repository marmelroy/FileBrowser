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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func showFileBrowser(sender: AnyObject) {
        let fileBrowser = FileBrowser()
//        fileBrowser.excludesFileTypes = [.ZIP]
//        fileBrowser.didSelectFile = { (file: File) -> Void in
//            print("file \(file.filePath)")
//        }
        self.presentViewController(fileBrowser, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
