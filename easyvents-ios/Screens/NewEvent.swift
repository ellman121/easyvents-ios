//
//  NewEvent.swift
//  easyvents-ios
//
//  Created by Elliott Rarden on 04.02.23.
//

import SwiftUI
import MapKit
import FirebaseFirestore
import SwiftLocation

struct NewEvent: View {
    @ObservedObject var eventModel = EventViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var eventName = ""
    @State var startTime = Date(timeIntervalSinceNow: 100)
    @State var endTime: Date? = nil
    @State var description = ""
    @State var location: EventLocation? = nil
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        TextField("Event name", text: $eventName)
                        DatePicker("Start time", selection: $startTime)
                        DatePicker("End time", selection: Binding<Date>(get: {self.endTime ?? Date()}, set: {self.endTime = $0}))
                            .opacity(endTime != nil ? 1 : 0.2)
                            .foregroundColor(endTime != nil && endTime! < startTime ? .red : .primary)
                        NavigationLink {
                            LocationSearch(selectedLocation: Binding<EventLocation>(get: {self.location ?? EventLocation(name: "", geoPoint: GeoPoint(latitude: 0, longitude: 0))}, set: {self.location = $0}))
                        } label: {
                            Label(location?.name ?? "Select a location", systemImage: "location")
                        }
                        
                    }
                    TextField("Event Description", text: $description, axis: .vertical)
                        .lineLimit(1...8)
                }
                
                Button("Create Event") {
                    eventModel.create(Event: Event(
                        name: eventName,
                        description: description,
                        startTime: startTime,
                        endTime: endTime,
                        location: location
                    )) { error in
                        if (error != nil) {
                            print("Erorr uploading event")
                            return
                        }
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                .padding()
                .disabled(
                    eventName == "" ||
                    startTime < Date(timeIntervalSinceNow: 0) ||
                    description == "" ||
                    (endTime != nil && endTime! < startTime))
            }
            .navigationTitle("New event")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .cancel) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct NewEvent_Previews: PreviewProvider {
    static var previews: some View {
        NewEvent()
    }
}
