import SwiftUI
import CoreData

struct PhotoDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    let photo: EditedPhoto
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Photo Display
                if let imageData = photo.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 300)
                        .cornerRadius(12)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                        )
                }
                
                // Details Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Photo Details")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Divider()
                    
                    // Filter Information
                    DetailRow(icon: "camera.filters",
                             title: "Filter",
                             value: photo.filter ?? "None")
                    
                    // Intensity Information
                    DetailRow(icon: "slider.horizontal.3",
                             title: "Intensity",
                             value: String(format: "%.2f", photo.intensity))
                    
                    // Created Date
                    if let createdAt = photo.createdAt {
                        DetailRow(icon: "calendar",
                                 title: "Created",
                                 value: formattedDate(createdAt))
                    }
                    
                    // Photo ID
                    if let id = photo.id {
                        DetailRow(icon: "number",
                                 title: "ID",
                                 value: id.uuidString)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            .padding()
        }
        .navigationTitle("Photo Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: sharePhoto) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func sharePhoto() {
        guard let imageData = photo.imageData,
              let image = UIImage(data: imageData) else { return }
        
        let activityVC = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}
