//
//  ParseKeys.swift
//  Game On
//
//  Created by Eduardo Irias on 1/16/17.
//  Copyright © 2017 Game On. All rights reserved.
//

import UIKit

class ParseKeys: NSObject {
    
    static let applicationId = ProcessInfo.processInfo.environment["APP_ID"] ?? ""
    static let clientKey = ProcessInfo.processInfo.environment["CLIENT_KEY"] ?? ""
    static let server = ProcessInfo.processInfo.environment["SERVER_URL"] ?? ""
    
}
