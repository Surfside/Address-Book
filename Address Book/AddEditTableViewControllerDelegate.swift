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
  
  // called by AddEditViewController after a contact is added
  func didSaveContact(controller: AddEditTableViewController)
  {
    //get NSManagedObjectContext and insert new contact into it
    let context = self.fetchedResultsController.managedObjectContext
    context.insertObject(controller.contact!)
    self.navigationController?.popToRootViewController(animated: true)

    // save the contexty to store the new contact
    var error: NSError? = nil
    if !context.save(&error)
      { // check for error
        displayError(error, title: "Error Saving Data", message: "Unable to save contact")
      }
    else
      {
        // if no error, display new contat details
        let sectionInfo = self.fetchedResultsController.sections![0] as NSFetchedResultsSectionInfo
        if let row = find(sectionInfo.objects as [NSManagedObject], controller.contact!)
        {
          let path = NSIndexPath(forRow: row, inSection: 0 )
          tableView.selectRowAtIndexPath(path, animated: true, scrollPosition: .Middle)
          performSegue(withIdentifier: "showContactDetail", sender: nil)
        }

     }

  }
  

  // MARK: - Navigation
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) 
  {
      // Get the new view controller using segue.destinationViewController.
      if segue.identifier == "showEditContact"
      {
         let controller = (segue.destination as! UINavigationController).topViewController as! AddEditTableViewController
        controller.naviagationItem.title = "Edit Contact"
        controller.delegate = self
        controller.editingContrat = true
        controller.contact = detailItem
        controller.navigationItem.leftBarButtonItem = self.splitViewCongroller?.displayModeButtonItem()
        controllerr.navigationitem.leftItemsSupplementBackButton = true

      }

    // Pass the selected object to the new view controller.
  }

}
