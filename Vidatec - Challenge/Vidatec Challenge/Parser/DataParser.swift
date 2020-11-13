//
//  DataParser.swift
//  Vidatec Challenge
//
//  Created by Charlie N on 31/07/2019.
//  Copyright © 2019 Sample. All rights reserved.
//

import Foundation

struct DataParser {
    
    
    /// A Generic parser to serialize JSON data into usbale objects model ojects
    ///
    /// - Parameters:
    ///   - data: the JSON data to parse
    ///   - type: The type to parse into, it MUST conform to the Decodable protocol
    /// - Returns: serialize model object
    /// - Throws: An error if any value throws an error during decoding.
    static func parse<T>(_ data: Data, type: T.Type) throws -> T where T : Decodable {
        let decoder = JSONDecoder()
        
        // For decoding the date
        // API uses on the iso8601 format which not covered by the .iso8601 created by Apple
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        return try decoder.decode(T.self, from: data)
    }
    
    // It is possible to have this code in an extension now you think about it
    // wanted to mix parsing and generics
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
