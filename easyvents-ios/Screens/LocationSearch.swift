//
//  LocationSearch.swift
//  easyvents-ios
//
//  Created by Elliott Rarden on 10.02.23.
//

import SwiftUI
import SwiftLocation
import FirebaseFirestore
import CoreLocation

struct LocationResult: Identifiable {
    var id: Int
    var name: String?
    var coordinates: CLLocationCoordinate2D?
}

struct LocationSearch: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedLocation: EventLocation
    
    @State var locationResults: [LocationResult] = []
    @State private var query = ""
    @State private var loading = true
    
    var body: some View {
        List {
            ForEach(locationResults) { location in
                Button(location.name ?? "") {
                    selectedLocation = EventLocation(name: location.name ?? "Some Location", geoPoint: GeoPoint(latitude: location.coordinates!.latitude, longitude: location.coordinates!.longitude))
                    dismiss.callAsFunction()
                }
            }
        }.searchable(text: $query)
            .onAppear {
                loading = false
            }
            .onChange(of: query, perform: { newValue in
                if !query.isEmpty {
                    SwiftLocation.autocompleteWith(Autocomplete.Apple(detailsFor: newValue)).then { results in
                        switch results {
                        case .success(let foundLocations):
                            locationResults = foundLocations.map { location in
                                let placeName = location.place?.info.first(where: { key, _ in
                                    key == .name
                                })?.value
                                return LocationResult(id: location.place?.info.hashValue ?? 0, name: placeName, coordinates: location.place?.coordinates)
                            }
                            
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            })
            .navigationTitle("Location Search")
    }
}

struct LocationSearch_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearch(selectedLocation: Binding<EventLocation>(get: {EventLocation(name: "hello", geoPoint: GeoPoint(latitude: 0, longitude: 0))}, set: {$0}))
    }
}
