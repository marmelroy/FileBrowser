//
//  FileUtilities.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 12/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

enum FileType: String {
    case PNG = "png"
    case JPG = "jpg"
    case PDF = "pdf"
    case ZIP = "zip"
    case Default = "file"

    func image() -> UIImage? {
        
        let bundle =  NSBundle(forClass: FileBrowser.self)
        var fileName = String()
        switch self {
        case PNG: fileName = "image.png"
        case JPG: fileName = "image.png"
        case PDF: fileName = "pdf.png"
        case ZIP: fileName = "zip.png"
        case Default: fileName = "file.png"
        }
        let file = UIImage(named: fileName, inBundle: bundle, compatibleWithTraitCollection: nil)
        return file
    }
}

class FileUtilities {
    

}