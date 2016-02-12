//
//  FileBrowser.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 12/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

public class FileBrowser: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    let fileManager = NSFileManager.defaultManager()
    
    let bundle =  NSBundle(forClass: FileBrowser.self)
    
    var path: NSURL? {
        didSet {
            updateFiles()
        }
    }
    
    convenience init () {
        self.init(nibName: "FileBrowser", bundle: NSBundle(forClass: FileBrowser.self))
    }
    
    
    var files = [String]()
    
    var selectedFiles = [String]()
    
    //MARK: Lifecycle
    
    override public func viewDidLoad() {
        if self.path == nil {
            let documentsUrl = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as NSURL
            self.path = documentsUrl
        }
        updateSelection()
    }
    
    //MARK: File manager
    
    func updateFiles() {
        if let filePath = path {
            var tempFiles = [String]()
            do  {
                self.title = filePath.lastPathComponent
                tempFiles = try self.fileManager.contentsOfDirectoryAtPath(filePath.path!)
            } catch {
                if path == "/System" {
                    tempFiles = ["Library"]
                }
                if path == "/Library" {
                    tempFiles = ["Preferences"]
                }
                if path == "/var" {
                    tempFiles = ["mobile"]
                }
                if path == "/usr" {
                    tempFiles = ["lib", "libexec", "bin"]
                }
            }
            self.objects = tempFiles.sort(){$0 < $1}
            tableView.reloadData()
        }
    }
    
    func localizedTitle() {
    }
    
    let collation = UILocalizedIndexedCollation.currentCollation()
    var sections: [[String]] = []
    var objects: [String] = [] {
        didSet {
            let selector: Selector = "self"
            sections = Array(count: collation.sectionTitles.count, repeatedValue: [])
            
            if let sortedObjects = collation.sortedArrayFromArray(objects, collationStringSelector: selector) as? [String]{
            for object in sortedObjects {
                let sectionNumber = collation.sectionForObject(object, collationStringSelector: selector)
                sections[sectionNumber].append(object)
            }
            }
            self.tableView.reloadData()
        }
    }
    
    // MARK: UITableViewDelegate
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sections[section].count > 0 {
            return collation.sectionTitles[section]
        }
        else {
            return nil
        }
    }
    
    public func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return collation.sectionIndexTitles
    }
    
    public func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return collation.sectionForSectionIndexTitleAtIndex(index)
    }
    
    //MARK: UITableView Data Source and Delegate
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "FileCell"
        var cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        if let reuseCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) {
            cell = reuseCell
        }
        guard let path = path else {
            return cell
        }
        cell.selectionStyle = .None
        let filePath = sections[indexPath.section][indexPath.row]
        let pathURL = path.URLByAppendingPathComponent(filePath)
        let newPath = pathURL.path!
        var isDirectory: ObjCBool = false
        fileManager.fileExistsAtPath(newPath, isDirectory: &isDirectory)
        cell.textLabel?.text = filePath
        if isDirectory {
            cell.imageView?.image = UIImage(named: "folder.png", inBundle: bundle, compatibleWithTraitCollection: nil)
        }
        else {
            let fileType = FileType(rawValue: pathURL.pathExtension!) ?? FileType.Default
            if let image = fileType.image() {
                cell.imageView?.image = image
            }
        }
        cell.backgroundColor = (selectedFiles.contains(filePath)) ? UIColor(white: 0.9, alpha: 1.0):UIColor.whiteColor()
        return cell
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let filePath = files[indexPath.row]
        if let index = selectedFiles.indexOf(filePath) where selectedFiles.contains(filePath) {
            selectedFiles.removeAtIndex(index)
        }
        else {
            selectedFiles.append(filePath)
        }
        updateSelection()
    }
    
    func updateSelection() {
        tableView.reloadData()
//        selectionCounter.title = "\(selectedFiles.count) Selected"
//        
//        zipButton.enabled = (selectedFiles.count > 0)
//        if (selectedFiles.count == 1) {
//            let filePath = selectedFiles.first
//            let pathExtension = path!.URLByAppendingPathComponent(filePath!).pathExtension
//            if pathExtension == "zip" {
//                unzipButton.enabled = true
//            }
//            else {
//                unzipButton.enabled = false
//            }
//        }
//        else {
//            unzipButton.enabled = false
//        }
    }
    
    
}
