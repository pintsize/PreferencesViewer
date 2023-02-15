//
//  KeyValueStoreViewController.swift
//  Preferences Viewer
//
//  Created by Jacob Hazelgrove on 2/15/23.
//

import Cocoa

class KeyValueStoreViewController: NSViewController {
    
    
    let keyValueStore: KeyValueStore
    
    init(_ keyValueStore: KeyValueStore) {
        self.keyValueStore = keyValueStore
        super.init(nibName: nil, bundle:  nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
    }
    
    
    func reloadData() {
        var longestKeyCount = 0
        
        for keyValuePair in keyValueStore.keyValuePairs {
            let keyCount = keyValuePair.key.count
            if keyCount > longestKeyCount { longestKeyCount = keyCount }
        }
        
        
        for keyValuePair in keyValueStore.keyValuePairs {
            let keyCount = keyValuePair.key.count
            let spacesToAdd = longestKeyCount - keyCount
            print("\t\(String(repeating: " ", count: spacesToAdd))\(keyValuePair.key): \(kvpDescription(for: keyValuePair.value))")
            
            
        }
    }
    
    func dataType(for value: Any) -> DataType {
        switch value {
            case let number as NSNumber:
                return dataType(for: number)
                
            case _ as NSArray:
                return .array
                
            case _ as Date:
                return .date
                
            case _ as Data:
                return .data
                
            case _ as String:
                return .string
                
            case _ as NSDictionary:
                return .dictionary
                
            default:
                return .string
        }
    }
    
    func dataType(for number: NSNumber) -> DataType {
        let type = CFNumberGetType(number)
        
        switch type {
                
            case .sInt8Type, .sInt16Type, .sInt32Type, .sInt64Type, .nsIntegerType, .shortType, .intType, .longType, .longLongType, .cfIndexType:
                return .integer
            case .float32Type, .float64Type, .floatType, .cgFloatType, .doubleType:
                return .double
            case .charType:
                // Will .charType always be a boolean in the context of user defaults?
                return .boolean
                
            @unknown default:
                return .unknown
        }
    }
    
    func kvpDescription(for value: Any) -> String {
        switch value {
            case let number as NSNumber:
                return "\(number)"
            case _ as NSDictionary:
                return "{...}"
            case _ as NSArray:
                return "(...)"
            case let date as Date:
                return "\(date)"
            case let string as String:
                return "\(string)"
            default:
                return "\(String(describing: value)))"
        }
    }
    
    
    func kvpDescription(for number: NSNumber) -> String {
        let type = CFNumberGetType(number)
        
        switch type {
                
            case .sInt8Type, .sInt16Type, .sInt32Type, .sInt64Type, .nsIntegerType, .shortType, .intType, .longType, .longLongType, .cfIndexType:
                return "int(\(number))"
            case .float32Type, .float64Type, .floatType, .cgFloatType, .doubleType:
                return "double(\(number))"
            case .charType:
                // Will .charType always be a boolean in the context of user defaults?
                return "bool(\(number.boolValue))"
                
            @unknown default:
                return "other"
        }
        
    }
    
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
}


extension NSArray {
    var countString: String {
        if count == 1 {
            return "1 element"
        } else {
            return "\(count) elements"
        }
    }
}

extension KeyValueStoreViewController: NSTableViewDataSource, NSTableViewDelegate {
    
    var keyValuePairCount: Int {
        keyValueStore.keyValuePairs.count
    }
    func keyValuePair(at index: Int) -> KeyValuePair? {
        return keyValueStore.keyValuePairs[index]
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        keyValuePairCount
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        guard let tableColumn = tableColumn,
              let kvp = keyValuePair(at: row) else {
            return nil
        }
        
        if tableColumn.identifier == .init(rawValue: "key") {
            return kvp.key
        }
        
        else if tableColumn.identifier == .init(rawValue: "dataType") {
            return kvp.dataType.localizedDescription
        }
        
        else if tableColumn.identifier == .init(rawValue: "value") {
            return kvpDescription(for: kvp.value)
        }
        
        return nil
    }
}

