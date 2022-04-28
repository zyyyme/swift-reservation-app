//
//  User.swift
//  reservista
//
//  Created by Владислав Левченко on 04.04.2022.
//

import Foundation


class User: Equatable, Codable {
    let id: String
    let name: String
    let image: String
    
    static func ==(lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
    
}
