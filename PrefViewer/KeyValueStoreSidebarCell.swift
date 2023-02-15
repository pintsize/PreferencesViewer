//
//  KeyValueStoreSidebarCell.swift
//  Preferences Viewer
//
//  Created by Jacob Hazelgrove on 2/15/23.
//

import AppKit

final class KeyValueStoreSidebarCell: NSTableCellView {
    
    @IBOutlet weak var icon: NSImageView!
    @IBOutlet weak var name: NSTextField!
    
    @IBOutlet weak var countContainer: NSBox!
    @IBOutlet weak var count: NSTextField!
    
}
