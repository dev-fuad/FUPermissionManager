//
//  FUPermissionManager.swift
//  FUPermissions
//
//  Created by Fuad on 21/07/17.
//  Copyright © 2017 Fuad Mohammed Firoz. All rights reserved.
//

import Foundation

class PermissionsManager {
    
    static func isAuthorizedPermission(_ permission: PermissionType) -> Bool {
        let manager = self.getManagerForPermission(permission)
        return manager.isAuthorized()
    }
    
    static func isAuthorizedPermissions(_ permissions: [PermissionType]) -> Bool {
        for permission in permissions {
            if !PermissionsManager.isAuthorizedPermission(permission) {
                return false
            }
        }
        return true
    }
    
    static func getAuthorisationStatus(for permission: PermissionType, completion:@escaping (AuthStatus) -> ()) {
        let manager = self.getManagerForPermission(permission)
        manager.authorisationStatus(completion)
    }
    
    static func requestPermission(_ permission: PermissionType, with completionHandler: @escaping (Bool) -> ()) {
        let manager = self.getManagerForPermission(permission)
        manager.request(withCompletionHandler: { success in
            completionHandler(success)
        })
    }
    
    private static func getManagerForPermission(_ permission: PermissionType) -> PermissionInterface {
        switch permission {
        case .camera:
            return CameraPermission()
        case .photoLibrary:
            return PhotoLibraryPermission()
        case .notification:
            return NotificationPermission()
        case .microphone:
            return MicrophonePermission()
        case .calendar:
            return CalendarPermission()
        case .locationAlways:
            return LocationPermission(type: LocationPermissionType.always)
        case .locationWhenInUse:
            return LocationPermission(type: LocationPermissionType.whenInUse)
        case .locationWithBackground:
            return LocationPermission(type: LocationPermissionType.alwaysWithBackground)
        case .contacts:
            return ContactsPermission()
        case .reminders:
            return RemindersPermission()
        }
    }
}
