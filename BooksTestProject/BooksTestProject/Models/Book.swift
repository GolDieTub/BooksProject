import UIKit
import Foundation
struct Book {
    let title: String
    let firstPublishedYear: Int?
    let coverImageURL: URL?
    let rating: Double?
    let key: String?
    var description: String?
    
    init(title: String, firstPublishedYear: Int?, coverImageURL: URL?, rating: Double?, key: String?, description: String?) {
            self.title = title
            self.firstPublishedYear = firstPublishedYear
            self.coverImageURL = coverImageURL
            self.rating = rating
            self.key = key
            self.description = description
        }
}

struct BookDescription {
    let key: String
    var description: String
}

struct BookImage {
    let key: String
    let cover: UIImage
}

struct BookData {
    let title: String
    let firstPublishedYear: Int?
    let coverImage: UIImage?
    let rating: Double?
    var description: String?
}
