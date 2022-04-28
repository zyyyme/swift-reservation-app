//
//  Restaurant.swift
//  reservista
//
//  Created by Владислав Левченко on 03.04.2022.
//

import Foundation


struct Restaurant: Equatable, Codable {
    let id: String
    let name: String
    let description: String
    let address: String
    let price: Int
    let menu: String
    let image: String
    
    struct RestaurantsJSON: Codable {
        var data: [Restaurant]
    }
    
    static func ==(lhs: Restaurant, rhs: Restaurant) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func loadRestaurants(completionHandler: @escaping ([Restaurant], NSError?) -> Void) {
        let url = URL(string: "http://localhost:8000/api/v1/restaurants")!
        let session = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            let jsonDecoder = JSONDecoder()
            do {
                let response = try jsonDecoder.decode(RestaurantsJSON.self, from: data)
                completionHandler(response.data, nil)
                
            } catch {
                print("JSON Decoding error: ", error)
            }
        }
        session.resume()
    }
    
    static func saveRestaurants(_ restaurants: [Restaurant]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedToDos = try? propertyListEncoder.encode(restaurants)
        try? codedToDos?.write(to: archiveURL, options: .noFileProtection)
    }
    
    static func loadSampleRestaurants() -> [Restaurant] {
        let rest1 = Restaurant(id: "6b10t", name: "Classic Brooklyn Pizza", description: "Finest pizza in the whole New York Downtown", address: "Puchkova, 10", price: 3, menu: "google.com", image: "")
        let rest2 = Restaurant(id: "6b12c", name: "Vintage Aged Rome Pizza", description: "Our pizza is at least five hundred years old!", address: "Puchkova, 12", price: 2, menu: "ya.ru", image: "")
        let rest3 = Restaurant(id: "6b092u", name: "Modern Pineapple Pizza", description: "Some may find it awful, but we like our pizza with 2kg of pineapples on it!", address: "Puchkova, 9", price: 3, menu: "yahoo.com", image: "")
        
        return [rest1, rest2, rest3]
    }
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("todos").appendingPathExtension("plist")
}


