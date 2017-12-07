//
//  FUDataStructures.swift
//  FUPermissions
//
//  Created by Fuad on 21/07/17.
//  Copyright © 2017 Fuad Mohammed Firoz. All rights reserved.
//

public enum PermissionType {
    case notification
    case camera
    case photoLibrary
    case locationAlways
    case locationWhenInUse
    case locationWithBackground
    case contacts
    case calendar
    case microphone
    case reminders
}

public enum LocationPermissionType {
    case always
    case whenInUse
    case alwaysWithBackground
}

public enum AuthStatus {
    case authorized
    case denied
    case notDetermined
}

public protocol PermissionInterface {
    
    func isAuthorized() -> Bool
    
    func authorisationStatus(_ completion: @escaping (AuthStatus) -> ())
    
    func request(withCompletionHandler completionHandler: @escaping (Bool) -> ()?)
}

extension PermissionInterface {
    func authorisationStatus(_ completion: @escaping (AuthStatus) -> ()) { }
}
