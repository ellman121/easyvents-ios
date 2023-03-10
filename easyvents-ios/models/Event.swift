//
//  Event.swift
//  easyvents-ios
//
//  Created by Elliott Rarden on 23.01.23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Event: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var description: String
    var startTime: Date
    var endTime: Date?
    var createdBy: String?
    var location: EventLocation?
}

struct EventLocation: Codable {
    var name: String
    var geoPoint: GeoPoint
}

let eventCollection = "events"

class EventViewModel: ObservableObject {
    @Published var events = [Event]()
    @Published var loading = false
    private var db = Firestore.firestore()
    
    func fetchEvents() {
        self.loading = true
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection(eventCollection)
            .whereField("createdBy", isEqualTo: uid)
            .order(by: "startTime")
            .addSnapshotListener { querySnapshot, error in
                self.loading = true
                guard let documents = querySnapshot?.documents else {
                    print("ERROR: no events found for user")
                    self.loading = false
                    return
                }
                
                let events = documents.map { docSnapshot -> Event in
                    do {
                        return try docSnapshot.data(as: Event.self)
                    } catch {
                        print("ERROR: Failed to convert docSnapshot to Event")
                        print(error)
                    }
                    return Event(id: "", name: "", description: "", startTime: Date(timeIntervalSince1970: 0))
                }.filter { $0.id != "" } // Filter out failed events
                self.loading = false
                self.events = events
            }
    }
    
    func create(Event event: Event, onComplete: (_ error: Error?) -> Void) {
        self.loading = true
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var uploadEvent = event
        uploadEvent.createdBy = uid
        
        do {
            try db.collection(eventCollection).document().setData(from: uploadEvent)
            self.loading = false
            onComplete(nil)
        } catch {
            self.loading = false
            onComplete(error)
        }
    }
}
