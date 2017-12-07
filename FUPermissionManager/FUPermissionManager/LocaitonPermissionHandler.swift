//
//  LocaitonPermissionHandler.swift
//  FUPermissions
//
//  Created by Fuad on 21/07/17.
//  Copyright © 2017 Fuad Mohammed Firoz. All rights reserved.
//

import Foundation
import MapKit

class RequestPermissionLocationHandler: NSObject, CLLocationManagerDelegate {
    
    lazy var locationManager: CLLocationManager =  {
        return CLLocationManager()
    }()
    
    var completionHandler: ((Bool) -> Void)?
    
    override init() {
        super.init()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if whenInUseNotRealChangeStatus {
            if status == .authorizedWhenInUse {
                return
            }
        }
        
        if status == .notDetermined {
            return
        }
        
        if let complectionHandler = completionHandler {
            complectionHandler(RequestPermissionLocationHandler.isAuthorized())
        }
    }
    
    var whenInUseNotRealChangeStatus: Bool = false
    
    func requestPermission(_ completionHandler: @escaping (Bool) -> Void) {
        fatalError("Must override in subclass")
    }
    
    class func isAuthorized() -> Bool {
        return CLLocationManager.authorizationStatus() == .authorizedAlways
    }
    
    deinit {
        locationManager.delegate = nil
    }
}

class AlwaysAuthorizationHandler: RequestPermissionLocationHandler {
    
    static var shared: AlwaysAuthorizationHandler?
    
    override init() {
        super.init()
    }
    
    override func requestPermission(_ completionHandler: @escaping (Bool) -> Void) {
        self.completionHandler = completionHandler
        
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .notDetermined:
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            self.whenInUseNotRealChangeStatus = true
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
            break
        default:
            completionHandler(RequestPermissionLocationHandler.isAuthorized())
        }
    }
}

class WhenInUseAuthorizationHandler: RequestPermissionLocationHandler {
    
    static var shared: WhenInUseAuthorizationHandler?
    
    override init() {
        super.init()
    }
    
    override func requestPermission(_ completionHandler: @escaping (Bool) -> Void) {
        self.completionHandler = completionHandler
        
        let status = CLLocationManager.authorizationStatus()
        if (status == .notDetermined) || (status == .authorizedAlways) {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        } else {
            completionHandler(RequestPermissionLocationHandler.isAuthorized())
        }
    }
}

class LocationWithBackgroundHandler: AlwaysAuthorizationHandler {
    
    override func requestPermission(_ completionHandler: @escaping (Bool) -> Void) {
        if #available(iOS 9.0, *) {
            locationManager.allowsBackgroundLocationUpdates = true
        }
        super.requestPermission(completionHandler)
    }
}
