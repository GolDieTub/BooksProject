import UIKit
class DetailViewController: UIViewController {

    let singleBook: BookData

    let titleLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textAlignment = .center
            label.numberOfLines = 0
            return label
        }()
        
        let yearLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16)
            label.textAlignment = .center
            return label
        }()
        
        let ratingLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16)
            label.textAlignment = .center
            return label
        }()
        
        let descriptionLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16)
            label.numberOfLines = 0
            return label
        }()
        
        let bookImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            return imageView
        }()
    
        init(book: BookData) {
            self.singleBook = book
            super.init(nibName: nil, bundle: nil)
        }
    

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewDidLoad() {
            super.viewDidLoad()

            view.backgroundColor = .white
            
            titleLabel.text = singleBook.title
            if let year = singleBook.firstPublishedYear {
                yearLabel.text = "Year: \(year)"
            } else {
                yearLabel.text = "Year: Unknown"
            }
            if let rating = singleBook.rating {
                ratingLabel.text = "Rating:\(round(rating * 100) / 100)"
            } else {
                ratingLabel.text = "Rating: No data"
            }
            descriptionLabel.text = singleBook.description?.description ?? "No Description"
            bookImageView.image = singleBook.coverImage
            
            view.addSubview(titleLabel)
            view.addSubview(yearLabel)
            view.addSubview(ratingLabel)
            view.addSubview(descriptionLabel)
            view.addSubview(bookImageView)
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
            
            yearLabel.translatesAutoresizingMaskIntoConstraints = false
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
            yearLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            yearLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
            
            ratingLabel.translatesAutoresizingMaskIntoConstraints = false
            ratingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
            ratingLabel.leadingAnchor.constraint(equalTo: yearLabel.trailingAnchor, constant: 16).isActive = true
            ratingLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
            
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            descriptionLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 16).isActive = true
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
            
            bookImageView.translatesAutoresizingMaskIntoConstraints = false
            bookImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16).isActive = true
            bookImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
            bookImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
            bookImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        }


}
