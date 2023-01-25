//
//  EventsList.swift
//  easyvents-ios
//
//  Created by Elliott Rarden on 25.01.23.
//

import SwiftUI

let events = [
    Event(id: "Event ID 1", name: "Event Name 1", startTime: Date(timeIntervalSince1970: 123456789), description: "Some event description"),
    Event(id: "Event ID 2", name: "Event Name 2", startTime: Date(timeIntervalSince1970: 123456789), description: "Some event description"),
    Event(id: "Event ID 3", name: "Event Name 3", startTime: Date(timeIntervalSince1970: 123456789), description: "Some event description")
]

struct EventsList: View {
    var body: some View {
        NavigationView {
            List(events) { event in
                NavigationLink {
                    EventDetail(event: event)
                } label: {
                    EventRow(event: event)
                }
            }.navigationTitle("Events")
        }
    }
}

struct EventsList_Previews: PreviewProvider {
    static var previews: some View {
        EventsList()
    }
}
