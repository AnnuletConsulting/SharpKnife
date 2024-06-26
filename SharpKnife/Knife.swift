import Foundation
import UIKit

struct Knife: Codable {
    var date: String
    var type: String
    var name: String
    var imageData: Data?

    init(date: String, type: String, name: String, image: UIImage) {
        self.date = date
        self.type = type
        self.name = name
        self.imageData = image.jpegData(compressionQuality: 1.0)
    }
}
