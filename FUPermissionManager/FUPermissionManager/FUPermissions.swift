//
//  FUPermissions.swift
//  FUPermissions
//
//  Created by Fuad on 21/07/17.
//  Copyright © 2017 Fuad Mohammed Firoz. All rights reserved.
//

import AVFoundation
import UserNotifications
import Photos
import MapKit
import EventKit
import Contacts

class NotificationPermission: PermissionInterface {
    
    func isAuthorized() -> Bool {
        return UIApplication.shared.currentUserNotificationSettings!.types != []
    }
    
    func request(withCompletionHandler completionHandler: @escaping (Bool)->()?) {
        
            if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
                    if settings.authorizationStatus == .denied {
                        completionHandler(false)
                        return
                    }
                let center = UNUserNotificationCenter.current()
                center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                    DispatchQueue.main.async {
                        completionHandler(true)
                    }
                }
                })
            } // iOS 9 support
            else if #available(iOS 9, *) {
                let notificationType = UIApplication.shared.currentUserNotificationSettings!.types
                if notificationType != []  && !notificationType.contains(UIUserNotificationType.alert) {
                    completionHandler(false)
                    return
                }
                UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
                DispatchQueue.main.async {
                    completionHandler(true)
                }
            }
                // iOS 8 support
            else if #available(iOS 8, *) {
                let notificationType = UIApplication.shared.currentUserNotificationSettings!.types
                if notificationType != []  && !notificationType.contains(UIUserNotificationType.alert) {
                    completionHandler(false)
                    return
                }
                UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
                DispatchQueue.main.async {
                    completionHandler(true)
                }
            }
                // iOS 7 support
            else {
                DispatchQueue.main.async {
                    completionHandler(true)
                }
            }
            UIApplication.shared.registerForRemoteNotifications()
    }
}

class CameraPermission: PermissionInterface {
    
    func isAuthorized() -> Bool {
        return AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == AVAuthorizationStatus.authorized
    }
    
    func request(withCompletionHandler completionHandler: @escaping (Bool)->()?) {
        if AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) == AVAuthorizationStatus.denied {
            completionHandler(false)
            return
        }
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: {
            finished in
            DispatchQueue.main.async {
                completionHandler(true)
            }
        })
    }
}

class PhotoLibraryPermission: PermissionInterface {
    
    func isAuthorized() -> Bool {
        return PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized
    }
    
    func request(withCompletionHandler completionHandler: @escaping (Bool)->()?) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.denied {
            completionHandler(false)
            return
        }
        PHPhotoLibrary.requestAuthorization({
            finished in
            DispatchQueue.main.async {
                completionHandler(true)
            }
        })
    }
}

class LocationPermission: PermissionInterface {
    
    var type: LocationPermissionType
    
    init(type: LocationPermissionType) {
        self.type = type
    }
    
    func isAuthorized() -> Bool {
        
        let status = CLLocationManager.authorizationStatus()
        
        switch self.type {
        case .always:
            return status == .authorizedAlways
        case .whenInUse:
            return status == .authorizedWhenInUse
        case .alwaysWithBackground:
            return status == .authorizedAlways
        }
    }
    
    func request(withCompletionHandler completionHandler: @escaping (Bool) -> ()?) {
        if CLLocationManager.authorizationStatus() == .denied {
            completionHandler(false)
            return
        }
        switch self.type {
        case .always:
            if AlwaysAuthorizationHandler.shared == nil {
                AlwaysAuthorizationHandler.shared = AlwaysAuthorizationHandler()
            }
            
            AlwaysAuthorizationHandler.shared!.requestPermission { (authorized) in
                DispatchQueue.main.async {
                    completionHandler(true)
                    AlwaysAuthorizationHandler.shared = nil
                }
            }
            break
        case .whenInUse:
            if WhenInUseAuthorizationHandler.shared == nil {
                WhenInUseAuthorizationHandler.shared = WhenInUseAuthorizationHandler()
            }
            
            WhenInUseAuthorizationHandler.shared!.requestPermission { (authorized) in
                DispatchQueue.main.async {
                    completionHandler(true)
                    WhenInUseAuthorizationHandler.shared = nil
                }
            }
            break
        case .alwaysWithBackground:
            if LocationWithBackgroundHandler.shared == nil {
                LocationWithBackgroundHandler.shared = LocationWithBackgroundHandler()
            }
            
            LocationWithBackgroundHandler.shared!.requestPermission { (authorized) in
                DispatchQueue.main.async {
                    completionHandler(true)
                    LocationWithBackgroundHandler.shared = nil
                }
            }
            break
        }
    }
}

class CalendarPermission: PermissionInterface {
    
    func isAuthorized() -> Bool {
        return EKEventStore.authorizationStatus(for: EKEntityType.event) == .authorized
    }
    
    func request(withCompletionHandler completionHandler: @escaping (Bool)->()?) {
        if EKEventStore.authorizationStatus(for: EKEntityType.event) == .denied {
            completionHandler(false)
            return
        }
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: Error?) in
            DispatchQueue.main.async {
                completionHandler(true)
            }
        })
    }
}

class ContactsPermission: PermissionInterface {
    
    func isAuthorized() -> Bool {
        if #available(iOS 9.0, *) {
            return CNContactStore.authorizationStatus(for: .contacts) == .authorized
        } else {
            return ABAddressBookGetAuthorizationStatus() == .authorized
        }
        
    }
    
    func request(withCompletionHandler completionHandler: @escaping (Bool)->()?) {
        
        if #available(iOS 9.0, *) {
            if CNContactStore.authorizationStatus(for: .contacts) == .denied {
                completionHandler(false)
                return
            }
            let store = CNContactStore()
            store.requestAccess(for: .contacts, completionHandler: { (granted, error) in
                DispatchQueue.main.async {
                    completionHandler(true)
                }
            })
        } else {
            if ABAddressBookGetAuthorizationStatus() == .denied {
                completionHandler(false)
                return
            }
            let addressBookRef: ABAddressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
            ABAddressBookRequestAccessWithCompletion(addressBookRef) {
                (granted: Bool, error: CFError?) in
                DispatchQueue.main.async() {
                    completionHandler(true)
                }
            }
        }
    }
}

class RemindersPermission: PermissionInterface {
    
    func isAuthorized() -> Bool {
        return EKEventStore.authorizationStatus(for: EKEntityType.reminder) == .authorized
    }
    
    func request(withCompletionHandler completionHandler: @escaping (Bool)->()?) {
        if EKEventStore.authorizationStatus(for: EKEntityType.reminder) == .denied {
            completionHandler(false)
            return
        }
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: EKEntityType.reminder, completion: {
            (accessGranted: Bool, error: Error?) in
            DispatchQueue.main.async {
                completionHandler(true)
            }
        })
    }
}

class MicrophonePermission: PermissionInterface {
    
    func isAuthorized() -> Bool {
        return AVAudioSession.sharedInstance().recordPermission() == .granted
    }
    
    func request(withCompletionHandler completionHandler: @escaping (Bool)->()?) {
        if AVAudioSession.sharedInstance().recordPermission() == .denied {
            completionHandler(false)
            return
        }
        AVAudioSession.sharedInstance().requestRecordPermission {
            granted in
            DispatchQueue.main.async {
                completionHandler(true)
            }
        }
    }
}

