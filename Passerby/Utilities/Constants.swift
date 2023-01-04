//
//  Constants.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 01. 07..
//

import UIKit

struct Constants {
    
    
    //MARK: - Networking
    
    //The API's base URL
    static let baseUrl = "https://private-beef01-mytasks2.apiary-mock.com/"
    
    
    //The parameters (Queries) that we're gonna use
    struct Parameters {
        static let userId = "userId"
    }
    
    
    //The header fields
    enum HttpHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }
    
    
    //The content type (JSON)
    enum ContentType: String {
        case json = "application/json"
    }
    
    
    //MARK: - General
    
    enum SFSymbols {
        static let alcoholic = UIImage(systemName: "a.square.fill")
    }
    
    
    enum Images {
        static let logo = UIImage(named: "logo")
//        static let emptyStateLogo = UIImage(named: "empty-state")
    }
    
    
    enum ScreenSize {
        static let width        = UIScreen.main.bounds.size.width
        static let height       = UIScreen.main.bounds.size.height
        static let maxLength    = max(ScreenSize.width, ScreenSize.height)
        static let minLength    = min(ScreenSize.width, ScreenSize.height)
    }
    
    
    enum DeviceTypes {
        static let idiom                    = UIDevice.current.userInterfaceIdiom
        static let nativeScale              = UIScreen.main.nativeScale
        static let scale                    = UIScreen.main.scale
        
        static let isiPhoneSE               = idiom == .phone && ScreenSize.maxLength == 568.0
        static let isiPhone8Standard        = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale == scale
        static let isiPhone8Zoomed          = idiom == .phone && ScreenSize.maxLength == 667.0 && nativeScale > scale
        static let isiPhone8PlusStandard    = idiom == .phone && ScreenSize.maxLength == 736.0
        static let isiPhone8PlusZoomed      = idiom == .phone && ScreenSize.maxLength == 736.0 && nativeScale < scale
        static let isiPhoneX                = idiom == .phone && ScreenSize.maxLength == 812.0
        static let isiPhoneXsMaxAndXr       = idiom == .phone && ScreenSize.maxLength == 896.0
        static let isiPad                   = idiom == .pad && ScreenSize.maxLength >= 1024.0
        
        static func isiPhoneXAspectRatio() -> Bool {
            return isiPhoneX || isiPhoneXsMaxAndXr
        }
    }
    
}
