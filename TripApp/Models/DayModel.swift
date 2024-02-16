// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio
import Foundation
import SwiftData

@Model
class DayModel {
    var name: String
    var dayNumber: Int = 0
    var date: Date?
    @Relationship(deleteRule: .cascade, inverse: \ActivityModel.day)
    var activities: [ActivityModel] = []
    var trip: TripModel?
    
    init(name: String, dayNumber: Int = 0, activities: [ActivityModel] = [], trip: TripModel? = nil) {
        self.name = name
        self.dayNumber = dayNumber
        self.activities = activities
        self.trip = trip
    }
}
