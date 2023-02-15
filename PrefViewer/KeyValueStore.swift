//
//  KeyValueStore.swift
//  Preferences Viewer
//
//  Created by Jacob Hazelgrove on 2/8/23.
//

import AppKit

let globalKeyValueStoreIdentifier: String = "systemGlobal"
fileprivate let _systemGlobalEmptyStoreIdentifier: String = "systemGlobalEmptyStore"

struct KeyValueStore: Identifiable {
    
    internal init(id: String, name: String, keyValuePairs: [KeyValuePair] = [], keyValues: [String : KeyValuePair], userDefaults: UserDefaults, icon: NSImage) {
        self.id = id
        self.name = name
        self.keyValuePairs = keyValuePairs
        self.keyValues = keyValues
        self.userDefaults = userDefaults
        self.icon = icon
        _updateKeyValuePairs()
    }
    
    
    let id: String
    
    let name: String
    
    var keyValuePairs: [KeyValuePair] = []
    
    var keyValues: [String : KeyValuePair] {
        didSet {
            _updateKeyValuePairs()
        }
    }
    
    let userDefaults: UserDefaults
    
    let icon: NSImage
    
}

extension KeyValueStore: Equatable {
    
    static func ==(lhs: KeyValueStore, rhs: KeyValueStore) -> Bool {
        return lhs.id == rhs.id
    }
    
}

extension KeyValueStore: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
extension KeyValueStore {
    
    static var global: KeyValueStore? {
        guard let emptyDomain = UserDefaults.init(suiteName: _systemGlobalEmptyStoreIdentifier)
        else { return nil }
        
        let dictionary = emptyDomain.dictionaryRepresentation()
        return KeyValueStore.keyValueStore(with: dictionary,
                                           identifier: globalKeyValueStoreIdentifier,
                                           name: LocalizedString.global,
                                           userDefaults: emptyDomain,
                                           icon: NSImage.init(named: NSImage.computerName)!)
    }
    
    static var runningAppStores: [KeyValueStore] {
        var stores: [KeyValueStore] = []

        let runningApplications = NSWorkspace.shared.runningApplicationsWithBundleIdentifiers
        
        if runningApplications.count > 0 {
            
            for runningApplication in runningApplications {
                if let bundleIdentifier = runningApplication.bundleIdentifier,
                   let store = KeyValueStore.keyValueStore(with: bundleIdentifier,
                                                           name: runningApplication.localizedName,
                                                           icon: runningApplication.icon) {
                    stores.append(store)
                }
            }
        }
        
        return stores
    }
    
    
    static func keyValueStore(with suite: String,
                              name: String? = nil,
                              icon: NSImage?) -> KeyValueStore? {
        
        guard let defaults = UserDefaults.init(suiteName: suite) else { return nil }
        let dictionary = defaults.dictionaryRepresentation()
        return KeyValueStore.keyValueStore(with: dictionary, identifier: suite, name: name ?? suite, userDefaults: defaults, icon: icon ?? NSImage())
    }
    
    static func keyValueStore(with dictionary: [String: Any],
                              identifier: String,
                              name: String,
                              userDefaults: UserDefaults,
                              icon: NSImage) -> KeyValueStore {
        var keyValues: [String: KeyValuePair] = [:]
        //        print("UserDefaults.standard: \(UserDefaults.standard.dictionaryRepresentation())")
        let keys = dictionary.keys
        for key in keys {
            if let value = dictionary[key] {
                //print("\(key): \(value)")
                let dataType = KeyValueStore.dataType(for: value)
                let kvp = KeyValuePair(key: key, dataType: dataType, value: value)
                keyValues[key] = kvp
            }
        }
        
        
        return KeyValueStore(id: identifier, name: name, keyValues: keyValues, userDefaults: userDefaults, icon: icon)
    }
    
    static func dataType(for value: Any) -> DataType {
        switch value {
            case let number as NSNumber:
                return KeyValueStore.dataType(for: number)
                
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
    
    static func dataType(for number: NSNumber) -> DataType {
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
    
    
}

private extension KeyValueStore {
    
    mutating func _updateKeyValuePairs() {
        var pairs: [KeyValuePair] = []
        let keys = keyValues.keys.sorted()
        for key in keys {
            if let kvp = keyValues[key] {
                pairs.append(kvp)
            }
        }
        keyValuePairs = pairs
    }
    
}

extension KeyValueStore {
    
    mutating func removingDuplicateKeys(in keyValueStore: KeyValueStore) {
        for key in keyValueStore.keyValues.keys {
            keyValues.removeValue(forKey: key)
        }
    }
    
}
