//
//  AddEditTableViewControllerDelegate.swift
//  Address Book
//
//  Created by Wayne Hill on 7/3/17.
//  Copyright © 2017 Surfside Software Solution. All rights reserved.
//

import UIKit
import CoreData

class AddEditTableViewControllerDelegate: UIViewController 
{

  private let fieldNames = ["firstname","lastname","email",
                            "phone","street","city","state","zip"]
  
  var delegate = AddEditViewController?.self
  var contact = Contact // Contact to add or edit
  var editingContact = false

  override func viewDidLoad()
  {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning()
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Navigation
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) 
  {
      // Get the new view controller using segue.destinationViewController.
      if segue.identifier == "showEditContact"
      {
         let controller = (segue.destination as! UINavigationController).topViewController as! AddEditTableViewController
        controller.navigationItem.title = "Edit Contact"
        controller.delegate = self
        controller.editingContact = true
        controller.contact = detailItem
        controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
        controller.navigationItem.leftItemsSupplementBackButton = true

      }

    // Pass the selected object to the new view controller.
  }

}
