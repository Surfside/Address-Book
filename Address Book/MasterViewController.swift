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

let showMe = false
  //NSFetchedResultsController informs MasterViewcontroller if the underlying data has changed i.e. a Contact has been changed

  var detailViewController: DetailViewController? = nil
  var managedObjectContext: NSManagedObjectContext? = nil

  // configure popover for UITableView on IPad
  override func awakeFromNib() 
  {
     super.awakeFromNib()
if (showMe) {print("M.awakeFromNib")}
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
if (showMe) {print("M.viewWillAppear")}
    displayFirstContactOrInstructions()
  }

  // if the UISplitViewController is not collapsed
  // select first contact or display InstructionsViewController
  func displayFirstContactOrInstructions()
  {
if (showMe) {print("M.displayFirstContactOrInstructions")}
    if let splitViewController = self.splitViewController
    {
if (showMe) {print("M.splitViewController")}
      if !splitViewController.isCollapsed
      { // select and display first contact if there is one
if (showMe) {print("M.splitVC.isCollapsed")}
        if self.tableView.numberOfRows(inSection: 0) > 0 
        {
if (showMe) {print("M.tableView.numberOfRows")}
          let indexPath = NSIndexPath(row: 0, section: 0)
          self.tableView.selectRow(at: indexPath as IndexPath, 
               animated: false, 
               scrollPosition: UITableViewScrollPosition.top)
          self.performSegue(withIdentifier: "showContactDetail", sender: self)
        }
        else
        { // display InstructionsViewController
if (showMe) {print("M.performSegue.showInstructions")}
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
if (showMe) {print("M.viewDidLoad")}
    if let split = self.splitViewController
    {
if (showMe) {print("M.splitViewController2")}
      let controllers = split.viewControllers
      self.detailViewController = 
            (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
    }
  }

  // MARK: - Segues

   override func prepare(for segue: UIStoryboardSegue, sender: Any?)
   {
if (showMe) {print("M.prepareForSegue")}
      if segue.identifier == "showContactDetail"
      {
if (showMe) {print("M.prepareForSegue.showContactDetail")}
         if let indexPath = self.tableView.indexPathForSelectedRow
         {
if (showMe) {print("M.indexPath")}
            // get Contact for selected row
            let selectedContact = self.fetchedResultsController.object(at: indexPath) as Contact

            // Configure  DetailViewController
            let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
            controller.delegate = self
            controller.detailItem = selectedContact
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
            controller.navigationItem.leftItemsSupplementBackButton = true
         }
      }
      else if segue.identifier == "showAddContact"
      {
if (showMe) {print("M.prepareForSegue.showAddContact")}
         // create a contact object that is not yet managed
         let entity = self.fetchedResultsController.fetchRequest.entity!
         let newContact = Contact(entity: entity, 
              insertInto: nil)

         // configure the AddEditTableViewController
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
if (showMe) {print("M.didSaveContact")}
    // get NSManagedObjectContext and insert new contact into it
    let context = self.fetchedResultsController.managedObjectContext
    context.insert(controller.contact!)
//    self.navigationController?.popToRootViewController(animated: true)
self.navigationController!.popViewController(animated: true)
    // save the context to store the new contact
    let nserror: NSError? = nil
//    if !context.save(&error) { // check for error
if (nserror != nil)
    {
      displayError(error: nserror, title: "Error Saving Data in Master at 1\n",
                   message: "Unable to save contact")
    } else { // if no error, display new contact details
if (showMe) {print("M.newContactSaved")}
      let sectionInfo =
      self.fetchedResultsController.sections![0] as NSFetchedResultsSectionInfo
//  if let row = FIND(sectionInfo.objects as [NSManagedObject], controller.contact!) {
let row = sectionInfo.numberOfObjects-1 // minus 1 ????
if !(row < 0)
{
if (showMe) {print("M.row = 0")}
        let path = NSIndexPath(row: row, section: 0)
        tableView.selectRow(at: path as IndexPath, animated: true, scrollPosition: .middle)
}
if (showMe) {print("M.performSegue.showContactDetail")}
        performSegue(withIdentifier: "showContactDetail",
                                   sender: nil)
      }
   }

   // called by DetailViewController after a contact is edited
   func didEditContact(controller: DetailViewController)
   {
if (showMe) {print("M.didEditContact")}
      let context = self.fetchedResultsController.managedObjectContext

      do
      {
if (showMe) {print("M.do try context.save")}
         try context.save()
      }
      catch
      {
if (showMe) {print("M.do catch")}
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        displayError(error: nserror, title: "Error Saving Data in Master at 2\n",
                     message: "Unable to save contact")
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }

// }
   }

   // indicate that an error occurred hen saving database changes
   func displayError(error: NSError?, title: String, message: String)
   {
if (showMe) {print("M.displayError")}
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
if (showMe) {print("M.numberOfSections")}
    return self.fetchedResultsController.sections?.count ?? 0
  }

  // callback that returns  number of rows in the UITbleView
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
if (showMe) {print("M.tableView.numberOfRowsInSection")}
     let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
     return sectionInfo.numberOfObjects
  }
  
  // callback that returns a configured cell for the given NSIndexPath
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath:  IndexPath) -> UITableViewCell
  {
if (showMe) {print("M.tableView.cellForRowAt")}
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let event = self.fetchedResultsController.object(at: indexPath)
    self.configureCell(cell, withEvent: event)
    return cell
  }

  // callback that returns whether a cell is editable
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool 
  {
if (showMe) {print("M.tableView.canEditRowAt")}
    // Return false if you do not want the specified item to be editable.
    return true
  }
  
  // callback that deletes a row from the UITableView
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) 
  {
if (showMe) {print("M.tableView.commitEditingStyle")}
    if editingStyle == .delete 
    {
if (showMe) {print("M.editingStyle")}
      let context = self.fetchedResultsController.managedObjectContext
      context.delete(self.fetchedResultsController.object(at: indexPath))
            
      do
      {
if (showMe) {print("M.do2.context.save")}
        try context.save()
      }
      catch
      {
if (showMe) {print("M.do2 catch")}
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
if (showMe) {print("M.configureCell.withEvent")}
    if (managedObjectContext != nil) // ??????
    {
if (showMe) {print("M.configureCell.gotData")}
       cell.textLabel?.text = event.firstname?.description
       cell.detailTextLabel?.text = event.lastname?.description
    }
    else
    {
if (showMe) {print("M.configureCell.gotNoData")}
       cell.textLabel?.text = "Last Name"
//    cell.textLabel!.text = event.timestamp!.description
//    cell.textLabel!.text = event.lastname
       cell.detailTextLabel?.text = "Detail Name"
//    cell.detailTextLabel!.text = event.firstname
     }
  }


  // MARK: - Fetched results controller

  var fetchedResultsController: NSFetchedResultsController<Contact>
  {
if (showMe) {print("M.fetchedResultsController")}
    if _fetchedResultsController != nil
    {
if (showMe) {print("M.fetchedResultscontroller.nil")}
      return _fetchedResultsController!
    }
      
    let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
      
    // Set the batch size to a suitable number.
    fetchRequest.fetchBatchSize = 20
      
    // Edit the sort key as appropriate.
    let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)

    // Edited to sort by last name, then first name
    // both using case insensitive comparisons
    let lastNameSortDescriptor = NSSortDescriptor(key: "lastname", ascending: false)
    let firstNameSortDescriptor = NSSortDescriptor(key: "firstname", ascending: false)
    
    fetchRequest.sortDescriptors = [sortDescriptor, lastNameSortDescriptor, firstNameSortDescriptor]
      
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
    aFetchedResultsController.delegate = self
    _fetchedResultsController = aFetchedResultsController
      
    do 
    {
if (showMe) {print("M.do3 try.fetchedResultsController")}
      try _fetchedResultsController!.performFetch()
    } 
    catch 
    {
if (showMe) {print("M.do3 catch.fetchedResultsController")}
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
if (showMe) {print("M.controllerWillChangeContect")}
    self.tableView.beginUpdates()
  }

  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) 
  {
if (showMe) {print("M.controller.didChange sectionInfo")}
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
if (showMe) {print("M.controller.didChange anObject")}
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
if (showMe) {print("M.controllerDidChangeContent.endUpdates")}
      self.tableView.endUpdates()
  }

   // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
   
   func controllerDidChangeContent(controller: NSFetchedResultsController<NSFetchRequestResult>) 
   {
      // In the simplest, most efficient, case, reload the table view.
      self.tableView.reloadData()
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
}

/*
 override func didReceiveMemoryWarning()
 {
 super.didReceiveMemoryWarning()
 // Dispose of any resources that can be recreated.
 }

*/
