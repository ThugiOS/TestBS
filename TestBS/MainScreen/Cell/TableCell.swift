import UIKit

final class TableCell: UITableViewCell {
    
    static let identifier = "Cell"

     let image: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
     let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        self.contentView.addSubview(image)
        self.contentView.addSubview(label)
        
        self.layer.borderWidth = 10
        self.layer.borderColor = UIColor.systemBackground.cgColor
        self.layer.cornerRadius = 30
        self.clipsToBounds = true

        setupConstraints()
    }
    
    private func setupConstraints() {
        image.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            image.heightAnchor.constraint(equalToConstant: 380),
            
            label.centerXAnchor.constraint(equalTo: image.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: image.bottomAnchor, constant: -30)
        ])
    }
    
    override func prepareForReuse() {
        image.image = nil
    }
}
