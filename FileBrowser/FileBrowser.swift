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
    
    let parser = FileParser()
    
    let bundle =  NSBundle(forClass: FileBrowser.self)
    
    var initialPath: NSURL? {
        didSet {
            if let initialPath = initialPath {
                files = parser.filesForDirectory(initialPath)
                self.title = initialPath.lastPathComponent
            }
        }
    }
    
    convenience init () {
        self.init(nibName: "FileBrowser", bundle: NSBundle(forClass: FileBrowser.self))
        let path = parser.documentsURL()
        initialPath = path
        self.title = path.lastPathComponent
        files = parser.filesForDirectory(path)
        indexFiles()
    }
    
    var sections: [[File]] = []
    
    var files = [File]() {
        didSet {
            self.indexFiles()
        }
    }
    
    func indexFiles() {
        let selector: Selector = "fileName"
        sections = Array(count: collation.sectionTitles.count, repeatedValue: [])
        if let sortedObjects = collation.sortedArrayFromArray(files, collationStringSelector: selector) as? [File]{
            for object in sortedObjects {
                let sectionNumber = collation.sectionForObject(object, collationStringSelector: selector)
                sections[sectionNumber].append(object)
            }
        }
    }
    
    var selectedFiles = [File]()
    
    //MARK: Lifecycle
    
    override public func viewDidLoad() {
        updateSelection()
    }
    
    
    let collation = UILocalizedIndexedCollation.currentCollation()
    
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
        cell.selectionStyle = .None
        let file = sections[indexPath.section][indexPath.row]
        cell.textLabel?.text = file.fileName
        cell.imageView?.image = file.type.image()
        return cell
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let file = sections[indexPath.section][indexPath.row]
        if let index = selectedFiles.indexOf(file) where selectedFiles.contains(file) {
            selectedFiles.removeAtIndex(index)
        }
        else {
            selectedFiles.append(file)
        }
        updateSelection()
    }
    
    func updateSelection() {
        tableView.reloadData()
    }
    
    
}
