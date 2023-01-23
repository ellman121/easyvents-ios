//
//  ContentView.swift
//  easyvents-ios
//
//  Created by Elliott Rarden on 23.01.23.
//

import SwiftUI

let someJson = """
{ "id": "12345", "name": "some json event", "startTime": 1674480949000, "endTime": "hello world", "description": "created via decoding" }
"""

let someEvent = Event(id: "some event", name: "some event", startTime: Date(timeIntervalSince1970: 123456789), description: "Some event happening sometime")

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Button("Click Me") {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .millisecondsSince1970
                
                do {
                    let newEvent = try decoder.decode(Event.self, from: someJson.data(using: .ascii)!)
                    print(newEvent)
                } catch {
                    print(error)
                }
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
