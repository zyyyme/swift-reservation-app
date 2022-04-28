//
//  ReservationController.swift
//  reservista
//
//  Created by Владислав Левченко on 14.04.2022.
//

import Foundation

class LoginError: LocalizedError {
    var title: String?
    var code: Int

    public var errorDescription: String? {
            return NSLocalizedString(_description, comment: "")
        }
        public var failureReason: String? {
            return NSLocalizedString(_description, comment: "")
        }
        public var recoverySuggestion: String? {
            return NSLocalizedString(_description, comment: "")
        }
    
    private var _description: String

    init(title: String?, description: String, code: Int) {
            self.title = title ?? "Error"
            self._description = description
            self.code = code
        }
    
    
}


class ReservationController {
    static let shared = ReservationController()
    var accessToken: String = ""
    let baseURL = URL(string: "http://localhost:8000/api/v1")!
    
    func fetchRestaurants(completion: @escaping (Result<[Restaurant], Error>) -> Void) {
        let restaurantsURL = baseURL.appendingPathComponent("restaurants/")
        
        let task  = URLSession.shared.dataTask(with: restaurantsURL) { (data, response, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let restaurantsResponse = try jsonDecoder.decode(RestaurantResponse.self, from: data)
                    completion(.success(restaurantsResponse.data))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchReservations(completion: @escaping (Result<[Reservation], Error>) -> Void) {
        let reservationURL = baseURL.appendingPathComponent("reservations/")
        var request = URLRequest(url: reservationURL)
        request.addValue("Bearer " + ReservationController.shared.accessToken, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        let task  = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let reservationResponse = try jsonDecoder.decode(GetReservationResponse.self, from: data)
                    completion(.success(reservationResponse.data))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            } else if let error = error {
                print(error)
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchUser(completion: @escaping (Result<User, Error>) -> Void) {
        let usersURL = baseURL.appendingPathComponent("users/")
        
        var request = URLRequest(url: usersURL)
        request.setValue("Bearer \(ReservationController.shared.accessToken)", forHTTPHeaderField: "Authorization")
        
        let task  = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let userResponse = try jsonDecoder.decode(UserResponse.self, from: data)
                    print(data)
                    completion(.success(userResponse.data))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            } else if let error = error {
                print(error)
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func makeReservation(restaurant: String, date: String, people: String, completion: @escaping (Result<String, Error>) -> Void) {
        let reservationURL = baseURL.appendingPathComponent("reservations/")
        
        var request = URLRequest(url: reservationURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(ReservationController.shared.accessToken)", forHTTPHeaderField: "Authorization")
        let data = ["restaurant_id": restaurant, "date": date, "people": people]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        
        let task  = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let response = try jsonDecoder.decode(MakeReservationResponse.self, from: data)
                    print(response)
                    completion(.success(response.data))
                } catch {
                    print(error)
                    completion(.failure(error))
                }
            } else if let error = error {
                print(error)
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func registerUser(username: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        let registerURL = baseURL.appendingPathComponent("users/")
        
        var request = URLRequest(url: registerURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = ["name": username, "password": password]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        
        let task  = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                do {
                    if response.statusCode != 200 {
                        let jsonDecoder = JSONDecoder()
                        let errorString = try jsonDecoder.decode(ErrorResponse.self, from: data!)
                        let httpError = LoginError(title: "Login Error", description: errorString.detail, code: response.statusCode)
                        completion(.failure(httpError))
                    } else if let data = data {
                        do {
                            let jsonDecoder = JSONDecoder()
                            let userResponse = try jsonDecoder.decode(UserResponse.self, from: data)
                            self.accessToken = userResponse.access_token!
                            completion(.success(userResponse.data))
                        } catch {
                            completion(.failure(error))
                        }
                    } else if let error = error {
                        completion(.failure(error))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    // todo
    func loginUser(username: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        var loginURL = URLComponents(string: baseURL.appendingPathComponent("users/login").absoluteString)!
        loginURL.queryItems = [
            URLQueryItem(name: "name", value: username),
            URLQueryItem(name: "password", value: password)
        ]
        var request = URLRequest(url: loginURL.url!)
        request.httpMethod = "GET"
        
        let task  = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                do {
                    if response.statusCode != 200 {
                        let jsonDecoder = JSONDecoder()
                        let errorString = try jsonDecoder.decode(ErrorResponse.self, from: data!)
                        let httpError = LoginError(title: "Login Error", description: errorString.detail, code: response.statusCode)
                        completion(.failure(httpError))
                    } else if let data = data {
                        do {
                            let jsonDecoder = JSONDecoder()
                            let userResponse = try jsonDecoder.decode(UserResponse.self, from: data)
                            ReservationController.shared.accessToken = userResponse.access_token!
                            completion(.success(userResponse.data))
                        } catch {
                            completion(.failure(error))
                        }
                    } else if let error = error {
                        completion(.failure(error))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
