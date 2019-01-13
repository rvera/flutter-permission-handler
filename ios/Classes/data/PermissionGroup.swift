//
//  PermissionGroup.swift
//  permission_handler
//
//  Created by Maurits van Beusekom on 25/07/2018.
//

import Foundation

enum PermissionGroup : String, Codable {
    case location = "location"
    case locationAlways = "locationAlways"
    case locationWhenInUse = "locationWhenInUse"
}
