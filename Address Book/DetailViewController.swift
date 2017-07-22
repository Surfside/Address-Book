//
//  DetailViewController.swift
//  Address Book
//
//  Created by Wayne Hill on 6/27/17.
//  Copyright © 2017 Surfside Software Solution. All rights reserved.
//

import CoreData
import UIKit

protocol DetailViewControllerDelegate 
{
  func didEditContact(controller: DetailViewController)
}

class DetailViewController: UIViewController, AddEditTableViewControllerDelegate
{
let showMe = false

  @IBOutlet weak var detailDescriptionLabel: UILabel!
  @IBOutlet weak var firstTextField: UITextField!
  @IBOutlet weak var lastTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var phoneTextField: UITextField!
  @IBOutlet weak var streetTextField: UITextField!
  @IBOutlet weak var cityTextField: UITextField!
  @IBOutlet weak var stateTextField: UITextField!
  @IBOutlet weak var zipTextField: UITextField!

  var delegate: DetailViewControllerDelegate!
  var detailItem: Contact!

   override func viewDidLoad()
   {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
//      self.configureView()
if (showMe) {print("DVC.viewDidLoad")}
      if detailItem != nil
      {
if (showMe) {print("DVC.detailItem not nil")}
        displayContact()
      }

   }

   func displayContact()
   {
if (showMe) {print("DVC.displayContact")}
      // Update the user interface for the detail item.
      if let detail = self.detailItem
      {
if (showMe) {print("DVC.displayContact assign detailItem")}
         if let label = self.detailDescriptionLabel
         {
if (showMe) {print("DVC.update label description")}
label.text = detail.firstname?.description
//            label.text = detail.timestamp!.description
         }
      }

      self.navigationItem.title = detailItem.firstname! + " " + detailItem.lastname!

      // display other attributes if they have values
      firstTextField.text = detailItem?.firstname
      lastTextField.text = detailItem?.lastname
      emailTextField.text = detailItem?.email
      phoneTextField.text = detailItem?.phone
      streetTextField.text = detailItem?.street
      cityTextField.text = detailItem?.city
      stateTextField.text = detailItem?.state
      zipTextField.text = detailItem?.zip
   }

  func didSaveContact(controller: AddEditTableViewController)
  {
if (showMe) {print("DVC.didSaveContact")}
    displayContact() //update contact data on screen
//    self.navigationController?.popViewController(animated: true)
    if let navController = self.navigationController {
if (showMe) {print("DVC.navController.popViewController")}
      navController.popViewController(animated: true)
    }
if (showMe) {print("DVC.delegate.didEditContact")}
    delegate?.didEditContact(controller: self)
  }
  
   //override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
   override func prepare(for segue: UIStoryboardSegue, sender: Any?)
   {
if (showMe) {print("DVC.prepareForSegue")}
      // configure destinationViewConroller for eiting current contact
      if segue.identifier == "showEditContact"
      {
if (showMe) {print(".showEditContact")}
         let controller = (segue.destination as! UINavigationController).topViewController as! AddEditTableViewController
         controller.navigationItem.title = "Edit Contact"
         controller.delegate = self
         controller.editingContact = true
         controller.contact = detailItem
         controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
         controller.navigationItem.leftItemsSupplementBackButton = true
      }
    
   }
}

/*
 
 override func didReceiveMemoryWarning()
 {
 super.didReceiveMemoryWarning()
 // Dispose of any resources that can be recreated.
 if (showMe) {print("DVC.didReceiveMemoryWarning")}
 }
 /*
 // called by DetailViewController after a contact is edited
 func didEditContact(controller: DetailViewController)
 {
 if (showMe) {print("DVC.didEditContact")}
 let context = self.fetchedResultsController.managedObjectContext
 var error: NSError? = nil
 if !context.save(&error)
 {
 displayError(error: error, title: "Error Saving Data", message: "Unable to save contact")
 }
 
 }
 */
 // indicate tht an error occurred when saving database changes
 func displayError(error: NSError?, title: String, message: String)
 {
 if (showMe) {print("DVC.displayError")}
 let alertController = UIAlertController(title: title, message: String(format: "%@\nError:\(error)\n", message), preferredStyle: UIAlertControllerStyle.alert)
 let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
 alertController.addAction(okAction)
 present(alertController, animated: true, completion: nil)
 }
 

func configureView()
{
  /*
   // Update the user interface for the detail item.
   if let detail = self.detailItem
   {
   
   if let label = self.detailDescriptionLabel
   {
   label.text = detail.timestamp!.description
   }
   
   }
   */
}

//  var detailItem: Contact?
//    {
//    didSet
//    {
// Update the view.
//      self.configureView()
//    }
//  }
*/
