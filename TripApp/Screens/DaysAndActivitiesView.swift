// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio
import SwiftData
import SwiftUI

struct DaysAndActivitiesView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var trip: TripModel
    @State private var edit = false
    @State private var refreshList = false
    
    var sortedDays: [DayModel] {
        trip.days.sorted {
            $0.dayNumber < $1.dayNumber
        }
    }
    
    var body: some View {
        List {
            if edit {
                Section("Trip Details") {
                    TextField("trip name", text: $trip.name)
                }
            }
            
            ForEach(sortedDays) { day in
                if edit {
                    @Bindable var day = day
                    VStack {
                        TextField("day name", text: $day.name)
                            .bold()
                        Stepper(value: $day.dayNumber) {
                            Image(systemName: "\(day.dayNumber).square")
                                .font(.title2)
                        }
                    }
                } else {
                    Section {
                        ForEach(day.activities.sorted { $0.activityNumber < $1.activityNumber }) { activity in
                            NavigationLink {
                                ActivityView(activity: activity)
                            } label: {
                                HStack {
                                    Image(uiImage: activity.viewImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .clipShape(.rect(cornerRadius: 8))
                                        .shadow(radius: 2)
                                    VStack(alignment: .leading) {
                                        Text(activity.name)
                                            .font(.title.weight(.bold).width(.condensed))
                                    }
                                }
                            }
                        }
                        .listRowBackground(Color.primary.opacity(0.05))
                    } header: {
                        HStack {
                            Text(day.name)
                            Spacer()
                            Button {
                                let activityNumber = day.activities.count + 1
                                day.activities.append(ActivityModel(name: "Activity \(activityNumber)", activityNumber: activityNumber))
                            } label: {
                                Image(systemName: "plus.square")
                                    .font(.title3)
                            }
                        }
                    }
                }
            }
            .onDelete(perform: edit ? deleteDay : nil)
        }
        .id(refreshList)
        .headerProminence(.increased)
        .scrollContentBackground(.hidden)
        .background(.regularMaterial)
        .background {
            Image(uiImage: trip.viewImage)
                .opacity(0.5)
        }
        .navigationTitle(trip.name)
        .toolbar {
            Button("", systemImage: "plus") {
                let dayNumber = trip.days.count + 1
                let day = DayModel(name: "Day \(dayNumber)", dayNumber: dayNumber)
                // Warning: Preview crashes when adding new day.
                trip.days.append(day)
            }
            Button(edit ? "Done" : "Edit") {
                edit.toggle()
            }
        }
        .onAppear {
            // There's a bug where when models are deleted, Lists are not updating. This is a workaround when you delete an activity and come back to this list.
            refreshList.toggle()
        }
    }
    
    func deleteDay(indexSet: IndexSet) {
        for index in indexSet {
            modelContext.delete(sortedDays[index])
        }
    }
}

#Preview {
    let container = TripModel.preview
    let trip = try! container.mainContext.fetch(FetchDescriptor<TripModel>())
    
    return NavigationStack {
        DaysAndActivitiesView(trip: trip[0])
            .modelContainer(TripModel.preview)
    }
}
