//
//  EventDetail.swift
//  easyvents-ios
//
//  Created by Elliott Rarden on 25.01.23.
//

import SwiftUI

struct EventDetail: View {
    var event: Event
    
    var body: some View {
        Text(event.name)
    }
}

struct EventDetail_Previews: PreviewProvider {
    static var previews: some View {
        EventDetail(event: Event(id: "id123", name: "Preview Event", description: "Some event description.  The event will take place on a certain day at a certain time.  The people who are invited are X, Y, and Z", startTime: Date(timeIntervalSinceNow: 10000)))
    }
}
