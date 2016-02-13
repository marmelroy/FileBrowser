//
//  FileBrowser.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 12/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation
import QuickLook

public class FileBrowser: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    var searchController: UISearchController?
        
    let parser = FileParser()
    
    let previewManager = PreviewManager()
    
    let bundle =  NSBundle(forClass: FileBrowser.self)
    
    var isSearching = false
    
    var initialPath: NSURL? {
        didSet {
            if let initialPath = initialPath {
                files = parser.filesForDirectory(initialPath)
                self.title = initialPath.lastPathComponent
            }
        }
    }
    
    deinit{
        if #available(iOS 9.0, *) {
            searchController?.loadViewIfNeeded()
        } else {
            searchController?.loadView()
        }
    }
    
    convenience init () {
        let parser = FileParser()
        let path = parser.documentsURL()
        self.init(initialPath: path)
    }
    
    convenience init (initialPath: NSURL) {
        self.init(nibName: "FileBrowser", bundle: NSBundle(forClass: FileBrowser.self))
        searchController = UISearchController(searchResultsController: nil)
        self.initialPath = initialPath
        self.title = initialPath.lastPathComponent
        files = parser.filesForDirectory(initialPath)
        indexFiles()
    }
    
    var sections: [[File]] = []
    
    var files = [File]() {
        didSet {
            self.indexFiles()
        }
    }
    
    var filteredFiles = [File]()

    
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

    //MARK: Lifecycle
    
    override public func viewDidLoad() {
        
        searchController?.searchBar.searchBarStyle = .Minimal
        tableView.tableHeaderView = searchController?.searchBar

        // Setup the Search Controller
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.delegate = self
        definesPresentationContext = true
        searchController?.dimsBackgroundDuringPresentation = false
        updateSelection()
    }
    
    
    let collation = UILocalizedIndexedCollation.currentCollation()
    
    // MARK: UITableViewDelegate
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let searchController = searchController else {
            return nil
        }
        if searchController.active && searchController.searchBar.text != "" {
            return nil
        }
        if sections[section].count > 0 {
            return collation.sectionTitles[section]
        }
        else {
            return nil
        }
    }
    
    public func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        guard let searchController = searchController else {
            return nil
        }
        if searchController.active && searchController.searchBar.text != "" {
            return nil
        }
        return collation.sectionIndexTitles
    }
    
    public func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        guard let searchController = searchController else {
            return 1
        }
        if searchController.active && searchController.searchBar.text != "" {
            return 0
        }
        return collation.sectionForSectionIndexTitleAtIndex(index)
    }
    
    //MARK: UITableView Data Source and Delegate
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let searchController = searchController else {
            return 1
        }
        if searchController.active && searchController.searchBar.text != "" {
            return 1
        }
        return sections.count
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let searchController = searchController else {
            return 1
        }
        if searchController.active && searchController.searchBar.text != "" {
            return filteredFiles.count
        }
        return sections[section].count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "FileCell"
        var cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        if let reuseCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) {
            cell = reuseCell
        }
        cell.selectionStyle = .Blue
        var file: File
        guard let searchController = searchController else {
            return cell
        }
        if searchController.active && searchController.searchBar.text != "" {
            file = filteredFiles[indexPath.row]
        }
        else {
            file = sections[indexPath.section][indexPath.row]
        }
        cell.textLabel?.text = file.fileName
        cell.imageView?.image = file.type.image()
        return cell
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var file: File
        guard let searchController = searchController else {
            return
        }
        if searchController.active && searchController.searchBar.text != "" {
            file = filteredFiles[indexPath.row]
        }
        else {
            file = sections[indexPath.section][indexPath.row]
        }
        if file.isDirectory {
            let browser = FileBrowser(initialPath: file.filePath)
            self.navigationController?.pushViewController(browser, animated: true)
        }
        else {
            let quickLook = QLPreviewController()
            previewManager.filePath = file.filePath
            quickLook.dataSource = previewManager
            self.navigationController?.pushViewController(quickLook, animated: true)
        }
        updateSelection()
    }
    
    func updateSelection() {
        tableView.reloadData()
    }
    
    func filterContentForSearchText(searchText: String) {
        filteredFiles = files.filter({ (file: File) -> Bool in
            return file.fileName.lowercaseString.containsString(searchText.lowercaseString)
        })
        tableView.reloadData()
    }
    
}


extension FileBrowser: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    public func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchBar.text!)
    }
}

extension FileBrowser: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    public func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
