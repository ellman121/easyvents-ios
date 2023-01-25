//
//  Event.swift
//  easyvents-ios
//
//  Created by Elliott Rarden on 23.01.23.
//

import Foundation

struct Event: Hashable, Codable, Identifiable {
    var id: String
    var name: String
    var startTime: Date
    var endTime: Date?
    var description: String
}

enum EventLoadingError: Error {
    case Non200Response
}

func loadEvents() async throws -> Array<Event> {
    let url = URL(string: "https://elliottrarden.me/assets/events.json")!
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200 else {
        throw EventLoadingError.Non200Response
    }
    
    return try JSONDecoder().decode(Array<Event>.self, from: data)
}
