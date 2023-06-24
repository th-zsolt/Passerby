//
//  ErrorHelper.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 07. 11..
//

import Foundation

enum ErrorHelper {
    
    static func parseErroMessage(error: Error) -> String {
        let errorMessage : String
        switch error {
        case ApiError.conflict:
            errorMessage = "Conflict error"
        case ApiError.forbidden:
            errorMessage = "Forbidden error"
        case ApiError.notFound:
            errorMessage = "Not found error"
        case ApiError.internalServerError:
            errorMessage = "Internal server error"
        default:
            errorMessage = error.localizedDescription
        }
        return errorMessage
    }
}
