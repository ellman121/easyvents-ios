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
    @State var startTime = Date()
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
                }
                TextField("Description", text: $description)
                    .frame(width: .infinity, height: 300, alignment: .center)
                Section {
                    Button("Create Event") {
                        eventModel.create(Event: Event(
                            name: eventName,
                            startTime: startTime,
                            endTime: endTime,
                            description: description
                        )) { error in
                            if (error == nil) {
                                self.presentationMode.wrappedValue.dismiss()
                                return
                            }
                            
                            print("Erorr uploading event")
                        }
                    }
                }
                
            }
            .navigationTitle("Create a new event")
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
