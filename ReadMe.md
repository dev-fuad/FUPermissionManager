# FU Permission Manager by Fuad Mohammed Firoz
A permission manager to easily manage the iOS permissions.

Permissions managed:  
 1. Notification
 2. Camera
 3. Photo Library
 4. Location
 5. Contacts
 6. Calendar
 7. Microphone
 8. Reminders

### Usage

1. Request Permission
```
PermissionsManager.requestPermission(.camera) {
    success in 
    ...
}
```

2. Check Permission
```
let isPermitted: Bool = PermissionsManager.isAuthorizedPermission(permission.type)
```

### Data Structures

```
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
```


`Enjoy!`