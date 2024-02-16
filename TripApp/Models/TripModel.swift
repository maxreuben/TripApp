// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import Foundation
import SwiftData
import UIKit

@Model
class TripModel {
    var name: String
    var image: Data?
    var startDate: Date?
    var endDate: Date?
    @Relationship(deleteRule: .cascade, inverse: \DayModel.trip)
    var days: [DayModel]
    
    init(name: String, image: Data? = nil, days: [DayModel] = []) {
        self.name = name
        self.image = image
        self.days = days
    }
}

extension TripModel {
    var viewImage: UIImage {
        if let image {
            UIImage(data: image) ?? UIImage(resource: .newAdventure)
        } else {
            UIImage(resource: .newAdventure)
        }
    }
}

extension TripModel {
    @MainActor
    static var preview: ModelContainer {
        let container = try! ModelContainer(for: TripModel.self,
                                            configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        // Mock Activities
        let activity1 = ActivityModel(name: "Hiking", activityNumber: 1, location: "Mount Mansfield", latitude: 44.5258, longitude: -72.7858, notes: "Bring water and snacks", image: UIImage(resource: .vtMtMansfield).pngData())
        let activity2 = ActivityModel(name: "Picnic", activityNumber: 2, location: "Lake Champlain", latitude: 44.5333, longitude: -73.3333, notes: "Pack a lunch", image: UIImage(resource: .vtLakeChamplain).pngData())
        let activity3 = ActivityModel(name: "Museum Visit", activityNumber: 3, location: "Shelburne Museum", latitude: 44.389759, longitude: -73.231232, notes: "Check exhibit hours", image: UIImage(resource: .vtShelburneMuseum).pngData())
        let activity4 = ActivityModel(name: "Skiing", activityNumber: 1, location: "Stowe Mountain Resort", latitude: 44.5258, longitude: -72.7858, notes: "Rent equipment", image: UIImage(resource: .vtStowe).pngData())
        let activity5 = ActivityModel(name: "Brewery Tour", activityNumber: 1, location: "Magic Hat Brewing Company", latitude: 44.4284050, longitude: -73.2131480, notes: "Must be 21+", image: UIImage(resource: .vtMagicHat).pngData())
        let activity6 = ActivityModel(name: "Boating", activityNumber: 2, location: "Lake Champlain", latitude: 44.5333, longitude: -73.3333, notes: "Rent a boat", image: UIImage(resource: .vtBoating).pngData())
        let activity7 = ActivityModel(name: "Fishing", activityNumber: 1, location: "Winooski River", latitude: 44.256667, longitude: -72.593889, notes: "Bring fishing gear", image: UIImage(resource: .vtFishing).pngData())
        let activity8 = ActivityModel(name: "Cycling", activityNumber: 2, location: "Burlington Bike Path", latitude: 44.4782, longitude: -73.21264, notes: "Rent a bike", image: UIImage(resource: .vtBikePath).pngData())
        let activity9 = ActivityModel(name: "Farm Visit", activityNumber: 1, location: "Shelburne Farms", latitude: 44.389759, longitude: -73.231232, notes: "Check farm hours", image: UIImage(resource: .vtShelburneFarms).pngData())
        let activity10 = ActivityModel(name: "Shopping", activityNumber: 2, location: "Church Street Marketplace", latitude: 44.4782, longitude: -73.21264, notes: "Bring cash", image: UIImage(resource: .vtChurchSt).pngData())

        // Mock Days
        let day1 = DayModel(name: "Day 1", dayNumber: 1, activities: [activity1, activity2, activity3])
        let day2 = DayModel(name: "Day 2", dayNumber: 2, activities: [activity4])
        let day3 = DayModel(name: "Day 3", dayNumber: 3, activities: [activity5, activity6])
        let day4 = DayModel(name: "Day 4", dayNumber: 4, activities: [activity7, activity8])
        let day5 = DayModel(name: "Day 5", dayNumber: 5, activities: [activity9, activity10])
        
        // Mock Trip
        let vermontTrip = TripModel(name: "Vermont Adventure", image: UIImage(resource: .vermont).pngData())
        container.mainContext.insert(vermontTrip)
        vermontTrip.days = [day1, day2, day3, day4, day5]
        
        try? container.mainContext.save()
        
        // Mock Activities
        let utActivity1 = ActivityModel(name: "Boating", location: "Lake Powell", latitude: 37.063969, longitude: -111.236816, notes: "Rent a boat", image: UIImage(resource: .lakePowell).pngData())
        let utActivity2 = ActivityModel(name: "Photography", location: "Monument Valley", latitude: 36.9833, longitude: -110.1000, notes: "Bring a camera", image: UIImage(resource: .monumentValley).pngData())
        let utActivity3 = ActivityModel(name: "Hiking", location: "Zion National Park", latitude: 37.2025, longitude: -112.987777778, notes: "Bring water and snacks", image: UIImage(resource: .zion).pngData())
        let utActivity4 = ActivityModel(name: "Camping", location: "Bryce Canyon National Park", latitude: 37.593048, longitude: -112.187332, notes: "Pack a tent", image: UIImage(resource: .bryce).pngData())
        let utActivity5 = ActivityModel(name: "Skiing", location: "Park City Mountain Resort", latitude: 40.658701, longitude: -111.876183, notes: "Rent equipment", image: UIImage(resource: .parkCity).pngData())
        let utActivity6 = ActivityModel(name: "Museum Visit", location: "Natural History Museum of Utah", latitude: 40.764, longitude: -111.823, notes: "Check exhibit hours", image: UIImage(resource: .utahMuseum).pngData())
        let utActivity7 = ActivityModel(name: "Dining", activityNumber: 2, location: "Downtown Salt Lake City", latitude: 40.764, longitude: -111.823, notes: "Try local cuisine", image: UIImage(resource: .slcDining).pngData())
        let utActivity8 = ActivityModel(name: "Shopping", location: "City Creek Center", latitude: 40.764, longitude: -111.823, notes: "Bring cash", image: UIImage(resource: .slcShopping).pngData())
        let utActivity9 = ActivityModel(name: "Wildlife Viewing", activityNumber: 2, location: "Antelope Island State Park", latitude: 40.95806, longitude: -112.20722, notes: "Bring binoculars", image: UIImage(resource: .antelopeIsland).pngData())

        // Mock Days
        let utDay1 = DayModel(name: "Day 1", dayNumber: 1, activities: [utActivity1])
        let utDay2 = DayModel(name: "Day 2", dayNumber: 2, activities: [utActivity2])
        let utDay3 = DayModel(name: "Day 3", dayNumber: 3, activities: [utActivity3])
        let utDay4 = DayModel(name: "Day 4", dayNumber: 4, activities: [utActivity4])
        let utDay5 = DayModel(name: "Day 5", dayNumber: 5, activities: [utActivity5])
        let utDay6 = DayModel(name: "Day 6", dayNumber: 6, activities: [utActivity6, utActivity7])
        let utDay7 = DayModel(name: "Day 7", dayNumber: 7, activities: [utActivity8, utActivity9])
        
        // Mock Trip
        let utahTrip = TripModel(name: "Utah Adventure", image: UIImage(resource: .utah).pngData())
        container.mainContext.insert(utahTrip)
        utahTrip.days = [utDay1, utDay2, utDay3, utDay4, utDay5, utDay6, utDay7]
        
        try? container.mainContext.save()
        
        return container
    }
}
