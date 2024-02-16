// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio

import SwiftUI

@main
struct TripAppApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .modelContainer(TripModel.preview)
        }
    }
}
