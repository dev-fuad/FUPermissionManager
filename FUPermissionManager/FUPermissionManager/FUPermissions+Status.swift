//
//  FUPermissions+Status.swift
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

extension NotificationPermission {
    func authorisationStatus(_ completion: @escaping (AuthStatus) -> ()) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
                switch settings.authorizationStatus {
                case .authorized:
                    completion(.authorized)
                    break
                case .notDetermined:
                    completion(.notDetermined)
                    break
                case .denied:
                    completion(.denied)
                    break
                }
            })
        }
        else  {
            let notificationType = UIApplication.shared.currentUserNotificationSettings!.types
            
            if notificationType == []  {
                completion(.notDetermined)
            }
            else  if !notificationType.contains(UIUserNotificationType.alert) {
                completion(.denied)
            }
            else if notificationType.contains(UIUserNotificationType.alert) {
                completion(.authorized)
            }
        }
    }
}

extension  CameraPermission {
    func authorisationStatus(_ completion: @escaping (AuthStatus) -> ()) {
        switch AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo) {
        case .authorized:
            completion(.authorized)
            break
        case .notDetermined:
            completion(.notDetermined)
            break
        case .denied:
            completion(.denied)
            break
        default:
            completion(.notDetermined)
        }
    }
}

extension  PhotoLibraryPermission {
    func authorisationStatus(_ completion: @escaping (AuthStatus) -> ()) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            completion(.authorized)
            break
        case .notDetermined:
            completion(.notDetermined)
            break
        case .denied:
            completion(.denied)
            break
        default:
            completion(.notDetermined)
        }
    }
}

extension  LocationPermission {
    func authorisationStatus(_ completion: @escaping (AuthStatus) -> ()) {
        switch CLLocationManager.authorizationStatus() {
        case .authorized:
            completion(.authorized)
            break
        case .notDetermined:
            completion(.notDetermined)
            break
        case .denied:
            completion(.denied)
            break
        default:
            completion(.notDetermined)
        }
    }
}

extension  CalendarPermission {
    func authorisationStatus(_ completion: @escaping (AuthStatus) -> ()) {
        switch EKEventStore.authorizationStatus(for: EKEntityType.event) {
        case .authorized:
            completion(.authorized)
            break
        case .notDetermined:
            completion(.notDetermined)
            break
        case .denied:
            completion(.denied)
            break
        default:
            completion(.notDetermined)
        }
    }
}

extension  ContactsPermission {
    func authorisationStatus(_ completion: @escaping (AuthStatus) -> ()) {
        if #available(iOS 9.0, *) {
            switch CNContactStore.authorizationStatus(for: .contacts) {
            case .authorized:
                completion(.authorized)
                break
            case .notDetermined:
                completion(.notDetermined)
                break
            case .denied:
                completion(.denied)
                break
            default:
                completion(.notDetermined)
            }
        } else {
            switch ABAddressBookGetAuthorizationStatus() {
            case .authorized:
                completion(.authorized)
                break
            case .notDetermined:
                completion(.notDetermined)
                break
            case .denied:
                completion(.denied)
                break
            default:
                completion(.notDetermined)
            }
        }
    }
}

extension  RemindersPermission {
    func authorisationStatus(_ completion: @escaping (AuthStatus) -> ()) {
        switch EKEventStore.authorizationStatus(for: EKEntityType.reminder) {
        case .authorized:
            completion(.authorized)
            break
        case .notDetermined:
            completion(.notDetermined)
            break
        case .denied:
            completion(.denied)
            break
        default:
            completion(.notDetermined)
        }
    }
}

extension  MicrophonePermission {
    func authorisationStatus(_ completion: @escaping (AuthStatus) -> ()) {
        switch AVAudioSession.sharedInstance().recordPermission() {
        case AVAudioSessionRecordPermission.granted:
            completion(.authorized)
            break
        case AVAudioSessionRecordPermission.undetermined:
            completion(.notDetermined)
            break
        case AVAudioSessionRecordPermission.denied:
            completion(.denied)
            break
        default:
            completion(.notDetermined)
        }
    }
}
