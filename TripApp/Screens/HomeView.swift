// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio
import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var trips: [TripModel]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(trips) { trip in
                        NavigationLink {
                            DaysAndActivitiesView(trip: trip)
                        } label: {
                            Image(uiImage: trip.viewImage)
                                .resizable()
                                .scaledToFill()
                                .clipShape(.rect(cornerRadius: 20))
                                .frame(height: 200)
                                .overlay(alignment: .bottom) {
                                    VStack {
                                        Text(trip.name)
                                            .font(.largeTitle.weight(.heavy).width(.condensed))
                                        Text("\(trip.days.count) Days")
                                    }
                                    .foregroundStyle(Color.white)
                                    .padding(.horizontal, 4)
                                    .background {
                                        Color.black.opacity(0.3)
                                            .blur(radius: 8)
                                    }
                                    .padding(.bottom, 8)
                                }
                                .shadow(radius: 4)
                                .padding()
                        }
                    }
                }
            }
            .navigationTitle("Adventures")
            .headerProminence(.increased)
            .scrollContentBackground(.hidden)
            .background(.regularMaterial)
            .background {
                Image("TravelApp")
                    .opacity(0.5)
                    .blur(radius: 48)
            }
            .toolbar {
                Button("", systemImage: "plus") {
                    modelContext.insert(TripModel(name: "New Advanture"))
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(TripModel.preview)
}
