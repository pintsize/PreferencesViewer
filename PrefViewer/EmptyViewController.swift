//
//  EmptyViewController.swift
//  Preferences Viewer
//
//  Created by Jacob Hazelgrove on 2/15/23.
//

import Cocoa

class EmptyViewController: NSViewController {

    init() {
        super.init(nibName: nil, bundle:  nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
