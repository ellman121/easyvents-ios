//
//  Event.swift
//  easyvents-ios
//
//  Created by Elliott Rarden on 23.01.23.
//

import Foundation

struct Event: Hashable, Codable {
    var id: String
    var name: String
    var startTime: Date
    var endTime: Date?
    var description: String
}

//extension Event {
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.id = try container.decode(String.self, forKey: .id)
//        self.name = try container.decode(String.self, forKey: .name)
//        self.description = try container.decode(String.self, forKey: .description)
//        
//        if let startTimeDouble = try? container.decode(Double.self, forKey: .startTime) {
//            self.startTime = Date(timeIntervalSince1970: startTimeDouble)
//        } else {
//            throw DecodingError.dataCorruptedError(forKey: .startTime, in: container, debugDescription: "Invalid Start Time")
//        }
//        
//        if let endTimeDouble = try? container.decodeIfPresent(Double.self, forKey: .endTime) {
//            self.endTime = Date(timeIntervalSince1970: endTimeDouble)
//        }
//    }
//}
