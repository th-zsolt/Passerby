//
//  ApiClient.swift
//  Passerby
//
//  Created by Zsolt Toth on 2023. 01. 08..
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

class ApiClient {
    
    static func getTasks(userId: String) -> Observable<TaskItemResult> {
        return request(ApiRouter.getTasks(userId: userId))
    }
    
    //-------------------------------------------------------------------------------------------------
    //MARK: - The request function to get results in an Observable
    private static func request<T: Codable> (_ urlConvertible: URLRequestConvertible) -> Observable<T> {

            return Observable<T>.create { observer in

                let request = AF.request(urlConvertible).responseDecodable { (response: AFDataResponse<T>) in

                    switch response.result {
                    case .success(let value):

                        observer.onNext(value)
                        observer.onCompleted()
                    case .failure(let error):

                        switch response.response?.statusCode {
                        case 403:
                            observer.onError(ApiError.forbidden)
                        case 404:
                            observer.onError(ApiError.notFound)
                        case 409:
                            observer.onError(ApiError.conflict)
                        case 500:
                            observer.onError(ApiError.internalServerError)
                        default:
                            observer.onError(error)
                        }
                    }
                }
                
                return Disposables.create {
                    request.cancel()
                }
            }
        }
    }
