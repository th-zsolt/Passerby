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
        return Observable.of(User(userId: "14",
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
                                    TeamUser(userId: "14", userName: "Teszt Elek"),
                                    TeamUser(userId: "15", userName: "Kecskés Kincső"),
                                    TeamUser(userId: "16", userName: "Szalma József Benedek")
                                    ]))
    }
    
    
    static func createTask(newTask: NewTask)-> Observable<String> {
        //For the ApiRouter:
        let encoder = JSONEncoder()
        
        if let encoded = try? encoder.encode(newTask) {
            print(String(data: encoded, encoding: .utf8)!)
        }

        return Observable.of("1234")
    }
    
    
    static func modifyTask(taskItem: TaskItem)-> Observable<String> {
        //For the ApiRouter:
        let encoder = JSONEncoder()
        
        if let encoded = try? encoder.encode(taskItem) {
            print(String(data: encoded, encoding: .utf8)!)
        }

        return Observable.of("1")
    }
    
    
    static func getTask(taskId: String) -> Observable<TaskItem> {
        return Observable.of(TaskItem(taskId: "1",
                                      taskName: "Test ticket",
                                      taskPrio: 3,
                                      taskWeight: 3,
                                      creationDate: "2022-10-31",
                                      modifiedDate: "2022-03-05",
                                      creator: "Teszt Elek",
                                      creatorId: "14",
                                      assigned: "Kecskés Kincső",
                                      assignedId: "15",
                                      description: "Main task",
                                      state: 3)
        )
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
