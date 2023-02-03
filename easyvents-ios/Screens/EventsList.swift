//
//  EventsList.swift
//  easyvents-ios
//
//  Created by Elliott Rarden on 25.01.23.
//

import SwiftUI
import FirebaseAuth

let events = [
    Event(id: "Event ID 1", name: "Event Name 1", startTime: Date(timeIntervalSince1970: 123456789), description: "Some event description"),
    Event(id: "Event ID 2", name: "Event Name 2", startTime: Date(timeIntervalSince1970: 123456789), description: "Some event description"),
    Event(id: "Event ID 3", name: "Event Name 3", startTime: Date(timeIntervalSince1970: 123456789), description: "Some event description")
]

struct EventsList: View {
    @ObservedObject var eventModel = EventsViewModel()
    
    var body: some View {
        NavigationView {
            List(eventModel.events) { event in
                NavigationLink {
                    EventDetail(event: event)
                } label: {
                    EventRow(event: event)
                }
            }
            .navigationTitle("Events")
            .toolbar {
                Button("Log Out") {
                    do {
                        try Auth.auth().signOut()
                    } catch {
                        
                    }
                }
            }
        }
        .onAppear() {
            self.eventModel.fetchEvents()
        }
    }
}

struct EventsList_Previews: PreviewProvider {
    static var previews: some View {
        EventsList()
    }
}
