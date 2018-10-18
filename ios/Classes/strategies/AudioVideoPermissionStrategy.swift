//
//  AudioVideoPermissions.swift
//  permission_handler
//
//  Created by Maurits van Beusekom on 26/07/2018.
//
import AVFoundation
import Foundation

class AudioVideoPermissionStrategy : NSObject, PermissionStrategy {
    
    func checkPermissionStatus(permission: PermissionGroup) -> PermissionStatus {
        if permission == PermissionGroup.camera {
            return AudioVideoPermissionStrategy.getPermissionStatus(mediaType: AVMediaTypeVideo as AVMediaType)
        } else if permission == PermissionGroup.microphone {
            return AudioVideoPermissionStrategy.getPermissionStatus(mediaType: AVMediaTypeAudio as AVMediaType)
        }
        
        return PermissionStatus.unknown
    }
    
    private static func getPermissionStatus(mediaType: AVMediaType) -> PermissionStatus {
        let status: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: mediaType as String)
        
        switch status {
        case AVAuthorizationStatus.authorized:
            return PermissionStatus.granted
        case AVAuthorizationStatus.denied:
            return PermissionStatus.denied
        case AVAuthorizationStatus.restricted:
            return PermissionStatus.restricted
        default:
            return PermissionStatus.unknown
        }
    }
    
    func requestPermission(permission: PermissionGroup, completionHandler: @escaping PermissionStatusHandler) {
        let permissionStatus = checkPermissionStatus(permission: permission)
        
        if permissionStatus != PermissionStatus.unknown {
            completionHandler(permissionStatus)
            return
        }
        
        var mediaType: AVMediaType
        
        if permission == PermissionGroup.camera {
            mediaType = AVMediaTypeVideo as AVMediaType
        } else if permission == PermissionGroup.microphone {
            mediaType = AVMediaTypeAudio as AVMediaType
        } else {
            completionHandler(PermissionStatus.unknown)
            return
        }
        
        AVCaptureDevice.requestAccess(forMediaType: mediaType as String, completionHandler: {
            (granted: Bool) in
            if granted {
                completionHandler(PermissionStatus.granted)
            } else {
                completionHandler(PermissionStatus.denied)
            }
        })
    }
}
