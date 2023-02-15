//
//  MainSplitViewController.swift
//  Preferences Viewer
//
//  Created by Jacob Hazelgrove on 2/15/23.
//

import Cocoa

class MainSplitViewController: NSSplitViewController {

    let sidebarViewController = SidebarViewController()
    let emptySelectionViewController = EmptyViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _setupInitialSplitViewItems()
    }
    
}

private extension MainSplitViewController {
    
    func _setupInitialSplitViewItems() {
        
        sidebarViewController.didSelect = { store in
            guard let store = store else {
                self._setDetail(viewController: self.emptySelectionViewController)
                return
            }
            let vc = KeyValueStoreViewController(store)
            self._setDetail(viewController: vc)
        }
        
        
        let sidebarSplitViewItem = NSSplitViewItem(sidebarWithViewController: sidebarViewController)
        //sidebarSplitViewItem.isCollapsed = UserDefaults.standard.bool(forKey: SidebarIsCollapsedKey)
        addSplitViewItem(sidebarSplitViewItem)
        
        let emptyViewController = EmptyViewController()
        _setDetail(viewController: emptyViewController)
    }
    
    func _setDetail(viewController: NSViewController, removeExistingEditor: Bool = true) {
        let splitViewItems = splitViewItems
        
        if removeExistingEditor, splitViewItems.count > 1 {
            let splitViewItemToRemove = splitViewItems[1]
            removeSplitViewItem(splitViewItemToRemove)
        }
        
        let splitViewItem = NSSplitViewItem(viewController: viewController)
        insertSplitViewItem(splitViewItem, at: 1)
    }
    
}
