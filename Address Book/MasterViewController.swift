//
//  MasterViewController.swift
//  Address Book
//
//  Created by Wayne Hill on 6/27/17.
//  Copyright © 2017 Surfside Software Solution. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController,NSFetchedResultsControllerDelegate,  AddEditTableViewControllerDelegate, DetailViewControllerDelegate
{

  //NSFetchedResultsController informs MasterViewcontroller if the underlying data has changed i.e. a Contact has been changed

  var detailViewController: DetailViewController? = nil
  var managedObjectContext: NSManagedObjectContext? = nil

  // configure popover for UITableView on IPad
  override func awakeFromNib() 
  {
     super.awakeFromNib()

//if UIDevice.currentDevice().userInterfaceIdiom == .pad
    if UIDevice.current.userInterfaceIdiom == .pad
    {
       self.clearsSelectionOnViewWillAppear = false
       self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
    }
  }

  // called just before MasterViewController is presented on the screen
//override func viewWillAppear(animated: Bool)
  override func viewWillAppear(_ animated: Bool) 
  {
    super.viewWillAppear(animated)
    //self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
    displayFirstContactOrInstructions()
  }

  // if the UISplitViewController is not collapsed
  // select first contact or display InstructionsViewController
  func displayFirstContactOrInstructions()
  {

    if let splitViewController = self.splitViewController
    {

      if !splitViewController.isCollapsed
      { // select and display first contact if there is one

        if self.tableView.numberOfRows(inSection: 0) > 0 
        {
//       let indexPath = NSIndexPath(forRow: 0, inSection: 0)
          let indexPath = NSIndexPath(row: 0, section: 0)
//       self.tableView.selectRowAtIndexPath(indexPath,
//            animated: false,
//            scrollPosition: UITableViewScrollPosition.Top)
          self.tableView.selectRow(at: indexPath as IndexPath, 
               animated: false, 
               scrollPosition: UITableViewScrollPosition.top)
//       self.performSegueWithIdentifier( "showContactDetail", sender: self)
          self.performSegue(withIdentifier: "showContactDetail", sender: self)
        }
        else
        { // display InstructionsViewController
//       self.performSegueWithIdentifier( "showInstructions", sender: self)
          self.performSegue(withIdentifier: "showInstructions", sender: self)
        }
      }
    }
  }

  // callled after the view loads for further UI configuration
  override func viewDidLoad()
  {
    super.viewDidLoad()
    /*
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem

     let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
     self.navigationItem.rightBarButtonItem = addButton
     */
    if let split = self.splitViewController
    {
      let controllers = split.viewControllers
//   self.detailViewController =
//          controllers[controllers.count-1].topViewController as?
//          DetailViewController
      self.detailViewController = 
            (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
    }
  }

  override func didReceiveMemoryWarning() 
  {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


  func insertNewObject(_ sender: Any) 
  {
    let context = self.fetchedResultsController.managedObjectContext
    let newEvent = Contact(context: context)
         
    // If appropriate, configure the new managed object.
    newEvent.timestamp = NSDate()

    // Save the context.
    do 
      {
        try context.save()
      }
    catch 
    {
      // Replace this implementation with code to handle the error appropriately.
      // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }

  }

  // MARK: - Segues
//override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
   override func prepare(for segue: UIStoryboardSegue, sender: Any?)
   {
      if segue.identifier == "showContactDetail"
      {
//      if let indexPath = self.tableView.indexPathForSelectedRow()
         if let indexPath = self.tableView.indexPathForSelectedRow
         {
            // get Contact for selected row
//         let selectedContact = self.fetchedResultsController.objectAtIndexpath( indexPath) as Contact
            let selectedContact = self.fetchedResultsController.object(at: indexPath) as Contact

            // Configure  DetailViewController
//         let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
            let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            controller.delegate = self
            controller.detailItem = selectedContact
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem     // displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
         }
      }
      else if segue.identifier == "showAddContact"
      {
         // create a contact object that is not yet managed
         let entity = self.fetchedResultsController.fetchRequest.entity!
//      let newContact = Contact(entity: entity, 
//           insertIntoManagedObjectContext: nil)
         let newContact = Contact(entity: entity, 
              insertInto: nil)

         // configure the AddEditTableViewController
//      let controller = (segue.destinationViewController as
//           UINavigationController).topViewController as
//           AddEditTableViewController
         let controller = (segue.destination as! 
               UINavigationController).topViewController as!
               AddEditTableViewController
         controller.navigationItem.title = "Add Contact"
         controller.delegate = self
         controller.editingContact = false // adding, not editing
         controller.contact = newContact
      }
   }

  // MARK: - Save or Edit Contact

   // called by AddEditViewController after a contact is added
   func didSaveContact(controller: AddEditTableViewController)
   {
/*
    // get NSManagedObjectContext and insert new contact into it
    let context = self.fetchedResultsController.managedObjectContext
    context.insert(controller.contact!)
    self.navigationController?.popToRootViewController(animated: true)
    
    // save the context to store the new contact
    var error: NSError? = nil
//    if !context.save(&error) { // check for error
if (error != nil) 
    {
      displayError(error: error, title: "Error Saving Data",
                   message: "Unable to save contact")
    } else { // if no error, display new contact details
//      let sectionInfo =
 //       self.fetchedResultsController.sections![0] as NSFetchedResultsSectionInfo
//  if let row = find(sectionInfo.objects as [NSManagedObject], controller.contact!)

//     {
//        let path = NSIndexPath(row: row, section: 0)
//        tableView.selectRow(at: path as IndexPath, animated: true, scrollPosition: .middle)
        performSegue(withIdentifier: "showContactDetail",
                                   sender: nil)
      }
    }
*/
   }

   // called by DetailViewController after a contact is edited
   func didEditContact(controller: DetailViewController)
   {
      let context = self.fetchedResultsController.managedObjectContext
      var error: NSError? = nil
//   if !context.save(&error)
//  {
      do
      {
         try context.save()
      }
      catch
      {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }

     displayError(error: error, title: "Error Saving Data",
                 message: "Unable to save contact")
// }
   }

   // indicate that an error occurred hen saving database changes
   func displayError(error: NSError?, title: String, message: String)
   {
       let alertController = UIAlertController(title: title,
                 message: String(format:  "%@\nError:\(error)\n", message),
                 preferredStyle: UIAlertControllerStyle.alert)
       let okAction = UIAlertAction(title: "OK",
                 style: UIAlertActionStyle.cancel, handler: nil)
       alertController.addAction(okAction)
       present(alertController, animated: true,
                 completion: nil)
   }


  // MARK: - Table View

  override func numberOfSections(in tableView: UITableView) -> Int
  {
    return self.fetchedResultsController.sections?.count ?? 0
  }

  // callback that returns  number of rows in the UITbleView
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
     let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
     return sectionInfo.numberOfObjects
  }
  
  // callback that returns a configured cell for the given NSIndexPath
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath:  IndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let event = self.fetchedResultsController.object(at: indexPath)
    self.configureCell(cell, withEvent: event)
    return cell
  }

  // callback that returns whether a cell is editable
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool 
  {
    // Return false if you do not want the specified item to be editable.
    return true
  }
  
  // callback that deletes a row from the UITableView
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) 
  {

    if editingStyle == .delete 
    {
      let context = self.fetchedResultsController.managedObjectContext
      context.delete(self.fetchedResultsController.object(at: indexPath))
            
      do
      {
        try context.save()
      }
      catch
      {
         // Replace this implementation with code to handle the error appropriately.
         // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         let nserror = error as NSError
         fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }

      displayFirstContactOrInstructions()
    }
  }

  func configureCell(_ cell: UITableViewCell, withEvent event: Contact)
  {
    cell.textLabel!.text = event.timestamp!.description
//    cell.textLabel!.text = event.lastName
    cell.detailTextLabel!.text = event.firstname
  }


  // MARK: - Fetched results controller

  var fetchedResultsController: NSFetchedResultsController<Contact>
  {

    if _fetchedResultsController != nil
    {
      return _fetchedResultsController!
    }
      
    let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
      
    // Set the batch size to a suitable number.
    fetchRequest.fetchBatchSize = 20
      
    // Edit the sort key as appropriate.
    let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)

    // Edited to sort by last name, then first name
    // both using case insensitive comparisons
    let lastNameSortDescriptor = NSSortDescriptor(key: "lastName", ascending: false)
    let firstNameSortDescriptor = NSSortDescriptor(key: "firstName", ascending: false)
    
    fetchRequest.sortDescriptors = [sortDescriptor, lastNameSortDescriptor, firstNameSortDescriptor]
      
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
    aFetchedResultsController.delegate = self
    _fetchedResultsController = aFetchedResultsController
      
    do 
    {
      try _fetchedResultsController!.performFetch()
    } 
    catch 
    {
      // Replace this implementation with code to handle the error appropriately.
      // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      let nserror = error as NSError
      displayError(error: nserror, title: "Error Fetching Data", message: "Unable to get data from database")
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }

    return _fetchedResultsController!
  }    

  var _fetchedResultsController: NSFetchedResultsController<Contact>? = nil

  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) 
  {
    self.tableView.beginUpdates()
  }


  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) 
  {
      switch type 
      {
        case .insert:
            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
      }
  }

  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) 
  {
      switch type 
      {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            self.configureCell(tableView.cellForRow(at: indexPath!)!, withEvent: anObject as! Contact)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
      }
  }

  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) 
  {
      self.tableView.endUpdates()
  }

  /*
   // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
   
   func controllerDidChangeContent(controller: NSFetchedResultsController) {
       // In the simplest, most efficient, case, reload the table view.
       self.tableView.reloadData()
   }
   */

}

