//
//  EventsList.swift
//  easyvents-ios
//
//  Created by Elliott Rarden on 25.01.23.
//

import SwiftUI
import FirebaseAuth

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
                    Button("Log out") {
                        // Yeah, we can just crash if it fails, not going
                        // to worry about catching this one TBH
                        try! Auth.auth().signOut()
                    }
                }

                ToolbarItem(placement: .primaryAction) {
                    Button("New event") {
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
