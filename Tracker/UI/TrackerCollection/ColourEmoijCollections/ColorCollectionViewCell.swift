//
//  ColorCollectionViewCell.swift
//  Tracker
//
//  Created by Irina Deeva on 08/04/24.
//

import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
    let colorView: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(colorView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        colorView.frame = CGRect(x: (contentView.bounds.width - 40) / 2,
                                 y: (contentView.bounds.height - 40) / 2,
                                 width: 40,
                                 height: 40)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
