//
//  filePicker.swift
//  PDFPaginator
//
//  Created by Paul Gowder on 6/4/19.
//  Copyright © 2019 Paul Gowder. All rights reserved.
//

import Cocoa

func pickFile(type: String = "pdf", callback: (URL) -> Void){
    let dialog = NSOpenPanel()
    dialog.title = "choose file"
    dialog.showsResizeIndicator = true
    dialog.showsHiddenFiles = true
    dialog.canChooseDirectories = false
    dialog.canCreateDirectories = false
    dialog.allowsMultipleSelection = false
    dialog.allowedFileTypes = [type]
    
    if (dialog.runModal() == NSApplication.ModalResponse.OK) {
        
        let result = dialog.url!
        callback(result)
        
    } else {
        // User clicked on "Cancel"
        return
    }
}
