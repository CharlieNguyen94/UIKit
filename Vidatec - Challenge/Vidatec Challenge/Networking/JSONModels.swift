//
//  JSONModels.swift
//  Vidatec Challenge
//
//  Created by Charlie N on 31/07/2019.
//  Copyright © 2019 Sample. All rights reserved.
//

import Foundation

struct Room: Codable {
    
    var uuid: String
    var createdAt: Date
    var name: String
    var isOccupied: Bool
    
    enum CodingKeys: String, CodingKey {
        case uuid = "id"
        case createdAt
        case name
        case isOccupied
    }
    
}

typealias PersonInfo = (key: String, value: String)

struct Person: Codable {

    var uuid: String
    var createdAt: Date
    var avatar: String
    var jobTitle: String
    var phone: String
    var favouriteColor: String
    var email: String
    var firstName: String
    var lastName: String
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    var reverseName: String {
        return "\(lastName), \(firstName)"
    }
    
    struct InfoKey {
        static let jobTitle = "Job Title"
        static let email = "Email"
        static let phone = "Phone"
    }
    
    var information: [PersonInfo] {
        return [
            (key: InfoKey.jobTitle, value: jobTitle),
            (key: InfoKey.email, value: email),
            (key: InfoKey.phone, value: phone),
        ]
    }
    
    enum CodingKeys: String, CodingKey {
        case uuid = "id"
        case createdAt
        case avatar
        case jobTitle
        case phone
        case favouriteColor
        case email
        case firstName
        case lastName
    }
}
