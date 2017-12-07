//
//  ViewController.swift
//  FUPermissionManager
//
//  Created by Fuad on 21/07/17.
//  Copyright © 2017 Fuad. All rights reserved.
//

import UIKit

typealias Permission = (name: String, icon: UIImage, type: PermissionType, message: String?)

/// Array to use as a data source for collection view
var permissions: [Permission] = [
    (
        name: "Notification",
        icon: #imageLiteral(resourceName: "icn_notif"),
        type: PermissionType.notification,
        message: "Notificatiosnss mesafgawf"),
    (
        name: "Location",
        icon: #imageLiteral(resourceName: "icn_location"),
        type: PermissionType.locationWhenInUse,
        message: Bundle.main.infoDictionary?["NSLocationWhenInUseUsageDescription"] as? String),
    (
        name: "PhotoLibrary",
        icon: #imageLiteral(resourceName: "icn_photo"),
        type: PermissionType.photoLibrary,
        message: Bundle.main.infoDictionary?["NSPhotoLibraryUsageDescription"] as? String),
    (
        name: "Camera",
        icon: #imageLiteral(resourceName: "icn_camera"),
        type: PermissionType.camera,
        message: Bundle.main.infoDictionary?["NSCameraUsageDescription"] as? String),
    (
        name: "Calender",
        icon: #imageLiteral(resourceName: "calender"),
        type: PermissionType.calendar,
        message: Bundle.main.infoDictionary?["NSCalendarsUsageDescription"] as? String),
    (
        name: "Contacts",
        icon: #imageLiteral(resourceName: "icn_contacts"),
        type: PermissionType.contacts,
        message: Bundle.main.infoDictionary?["NSContactsUsageDescription"] as? String),
    (
        name: "Microphone",
        icon: #imageLiteral(resourceName: "icn_notif"),
        type: PermissionType.microphone,
        message: Bundle.main.infoDictionary?["NSMicrophoneUsageDescription"] as? String)
]

class ViewController: UIViewController {

    //MARK:- IBOutlet
    //MARK:-

    @IBOutlet var viewContainer: UIView!
    @IBOutlet var collection: UICollectionView!
    
    //MARK:- Variable
    //MARK:-
    
    var zoomViews: [UIView] = []
    
