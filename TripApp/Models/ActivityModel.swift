// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio
import Foundation
import MapKit
import SwiftData
import SwiftUI
import UIKit

@Model
class ActivityModel {
    var name: String
    var activityNumber: Int = 0
    var location: String = ""
    var latitude: Double = 0
    var longitude: Double = 0
    var notes: String = ""
    var day: DayModel?
    var image: Data?
    
    init(name: String, activityNumber: Int = 0, location: String = "", latitude: Double = 0.0, longitude: Double = 0.0, notes: String = "", day: DayModel? = nil, image: Data? = nil) {
        self.name = name
        self.activityNumber = activityNumber
        self.location = location
        self.latitude = latitude
        self.longitude = longitude
        self.notes = notes
        self.day = day
        self.image = image
    }
}

extension ActivityModel {
    var viewImage: UIImage {
        if let image {
            UIImage(data: image) ?? UIImage(resource: .unknownActivity)
        } else {
            UIImage(resource: .unknownActivity)
        }
    }
    
    var viewMapPosition: MapCameraPosition {
        if latitude == 0 && longitude == 0 {
            return MapCameraPosition.region(
                // Center on the Americas and zoom out
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: 0.0, longitude: -80.0),
                    span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)
                )
            )
        } else {
            return MapCameraPosition.region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            )
        }
    }
}
