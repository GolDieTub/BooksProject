import UIKit
import Foundation
class APIwork{
    
    func fetchBookDescription(key: String, completion: @escaping (BookDescription?, Error?) -> Void) {
        let urlString = "https://openlibrary.org/\(key).json"
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                if let description = json["description"] {
                    if let descriptionString = description as? String,
                       let key = json["key"] as? String{
                        let descrp = BookDescription(key: key, description: descriptionString)
                        completion(descrp, nil)
                    } else if let descriptionObject = description as? [String: Any],
                              let descriptionValue = descriptionObject["value"] as? String,
                              let key = json["key"] as? String {
                        let descrp = BookDescription(key: key, description: descriptionValue)
                        completion(descrp, nil)
                    } else {
                        completion(nil, NSError(domain: "org.openlibrary", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid description"]))
                    }
                } else {
                    completion(nil, NSError(domain: "org.openlibrary", code: 2, userInfo: [NSLocalizedDescriptionKey: "Book not found in JSON"]))
                }
            } catch {
                completion(nil, error)
            }
        }.resume()
    }


    func getImageFromUrl(url: URL, completion: @escaping (UIImage?, Error?) -> Void) {

        let cache = NSCache<NSURL, UIImage>()
        if let imageFromCache = cache.object(forKey: url as NSURL) {
            completion(imageFromCache, nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            DispatchQueue.main.async {
                guard let imageToCache = UIImage(data: data) else {
                    completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create image from data"]))
                    return
                }
                cache.setObject(imageToCache, forKey: url as NSURL)
                completion(imageToCache, nil)
            }
        }.resume()
    }


func fetchBooks(completion: @escaping ([Book]?, Error?) -> Void) {
    var mainBooks: [Book] = []
    let url = URL(string: "https://openlibrary.org/search.json?q=harry+potter&language=eng&limit=15&offset=1")!
    let session = URLSession.shared
    let task = session.dataTask(with: url) { data, response, error in
        guard error == nil else {
            completion(nil, error)
            return
        }
        guard let data = data else {
            completion(nil, NSError(domain: "org.openlibrary", code: 1, userInfo: [NSLocalizedDescriptionKey: "No data received"]))
            return
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            guard let docs = json?["docs"] as? [[String: Any]] else {
                return
            }
            
            for doc in docs {
                if let title = doc["title"] as? String{
                   let firstPublishedYear = doc["first_publish_year"] as? Int
                   let coverImageURLString = doc["cover_i"] as?  Int
                   let key = doc["key"] as? String
                   let rating = doc["ratings_average"] as? Double
                    let coverImageURL = URL(string: "https://covers.openlibrary.org/b/id/\(coverImageURLString ?? 0)-L.jpg")
                    let book = Book(title: title, firstPublishedYear: firstPublishedYear, coverImageURL: coverImageURL, rating: rating, key: key, description: nil)
                    mainBooks.append(book)
                } else {
                    completion(nil, NSError(domain: "org.openlibrary", code: 2, userInfo: [NSLocalizedDescriptionKey: "Book not found in JSON"]))
                }
            }
            completion(mainBooks, nil)
        } catch {
            completion(nil, error)
        }
    }
    task.resume()
}

    func getImageFromUrl(urlString: String, completion: @escaping (UIImage?, Error?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            
            DispatchQueue.main.async {
                completion(UIImage(data: data), nil)
            }
        }.resume()
    }


    func transfareDescription(text: String) -> String{

        let cleanedText = text.replacingOccurrences(of: "\t", with: "")
                .replacingOccurrences(of: "\n", with: " ")
                .replacingOccurrences(of: "\r", with: "")
                .replacingOccurrences(of: "jkrowling", with: " ")
            let stopCharacters = ["-", "(", "[source]", "/", "\\", "_", "jkrowling"]
        let sentences = cleanedText.components(separatedBy: ".")
                .filter { sentence in
                    !stopCharacters.contains { stop in
                        let stopIndex = sentence.range(of: stop)?.lowerBound
                        return stopIndex != nil
                    }
                }
            let result = sentences.joined(separator: ".").trimmingCharacters(in: .whitespacesAndNewlines) + " "
            
        return result
    }
}
    
    
