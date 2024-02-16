// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio
import MapKit
import SwiftData
import SwiftUI

struct LocationPickerView: View {
    @Bindable var activity: ActivityModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        MapReader { mapProxy in
            Map(initialPosition: activity.viewMapPosition)
                .onTapGesture { position in
                    if let coordinate = mapProxy.convert(position, from: .local) {
                        let geocoder = CLGeocoder()
                        geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { placemarks, error in
                            if let placemark = placemarks?.first {
                                activity.location = placemark.name ?? "Unknown location"
                            }
                            activity.latitude = coordinate.latitude
                            activity.longitude = coordinate.longitude
                        }
                    }
                }
        }
        .overlay(alignment: .bottom) {
            VStack {
                Text("Tap map to select a location")
                    .fontWeight(.light)
                HStack {
                    TextField("selected location", text: $activity.location, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                    Button("Done", systemImage: "checkmark") {
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
            .background(.thinMaterial)
        }
    }
}

#Preview {
    let container = TripModel.preview
    let activity = try! container.mainContext.fetch(FetchDescriptor<TripModel>())[0].days[0].activities[0]
    
    return LocationPickerView(activity: activity)
}
