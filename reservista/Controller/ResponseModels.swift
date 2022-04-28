//
//  ResponseModels.swift
//  reservista
//
//  Created by Владислав Левченко on 14.04.2022.
//

import Foundation


struct RestaurantResponse: Codable {
    let data: [Restaurant]
    let total: Int
}


struct GetReservationResponse: Codable {
    let data: [Reservation]
}

struct MakeReservationResponse: Codable {
    let data: String
}

struct UserResponse: Codable {
    let success: Bool?
    let access_token: String?
    let refresh_token: String?
    let data: User
}


struct ErrorResponse: Codable {
    let detail: String
}
