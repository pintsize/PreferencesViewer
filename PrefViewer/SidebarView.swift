//
//  SidebarView.swift
//  Preferences Viewer
//
//  Created by Jacob Hazelgrove on 2/9/23.
//

import SwiftUI

enum SidebarItem: Hashable {
    case store(KeyValueStore)
}

struct SidebarView: View {
    //@Binding var selection: SidebarItem?
    
    var global = KeyValueStore.global
    
    var body: some View {
        List() {
            
            if let global = global {
                Section("System") {
                    SidebarRowView(keyValueStore: global)
                }
            }
            
            Section("Apps") {
                ForEach(KeyValueStore.runningAppStores) {
                    SidebarRowView(keyValueStore: $0)
                }
            }
        }
        
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
    }
}

struct SidebarRowView: View {
    let keyValueStore: KeyValueStore
    
    var body: some View {
        HStack() {
            Image(nsImage: keyValueStore.icon)
            Text(keyValueStore.name)
        }
    }
    
}
