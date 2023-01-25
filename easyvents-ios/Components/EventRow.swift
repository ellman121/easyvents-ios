//
//  EventRow.swift
//  easyvents-ios
//
//  Created by Elliott Rarden on 25.01.23.
//

import SwiftUI

struct EventRow: View {
    var event: Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(event.name)
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(renderDateString(from:event.startTime))
                .font(.callout)
        }
    }
    
    func renderDateString(from date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}

struct EventRow_Previews: PreviewProvider {
    static var previews: some View {
        EventRow(event: Event(id: "Event ID", name: "Event Name", startTime: Date(timeIntervalSince1970: 123456789), description: "Some event description"))
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
