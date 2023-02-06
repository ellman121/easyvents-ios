//
//  NewEvent.swift
//  easyvents-ios
//
//  Created by Elliott Rarden on 04.02.23.
//

import SwiftUI

struct NewEvent: View {
    @ObservedObject var eventModel = EventViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var eventName = ""
    @State var startTime = Date(timeIntervalSinceNow: 100)
    @State var endTime: Date? = nil
    @State var description = ""
    
    var body: some View {
        
        NavigationView {
            Form {
                Section {
                    TextField("Event name", text: $eventName)
                    DatePicker("Start time", selection: $startTime)
                    DatePicker("End time", selection: Binding<Date>(get: {self.endTime ?? Date()}, set: {self.endTime = $0}))
                        .opacity(endTime != nil ? 1 : 0.2)
                        .foregroundColor(endTime != nil && endTime! < startTime ? .red : .primary)
                }
                TextField("Event Description", text: $description, axis: .vertical)
                    .lineLimit(3...8)
                Section {
                    Button("Create Event") {
                        eventModel.create(Event: Event(
                            name: eventName,
                            startTime: startTime,
                            endTime: endTime,
                            description: description
                        )) { error in
                            if (error != nil) {
                                print("Erorr uploading event")
                                return
                            }
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .disabled(
                        eventName == "" ||
                        startTime < Date(timeIntervalSinceNow: 0) ||
                        description == "" ||
                        (endTime != nil && endTime! < startTime))
                }
                
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
