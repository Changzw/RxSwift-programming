//
//  ContentViewController.swift
//  RxSwift-programming
//
//  Created by czw on 12/2/19.
//  Copyright © 2019 czw. All rights reserved.
//

import UIKit

class ContentViewController: UITableViewController {
//  let leftBarItem = UIBarButtonItem(title: "Test", style: .plain, target: self, action: #selector(test))
  let testButton = UIButton(type: .system)
  let chapters: [String] = [
    "Time based operators",
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem
    
    test()
  }
  
  func setupUI() {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: testButton)
    testButton.setTitle("Test", for: .normal)
    testButton.addTarget(self, action: #selector(test), for: .touchUpInside)
  }
  
//  MARK: Test
  @objc func test() {
    print(#function)
//    observables()
//    subjects()
//    filteringOperators()
//    transformingOperators()
    combiningOperators()
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return chapters.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
    cell.textLabel?.text = chapters[indexPath.row]
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    var vc: UIViewController?
    if indexPath.row == 0 {
      vc = TimeBasedOperatorsViewController()
    }
    
    if let vc = vc {
      navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  /*
   // Override to support conditional editing of the table view.
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the specified item to be editable.
   return true
   }
   */
  
  /*
   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
   if editingStyle == .delete {
   // Delete the row from the data source
   tableView.deleteRows(at: [indexPath], with: .fade)
   } else if editingStyle == .insert {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }
   }
   */
  
  /*
   // Override to support rearranging the table view.
   override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
   
   }
   */
  
  /*
   // Override to support conditional rearranging of the table view.
   override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
