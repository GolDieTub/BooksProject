import UIKit

class BookTableViewCell: UITableViewCell {

    let cover : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let titleLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    let dateLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .lightGray
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(cover)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame.size.height = 400
        
        titleLabel.frame = CGRect(x: 10, y: 0, width: contentView.frame.size.width - 170, height: 70)
        dateLabel.frame = CGRect(x: 10, y: 60, width: contentView.frame.size.width - 170, height: contentView.frame.size.height/2)
        cover.frame = CGRect(x: contentView.frame.size.width - 130, y: 5, width: 120, height: 180)
        
    }
    
    func configure(book: BookData){
        cover.image = book.coverImage
        titleLabel.text = book.title
        if let year = book.firstPublishedYear {
            dateLabel.text = "\(year)"
        } else {
            dateLabel.text = "Unknown"
        }
    }
    
}
