//
//  ImageCollageViewController.swift
//  RxSwift-programming
//
//  Created by czw on 12/2/19.
//  Copyright © 2019 czw. All rights reserved.
//

import UIKit

class ImageCollageViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var clearButton: UIButton!
  @IBOutlet weak var saveButton: UIButton!
  
  lazy var rightItem = {
    return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Combinestagram"
    
    navigationItem.rightBarButtonItem = rightItem
  }
  
  @objc func add() {
    print(#function)
    let photosViewController = storyboard!.instantiateViewController(
      withIdentifier: "PhotosViewController") as! PhotosViewController
    
    navigationController!.pushViewController(photosViewController, animated: true)
  }
  
  @IBAction func clear(_ sender: Any) {
    
  }
  
  @IBAction func save(_ sender: Any) {
    
  }
}
