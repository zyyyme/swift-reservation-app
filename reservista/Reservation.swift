//
//  Reservation.swift
//  reservista
//
//  Created by Владислав Левченко on 03.04.2022.
//

import Foundation

//
//  Reservation.swift
//  reservista
//
//  Created by Владислав Левченко on 03.04.2022.
//

import Foundation


struct Reservation: Equatable, Codable {
    let restaurant: Restaurant
    let date: String
    let people: String
    
    static func ==(lhs: Reservation, rhs: Reservation) -> Bool {
        return lhs.date == rhs.date
    }
    
    struct ReservationsJSON: Codable {
        let data: [Reservation]
    }
    
    static func loadReservations(completionHandler: @escaping ([Reservation], NSError?) -> Void) {
        let url = URL(string: "http://localhost:8000/api/v1/reservations/\(Constants().userId)")!
        let session = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            let jsonDecoder = JSONDecoder()
            do {
                let response = try jsonDecoder.decode(ReservationsJSON.self, from: data)
                completionHandler(response.data, nil)
                
            } catch {
                print("JSON Decoding error: ", error)
            }
        }
        session.resume()
    }
    
    static func saveReservations(_ Reservations: [Reservation]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedToDos = try? propertyListEncoder.encode(Reservations)
        try? codedToDos?.write(to: archiveURL, options: .noFileProtection)
    }
    
    
    static func loadSampleReservations() -> [Reservation] {
        let rest1 = Restaurant(id: "6b10t", name: "Classic Brooklyn Pizza", description: "Finest pizza in the whole New York Downtown", address: "Puchkova, 10", price: 3, menu: "google.com", image: "")
        let rest2 = Restaurant(id: "6b12c", name: "Vintage Aged Rome Pizza", description: "Our pizza is at least five hundred years old!", address: "Puchkova, 12", price: 2, menu: "ya.ru", image: "")
        let rest3 = Restaurant(id: "6b092u", name: "Modern Pineapple Pizza", description: "Some may find it awful, but we like our pizza with 2kg of pineapples on it!", address: "Puchkova, 9", price: 3, menu: "yahoo.com", image: "")
        
        let reserve1 = Reservation(restaurant: rest1, date: "10 Apr, 17.00", people: "2-3")
        let reserve2 = Reservation(restaurant: rest2, date: "11 Apr, 16.00", people: "1-2")
        let reserve3 = Reservation(restaurant: rest3, date: "15 Apr, 15.00", people: "8+")
        
        return [reserve1, reserve2, reserve3]
    }
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("todos").appendingPathExtension("plist")
}