    var selectedIndex = -1
    let listColors = [#colorLiteral(red: 0.1803921569, green: 0.2392156863, blue: 0.4235294118, alpha: 1), #colorLiteral(red: 0.5764705882, green: 0.3294117647, blue: 0.6156862745, alpha: 1), #colorLiteral(red: 0.9137254902, green: 0.4509803922, blue: 0.7803921569, alpha: 1), #colorLiteral(red: 0.431372549, green: 0.6431372549, blue: 0.9294117647, alpha: 1), #colorLiteral(red: 0.1803921569, green: 0.2392156863, blue: 0.4235294118, alpha: 1), #colorLiteral(red: 0.5764705882, green: 0.3294117647, blue: 0.6156862745, alpha: 1), #colorLiteral(red: 0.9137254902, green: 0.4509803922, blue: 0.7803921569, alpha: 1)]
    
    //MARK:- View Methods
    //MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- IBAction Methods
    //MARK:-
    
    @IBAction func actionEnableAll(_ sender: UIButton) {
        
        PermissionsManager.requestPermission(.notification) { success in
            PermissionsManager.requestPermission(.camera) { success in
                PermissionsManager.requestPermission(.photoLibrary) { success in
                    PermissionsManager.requestPermission(.locationWhenInUse) { success in
                        PermissionsManager.requestPermission(.calendar) { success in
                            PermissionsManager.requestPermission(.contacts) { success in
                                print("done now reload view")
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func actionClose(_ sender: UIButton) {
        
        // dismiss(animated: true, completion: nil) or to the next controller
    }
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return permissions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PermissionCell", for: indexPath) as! PermissionCell
        
        cell.configure(
            primaryColor: listColors[indexPath.row],
            permission: permissions[indexPath.row],
            scope: self
        )
        
        if indexPath.row == selectedIndex {
            zoom(cell)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width * 0.8, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = selectedIndex == -1 ? indexPath.row : -1

        guard let cell = collectionView.cellForItem(at: indexPath) as? PermissionCell else {
            return
        }
        
        zoom(cell)
    }
    
    func enableClicked(_ sender: UIButton) {
        
        if sender.tag < 0 || sender.tag > permissions.count {
            return
        }
        
        PermissionsManager.requestPermission(permissions[sender.tag].type) { success in
            if !success {
                let alert = UIAlertController(title: "Authorisaion Denied",
                                              message: "Go to Settings to change the authorisation",
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Settings", style: .default) { (action) -> Void in
                    
                    if let url = URL(string:UIApplicationOpenSettingsURLString) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: [:])
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                })
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                    
                })
                
                self.present(alert, animated: true, completion: nil)
            } else {
                self.collection.reloadData()
            }
        }
    }
    
    func zoom(_ cell: PermissionCell) {
        let backGroundView = UIControl(frame: view.bounds)
        backGroundView.backgroundColor = UIColor(white: 1, alpha: 0.7)
        backGroundView.alpha = 0
        backGroundView.addTarget(self, action: #selector(dismissZoom(_:)), for: .touchUpInside)
        view.addSubview(backGroundView)
        zoomViews.append(backGroundView)
        
        let widthConstant = min(view.bounds.width, view.bounds.height) * 0.9
        let iconSize = widthConstant * 0.45
        
        let containerView = UIView(frame: collection.convert(cell.frame, to: self.view))
        containerView.frame.size.height = cell.contentView.subviews.first!.frame.size.height
        containerView.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.9568627451, blue: 0.9921568627, alpha: 1)
        view.addSubview(containerView)
        zoomViews.append(containerView)
        
        let iconImage = UIImageView(frame: cell.icon.frame)
        iconImage.contentMode = .center
        iconImage.tintColor = cell.icon.tintColor
        iconImage.backgroundColor = cell.icon.backgroundColor
        iconImage.image = cell.icon.image
        containerView.addSubview(iconImage)
        zoomViews.append(iconImage)
        
        let titleLabel = UILabel(frame: cell.name.frame)
        titleLabel.text = cell.name.text
        titleLabel.textColor = cell.name.textColor
        titleLabel.textAlignment = .center
        titleLabel.font = cell.name.font
        containerView.addSubview(titleLabel)
        zoomViews.append(titleLabel)
        
        let messageLabel = UILabel(frame: cell.message.frame)
        messageLabel.numberOfLines = 0
        messageLabel.text = cell.message.text
        messageLabel.textColor = cell.message.textColor
        messageLabel.textAlignment = .center
        messageLabel.font = cell.message.font
        containerView.addSubview(messageLabel)
        zoomViews.append(messageLabel)
        
        let actionButton = UIButton(frame: cell.action.frame)
        actionButton.setTitle(cell.action.titleLabel?.text, for: .normal)
        actionButton.setTitleColor(cell.action.titleLabel?.textColor, for: .normal)
        actionButton.titleLabel?.font = cell.action.titleLabel?.font
        containerView.addSubview(actionButton)
        zoomViews.append(actionButton)
        
        UIView.animate(withDuration: 0.2) { 
            backGroundView.alpha = 1
            containerView.frame.size = CGSize(width: widthConstant, height: widthConstant)
            containerView.center = self.view.center
            
            iconImage.frame = CGRect(
                x: 5,
                y: 5,
                width: iconSize,
                height: iconSize)
            iconImage.center.x = containerView.bounds.midX
            
            titleLabel.frame = CGRect(
                x: 5,
                y: iconSize + 10,
                width: widthConstant - 10,
                height: 30)
            
            messageLabel.frame = CGRect(
                x: 5,
                y: iconSize + 45,
                width: widthConstant - 10,
                height: (widthConstant - (iconSize + 95)))
            
            actionButton.frame = CGRect(
                x: 5,
                y: (widthConstant - 50),
                width: widthConstant - 10,
                height: 40)
        }
    }
    
    func dismissZoom(_ sender: UIControl) {
        let cell = collection.cellForItem(at: IndexPath(item: self.selectedIndex, section: 0)) as! PermissionCell
        selectedIndex = -1
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: { 
            self.zoomViews[0].alpha = 0
            self.zoomViews[1].frame = self.collection.convert(cell.frame, to: self.view)
            self.zoomViews[1].frame.size.height = cell.contentView.subviews.first!.frame.size.height
            
            self.zoomViews[2].frame = cell.icon.frame
            self.zoomViews[3].frame = cell.name.frame
            self.zoomViews[4].frame = cell.message.frame
            self.zoomViews[5].frame = cell.action.frame
        }) { (completed) in
            for zoomView in self.zoomViews {
                if zoomView.superview != nil {
                    zoomView.removeFromSuperview()
                }
            }
            self.zoomViews.removeAll()
        }
        
    }
}

class PermissionCell: UICollectionViewCell {
    
    @IBOutlet var icon: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var message: UILabel!
    @IBOutlet var action: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configure(primaryColor: UIColor, permission: Permission, scope: UIViewController) {
        icon.backgroundColor = primaryColor
        icon.image = permission.icon
        action.tag = permissions.index(where: { $0.type == permission.type }) ?? -1
        action.setTitleColor(primaryColor, for: .normal)
        name.text = permission.name
        name.textColor = primaryColor
        message.text = permission.message
        action.isEnabled = !PermissionsManager.isAuthorizedPermission(permission.type)
        action.addTarget(scope, action: #selector(ViewController.enableClicked(_:)), for: .touchUpInside)
    }
}

