//
//  AddEditTableViewControllerDelegate.swift
//  Address Book
//
//  Created by Wayne Hill on 7/3/17.
//  Copyright © 2017 Surfside Software Solution. All rights reserved.
//

import UIKit

class AddEditTableViewControllerDelegate: UIViewController 
{

  private let fieldNames = ["firstName","lastName","email",
                            "phone","street","city","state","zip"]
  
  var delegate = AddEditViewController?.self
//  var contact = Event // Contact to add or edit
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
  
  /*
  // MARK: - Navigation
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) 
  {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
  }
  */

}
