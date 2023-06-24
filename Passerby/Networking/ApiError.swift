//
//  ApiError.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 01. 08..
//

import Foundation


enum ApiError: Error {
    case forbidden            //Status code 403
    case notFound             //Status code 404
    case conflict             //Status code 409
    case internalServerError  //Status code 500
}
