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
    
    static func getUser(loginName: String) -> Observable<User> {
        return Observable.of(User(userId: "1",
                            loginName: "teszt",
                            fullName: "Teszt Elek",
                            teamname: "A-Team",
                            teamId: "1",
                            userTaskID: ["1", "2"],
                            permissions: ["Write", "Edit", "Admin"]))
    }
    
    static func getTeam(teamID: String)-> Observable<Team> {
        return Observable.of(Team(id: "1",
                                  teamUser: [
                                    TeamUser(userId: "10", userName: "Kis János"),
                                    TeamUser(userId: "11", userName: "Tóth Tamás"),
                                    TeamUser(userId: "12", userName: "Kincses Ernő"),
                                    TeamUser(userId: "13", userName: "Szentgyörgyi Aladár"),
                                    TeamUser(userId: "14", userName: "Kisfaludy Szilvia"),
                                    TeamUser(userId: "15", userName: "Kecskés Kincső"),
                                    TeamUser(userId: "16", userName: "Szalma József Benedek")
                                    ]))
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
