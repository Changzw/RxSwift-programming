//
//  TimeBasedOperatorsViewController.swift
//  RxSwift-programming
//
//  Created by czw on 12/6/19.
//  Copyright © 2019 czw. All rights reserved.
//

import UIKit

let id = "reuseIdentifier"
class TimeBasedOperatorsViewController: UITableViewController {
  
  let chapters: [String] = [
    "buffer",
    "delay",
    "replay",
    "timeout",
    "window",
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: id)
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return chapters.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
    cell.textLabel?.text = chapters[indexPath.row]
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let vc = OperatorViewController(type: chapters[indexPath.row])
    navigationController?.pushViewController(vc, animated: true)
  }
}
