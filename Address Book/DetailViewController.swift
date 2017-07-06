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

  @IBOutlet weak var detailDescriptionLabel: UILabel!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var phoneTextField: UITextField!
  @IBOutlet weak var streetTextField: UITextField!
  @IBOutlet weak var cityTextField: UITextField!
  @IBOutlet weak var stateTextField: UITextField!
  @IBOutlet weak var zipTextField: UITextField!

  var delegate: DetailViewControllerDelegate!
  var detailItem: Contact!

  func configureView() 
  {
    // Update the user interface for the detail item.
    if let detail = self.detailItem 
    {

        if let label = self.detailDescriptionLabel 
        {
            label.text = detail.timestamp!.description
        }

    }
  }

  override func viewDidLoad() 
  {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    if detailItem != nil {
      displayContact()
    }
//    self.configureView()
  }

  func displayContact()
  {
    self.navigationItem.title = detailItem.firstname + " " + detailItem.lastname

    // display other attributes if they have values
    emailTextField = detailItem.email?
    phoneTextField = detailItem.phone?
    streetTextField = detailItem.street?
    cityTextField = detailItem.city?
    stateTextField = detailItem.state?
    zipTextField = detailItem.zip?
  }

  override func didReceiveMemoryWarning() 
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // called by DetailViewController after a contact is edited
  func didEditContact(controller: DetailViewController)
  {
    let context = self.fetchedResultsController.managedObjectContext
    var error: NSError? = nil
    if !context.save(&error)
    {
      displayError(error: error, title: "Error Saving Data", message: "Unable to save contact")
    }
  }

  // indicate tht an error occurred when saving database changes
  func displayError(error: NSError?, title: String, message: String)
  {
    let alertController = UIAlertController(title: title, message: String(format: "%@\nError:\(error)\n", message), preferredStyle: UIAlertControllerStyle.alert)
    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
    alertController.addAction(okAction)
    present(alertController, animated: true, completion: nil)
  }

  var detailItem: Contact?
  {
    didSet 
    {
        // Update the view.
        self.configureView()
    }
  }

}

