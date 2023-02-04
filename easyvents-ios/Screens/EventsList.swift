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
    @ObservedObject var eventModel = EventViewModel()
    @State var showCreateModal = false
    
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
            .sheet(isPresented: $showCreateModal) {
                NewEvent()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Log Out") {
                        // Yeah, we can just crash if it fails, not going
                        // to worry about catching this one TBH
                        try! Auth.auth().signOut()
                    }
                }

                ToolbarItem(placement: .primaryAction) {
                    Button("New Event") {
                        self.showCreateModal = true
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
