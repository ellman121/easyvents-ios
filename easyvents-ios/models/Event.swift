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
    var invitees: [String]?
}

struct EventLocation: Codable {
    var name: String
    var geoPoint: GeoPoint
}

let eventCollection = "events"
let negative24H = TimeInterval(exactly: -24 * 60 * 60)!

class EventViewModel: ObservableObject {
    private var db = Firestore.firestore()
    
    @Published var events = [Event]()
    @Published var loading = false
    
    func fetchEvents() {
        self.loading = true
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection(eventCollection)
            .whereField("invitees", arrayContains: uid)
            .whereField("startTime", isGreaterThanOrEqualTo: Date(timeIntervalSinceNow: negative24H))
            .order(by: "startTime")
            .addSnapshotListener { querySnapshot, error in
                self.loading = true
                guard let documents = querySnapshot?.documents else {
                    self.loading = false
                    return
                }
                
                let events = documents
                    .map { $0.toEvent() }
                    .filter { $0.id != "" }
                
                self.loading = false
                self.events = events
            }
    }
    
    func create(Event event: Event, onComplete: (_ error: Error?) -> Void) {
        self.loading = true
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var uploadEvent = event
        uploadEvent.createdBy = uid
        uploadEvent.invitees = [uid]
        
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

extension QueryDocumentSnapshot {
    func toEvent() -> Event {
        do {
            return try self.data(as: Event.self)
        } catch {
            print("ERROR: Failed to convert docSnapshot to Event")
            print(error)
        }
        return Event(id: "", name: "", description: "", startTime: Date(timeIntervalSince1970: 0))
    }
}
