// Copyright © 2024 Big Mountain Studio. All rights reserved. Twitter: @BigMtnStudio
import PhotosUI
import SwiftData
import SwiftUI
import MapKit

struct ActivityView: View {
    @Bindable var activity: ActivityModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var edit = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var openMap = false
    
    var body: some View {
        Form {
            Section {
                if edit {
                    TextField("activity name", text: $activity.name)
                    Stepper(value: $activity.activityNumber) {
                        Image(systemName: "\(activity.activityNumber).square")
                            .font(.title2)
                    }
                    HStack {
                        TextField("location", text: $activity.location)
                        Button {
                            openMap.toggle()
                        } label: {
                            Image(systemName: "mappin.square.fill")
                                .font(.title)
                        }
                    }
                    TextField("notes", text: $activity.notes, axis: .vertical)
                    if let imageData = activity.image {
                        Image(uiImage: UIImage(data: imageData) ?? UIImage())
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .hidden()
                            .listRowBackground(Image(uiImage: activity.viewImage).resizable())
                            .overlay {
                                PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                                    Image(systemName: "photo.artframe.circle")
                                        .font(.system(size: 100))
                                        .padding(4)
                                        .background(.ultraThickMaterial.opacity(0.8), in: Circle())
                                }
                            }
                    } else {
                        PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                            Text("Add a Photo")
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                        .frame(maxWidth: .infinity)
                    }
                } else {
                    Text(activity.name)
                        .font(.title)
                    Text("Activity Number: \(activity.activityNumber)")
                    HStack {
                        Text("Location: \(activity.location)")
                            Spacer()
                        Button {
                            openMap.toggle()
                        } label: {
                            Image(systemName: "mappin.square.fill")
                                .font(.title)
                        }
                    }
                    Text("Notes: \(activity.notes)")
                    
                    if let imageData = activity.image {
                        Image(uiImage: UIImage(data: imageData) ?? UIImage())
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .hidden()
                            .listRowBackground(Image(uiImage: activity.viewImage).resizable())
                    }
                }
            }
            .listRowBackground(Color.primary.opacity(0.05))
            
            Button {
                modelContext.delete(activity)
                try? modelContext.save()
                dismiss()
            } label: {
                Text("Delete")
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
            .listRowBackground(Color.red)
        }
        .scrollContentBackground(.hidden)
        .background(.regularMaterial)
        .background {
            Image(uiImage: activity.viewImage)
                .opacity(0.5)
        }
        .navigationTitle(activity.day?.name ?? "Activity")
        .toolbar {
            Button(edit ? "Done" : "Edit") {
                if edit {
                    dismiss()
                } else {
                    withAnimation {
                        edit.toggle()
                    }
                }
            }
        }
        .task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                activity.image = data
            }
        }
        .sheet(isPresented: $openMap) {
            LocationPickerView(activity: activity)
        }
    }
}

#Preview {
    let container = TripModel.preview
    let activity = try! container.mainContext.fetch(FetchDescriptor<TripModel>())[0].days[0].activities[0]
    
    return NavigationStack {
        ActivityView(activity: activity)
    }
}
