//
//  AppDelegate.swift
//  TestBS
//
//  Created by Никитин Артем on 25.09.23.
//

import UIKit
import SnapKit

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
        contentView.addSubview(image)
        contentView.addSubview(label)
        
        layer.borderWidth = 10
        layer.borderColor = UIColor.systemBackground.cgColor
        layer.cornerRadius = 30
        clipsToBounds = true

        setupConstraints()
    }
    
    private func setupConstraints() {
        image.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.height.equalTo(380)
        }
        
        label.snp.makeConstraints { make in
            make.centerX.equalTo(image)
            make.bottom.equalTo(image).offset(-30)
        }
    }
    
    override func prepareForReuse() {
        image.image = nil
    }
}
