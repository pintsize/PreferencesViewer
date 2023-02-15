//
//  KeyValuePair.swift
//  Preferences Viewer
//
//  Created by Jacob Hazelgrove on 2/8/23.
//

import Foundation

enum DataType {
    
    case array
    
    case boolean
    
    case data
    
    case date
    
    case dictionary
    
    case double
    
    case string
    
    case integer
    
    case unknown
}

extension DataType {
    
    var localizedDescription: String {
        switch self {
                
            case .array:
                return "ARRAY"
            case .boolean:
                return "BOOL"
            case .data:
                return "DATA"
            case .date:
                return "DATE"
            case .dictionary:
                return "DICTIONARY"
            case .double:
                return "DOUBLE"
            case .string:
                return "STRING"
            case .integer:
                return "INT"
            case .unknown:
                return "UNKNOWN"
        }
    }
    
}

struct KeyValuePair {
    
    let key: String
    
    let dataType: DataType
    
    let value: Any
    
}
