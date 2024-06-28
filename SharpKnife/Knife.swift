import Foundation
import UIKit

struct Knife: Codable {
    var date: String
    var type: String
    var name: String
    var imagePath: String?

    init(date: String, type: String, name: String, image: UIImage?) {
        self.date = date
        self.type = type
        self.name = name
        if let image = image {
            self.imagePath = saveImageToFileSystem(image)
        }
    }

    // Save image to the file system and return the file path
    private func saveImageToFileSystem(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 1.0) else { return nil }
        let filename = UUID().uuidString + ".jpg"
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
        do {
            try data.write(to: url)
            return filename
        } catch {
            print("Failed to save image to file system: \(error)")
            return nil
        }
    }

    // Load image from the file system
    func loadImage() -> UIImage? {
        guard let imagePath = imagePath else { return nil }
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(imagePath)
        return UIImage(contentsOfFile: url.path)
    }
}
