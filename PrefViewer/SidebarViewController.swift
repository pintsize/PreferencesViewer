//
//  SidebarViewController.swift
//  Preferences Viewer
//
//  Created by Jacob Hazelgrove on 2/15/23.
//

import Cocoa

enum SidebarRow {
    case store(KeyValueStore)
    case separator
}

class SidebarViewController: NSViewController {
    
    init() {
        super.init(nibName: nil, bundle:  nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var rows: [SidebarRow] = []
    
    var didSelect: ((KeyValueStore?)->(Void))?
    
    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let global = KeyValueStore.global else { return }
        
        var foundRows: [SidebarRow] = []
        
        foundRows.append(.store(global))
        
        let runningApplications = NSWorkspace.shared.runningApplicationsWithBundleIdentifiers
        
        if runningApplications.count > 0 {
            
            foundRows.append(.separator)
            
            for runningApplication in runningApplications {
                if let bundleIdentifier = runningApplication.bundleIdentifier,
                   var store = KeyValueStore.keyValueStore(with: bundleIdentifier,
                                                           name: runningApplication.localizedName,
                                                           icon: runningApplication.icon) {
                    store.removingDuplicateKeys(in: global)
                    foundRows.append(.store(store))
                }
            }
        }
        rows = foundRows
        
        tableView.reloadData()
    }
    
}

extension NSUserInterfaceItemIdentifier {
    static let domainCell = NSUserInterfaceItemIdentifier("DomainCell")
}

extension SidebarViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        rows.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let sidebarRow = rows[row]
        
        switch sidebarRow {
            case .store(let store):
                if let cell = tableView.makeView(withIdentifier: .domainCell, owner: self) as? KeyValueStoreSidebarCell {
                    cell.icon.image = store.icon.resized(to: 24.00)
                    cell.name.stringValue = store.name
                    
                    let count = store.keyValues.count
                    if count > 0 {
                        cell.count.stringValue = String(describing: count)
                        cell.countContainer.isHidden = false
                    } else {
                        cell.countContainer.isHidden = true
                    }
                    return cell
                }
            case .separator:
                return NSView()
        }
        
        return nil
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        let sidebarRow = rows[row]
        if case .separator = sidebarRow { return false }
        return true
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let selectedRow = tableView.selectedRow
        
        if selectedRow != -1 {
            let sidebarRow = rows[selectedRow]
            
            if case let .store(keyValueStore) = sidebarRow,
               let handler = didSelect {
                handler(keyValueStore)
            }
            
        } else {
            if let handler = didSelect {
                handler(nil)
            }
        }
        
    }
}

