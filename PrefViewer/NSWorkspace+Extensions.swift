//
//  NSWorkspace+Extensions.swift
//  Ally
//
//  Created by Jacob Hazelgrove on 10/15/21.
//

import AppKit

extension NSRunningApplication {
    
    var sortValue: String {
        if let name = localizedName {
            return "\(name)"
        } else if let bundleID = bundleIdentifier {
            return bundleID
        }
        
        // Should never occur when used in conjunction with `runningApplicationsWithBundleIdentifiers`.
        return ""
    }
}

extension NSWorkspace {

    var runningApplicationsWithBundleIdentifiers: [NSRunningApplication] {
        return runningApplications.filter { $0.bundleIdentifier != nil && $0 != NSRunningApplication.current }.sorted { $0.sortValue < $1.sortValue }
    }
    
    var regularRunningApplications: [NSRunningApplication] {
        return runningApplicationsWithBundleIdentifiers.filter { $0.activationPolicy == .regular }.sorted { $0.sortValue < $1.sortValue }
    }
    
    var accessoryRunningApplications: [NSRunningApplication] {
        return runningApplicationsWithBundleIdentifiers.filter { $0.activationPolicy == .accessory }.sorted { $0.sortValue < $1.sortValue }
    }
    
    var prohibitedRunningApplications: [NSRunningApplication] {
        return runningApplicationsWithBundleIdentifiers.filter { $0.activationPolicy == .prohibited }.sorted { $0.sortValue < $1.sortValue }
    }
    
    var runningApplicationMenuItems: [NSMenuItem] {
        var menuItems: [NSMenuItem] = []
        let regularRunningApplications = regularRunningApplications
        let accessoryRunningApplications = accessoryRunningApplications
        //let prohibitedRunningApplications = prohibitedRunningApplications
        
        if !regularRunningApplications.isEmpty {
            menuItems.append(contentsOf: menuItemsFor(regularRunningApplications))
        }
        
        if !accessoryRunningApplications.isEmpty {
            if !menuItems.isEmpty {
                menuItems.append(NSMenuItem.separator())
            }
            menuItems.append(contentsOf: menuItemsFor(accessoryRunningApplications))
        }

        return menuItems
    }
    
    func headerMenuItem(with title: String) -> NSMenuItem {
        let menuItem = NSMenuItem(title: title, action: nil, keyEquivalent: "")
        menuItem.isEnabled = false
        return menuItem
    }
    
    func menuItemsFor(_ runningApplications: [NSRunningApplication]) -> [NSMenuItem] {
        var menuItems: [NSMenuItem] = []
        
        for runningApplication in runningApplications {
            let menuItem = NSMenuItem(title: runningApplication.sortValue, action: nil, keyEquivalent: "")
            //menuItem.indentationLevel = 1
            menuItem.representedObject = runningApplication
            menuItem.image = runningApplication.icon?.resized(to: 16.00)
            menuItems.append(menuItem)
        }
        
        return menuItems
    }
    
}

extension NSImage {
    
    func resized(to height: CGFloat) -> NSImage {
        
        let oldHeight = size.height
        let scaleFactor = height / oldHeight

        let newHeight = oldHeight * scaleFactor
        let newWidth = size.width * scaleFactor
        let newSize = CGSize(width: newWidth, height: newHeight)
        let img = NSImage(size: newSize)

        img.lockFocus()
        defer {
            img.unlockFocus()
        }

        if let ctx = NSGraphicsContext.current {
            ctx.imageInterpolation = .high
            
            draw(in: CGRect(origin: .zero, size: newSize),
                 from: CGRect(origin: .zero, size: size),
                 operation: .copy,
                 fraction: 1.00)
        }

        return img
    }
    
}
