//
//  PhotoCell.swift
//  RxSwift-programming
//
//  Created by czw on 12/2/19.
//  Copyright © 2019 czw. All rights reserved.
//

import UIKit
import SnapKit

class PhotoCell: UICollectionViewCell {

  lazy var imageView = {
    return UIImageView.init(image: UIImage(named: "IMG_1907"))
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(imageView)
    imageView.snp.makeConstraints { (make) in
      make.edges.equalTo(contentView)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
