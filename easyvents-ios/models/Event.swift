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
    var location: String?
}

class EventViewModel: ObservableObject {
    @Published var events = [Event]()
    @Published var loading = false
    private var db = Firestore.firestore()
    
    func fetchEvents() {
        self.loading = true
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("events")
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
                        print("ERROR: Couldn't parse doc snapshot into Event")
                        print(error)
                    }
                    return Event(name: "Fake Event", description: "Error parsing event", startTime: Date(timeIntervalSince1970: 0))
                }
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
            try db.collection("events").document().setData(from: uploadEvent)
            onComplete(nil)
        } catch {
            onComplete(error)
        }
    }
}
