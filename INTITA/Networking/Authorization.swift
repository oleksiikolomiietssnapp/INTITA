//
//  Authorization.swift
//  INTITA
//
//  Created by Anastasiia Spiridonova on 01.11.2020.
//

import Foundation

class Authorization {
    
    public static func login(email: String, password: String, completion: @escaping (Error?) -> Void) {
        guard let request = ApiURL.login(email: email, password: password).request
        else { return }
        RequestAPI.request(request: request) { (result: Result<LoginResponse, Error>) in
            switch result {
            case .failure(let error):
                completion(error)
            case .success(let response):
                UserDefaultsManager.addValue(response.token, by: AppConstans.tokenKey)
                completion(nil)
            }
        }
    }
    
    public static func logout(completion: @escaping (Result<LogoutResponse, Error>) -> Void) {
        guard let request = ApiURL.logout.request else { return }
        RequestAPI.request(request: request) { (result: Result<LogoutResponse, Error>) in
            switch result {
            case .success(_):
                UserData.reset()
                fallthrough
            default:
                completion(result)
            }
        }
    }
    
    public static func fetchUserInfo(completion: @escaping (Error?) -> Void) {
        guard let request = ApiURL.currentUser.request else { return }
        RequestAPI.request(request: request) { (result: Result<CurrentUser, Error>) in
            switch result {
            case .success(let user):
                UserData.set(currentUser: user)
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
}
