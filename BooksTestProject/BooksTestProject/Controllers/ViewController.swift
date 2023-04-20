import UIKit

class ViewController: UIViewController {
    
    
    private let apiWork = APIwork()
    var books = [Book]()
    var descriptionOfBooks = [BookDescription]()
    var booksWithDescriptions = [Book]()
    var booksWithImages = [BookImage]()
    var bookDataArray = [BookData]()
    
    let tableView: UITableView = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadings()
        
     
    }
        
    func loadings(){
        apiWork.fetchBooks { [weak self] books, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let books = books {
                self?.books = books
                var descriptionStruct: [BookDescription] = []
                var imageStruct: [BookImage] = []
                let group = DispatchGroup()
                
                for book in books {
                    group.enter()
                    self?.apiWork.fetchBookDescription(key: book.key!) { [weak self] description, error in
                        if let error = error {
                            print("Error: \(error.localizedDescription)")
                        } else if let description = description {
                            var bookDescription = description
                            
                            bookDescription.description = (self?.apiWork.transfareDescription(text: description.description))!
                            descriptionStruct.append(bookDescription)
                        }
                        group.leave()
                    }
                    
                    group.enter()
                    
                    if book.coverImageURL != nil{
                        self?.apiWork.getImageFromUrl(url: book.coverImageURL!) { image, error in
                            if let error = error {
                                print("Error: \(error.localizedDescription)")
                            } else if let image = image {
                                let bookImage = BookImage(key: book.key!, cover: image)
                                imageStruct.append(bookImage)
                            }
                            group.leave()
                        }
                    } else {
                        group.leave()
                    }
                }
                
                group.notify(queue: DispatchQueue.main) {
                    self?.descriptionOfBooks = descriptionStruct
                    self?.booksWithImages = imageStruct
                    self?.splitThemUp()
                    self?.setUpTableView()
                    self?.tableView.register(BookTableViewCell.self, forCellReuseIdentifier: "BookTableViewCell")
                    self?.tableView.dataSource = self
                    self?.tableView.delegate = self
                }
            }
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let book = bookDataArray[indexPath.row]
        let detailVC = DetailViewController(book: book)
        present(detailVC, animated: true)
    }
    
    func splitThemUp() {
            for book in books {
                let matchingDescription = descriptionOfBooks.first { $0.key == book.key }
                let matchingImage = booksWithImages.first { $0.key == book.key }
                let bookData = BookData(title: book.title,
                                        firstPublishedYear: book.firstPublishedYear,
                                        coverImage: matchingImage?.cover,
                                        rating: book.rating,
                                        description: matchingDescription?.description ?? "No Description")
                self.bookDataArray.append(bookData)
            }

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 190 
        }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

}

extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bookDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath) as? BookTableViewCell
        else { fatalError()  }
        
        cell.configure(book: bookDataArray[indexPath.row])
        
        return cell
    }
    
}

extension ViewController:UITableViewDelegate{
    
}



extension ViewController{
    func setUpTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
