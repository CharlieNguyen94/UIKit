//
//  Models.swift
//  FavouriteEvents
//
//  Created by Charlie Nguyen on 02/11/2020.
//

import Foundation

struct Info: Codable {
    var paginations: [Pagination]
    var items: [Item]
}

struct Pagination: Codable {
    var page: Int
    var pageSize: Int
    var total: Int
}

struct Item: Codable {
    var title: String = ""
    var image: String = ""
    var startDate: Int = 0
    
    enum  CodingKeys: String, CodingKey { case title, image, startDate}

        let dateFormatter : DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yy HH:mm:ss"
            return formatter
        }()

        
    

}

