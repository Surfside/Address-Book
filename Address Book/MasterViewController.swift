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

let showAll = false                    // everything
let showTableView = false        // only table view
let showFetchedData = false    // only fetched data
let showInstructions = false     // only Instructions
let showSegues = false             // only Segues
let showSaveEdit = false          // only Save or Edit functions
let showError = false               // only errors


    //NSFetchedResultsController informs MasterViewcontroller if the underlying data has changed i.e. a Contact has been changed

    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil

    // configure popover for UITableView on IPad
    override func awakeFromNib()
    {
        super.awakeFromNib()
if (showAll) {print("M1.awakeFromNib")}
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    // called after the view did load allowing further UI configuration
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
if (showAll) {print("M2.viewDidLoad")}

/*
  *    self.navigationItem.leftBarButtonItem = self.editButtonItem
  *    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
  *    self.navigationItem.rightBarButtonItem = addButton
  */

        if let split = self.splitViewController
        {
if (showAll) {print("M3.splitViewController")}
            let controllers = split.viewControllers
            self.detailViewController =
            (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
   }
   

    // called just before MasterViewController is presented on the screen
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        //self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
if (showAll) {print("M7.viewWillAppear")}
       displayContactListOrInstructions()
    }

  // if the UISplitViewController is not collapsed
  // select first contact or display InstructionsViewController
  func displayContactListOrInstructions()
  {
if (showAll || showInstructions) {print("M8.displayContactListOrInstructions")}
    if let splitViewController = self.splitViewController
    {
if (showAll || showInstructions) {print("M9.splitViewController")}
      if !splitViewController.isCollapsed
      { // select and display first contact if there is one
if (showAll || showInstructions) {print("M.splitVC.isCollapsed")}
        if self.tableView.numberOfRows(inSection: 0) > 0 
        {
if (showAll || showInstructions) {print("M.tableView.numberOfRows")}
          let indexPath = NSIndexPath(row: 0, section: 0)
          self.tableView.selectRow(at: indexPath as IndexPath, 
               animated: false, 
               scrollPosition: UITableViewScrollPosition.top)
          self.performSegue(withIdentifier: "showContactDetail", sender: self)
        }
        else
        { // display InstructionsViewController
if (showAll || showInstructions) {print("M.performSegue.showInstructions")}
          self.performSegue(withIdentifier: "showInstructions", sender: self)
        }
      }
    }
  }

  // MARK: - Segues

   override func prepare(for segue: UIStoryboardSegue, sender: Any?)
   {
if (showAll || showSegues) {print("M.prepareForSegue")}
      if segue.identifier == "showContactDetail"
      {
if (showAll || showSegues) {print("M.prepareForSegue.showContactDetail")}
         if let indexPath = self.tableView.indexPathForSelectedRow
         {
if (showAll || showSegues) {print("M.indexPath")}
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
if (showAll || showSegues) {print("M.prepareForSegue.showAddContact")}
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

   // called by AddEditTableViewController after a contact is added
    func didSaveContact(controller: AddEditTableViewController)
    {
if (showAll || showSaveEdit) {print("M.didSaveContact - 1")}
        // get NSManagedObjectContext
        let context = self.fetchedResultsController.managedObjectContext
if(showAll || showSaveEdit){print("M.context = \(context.description)")}
        // insert new contact into it
        context.insert(controller.contact!)
        // popToRootViewController
        self.navigationController!.popViewController(animated: true)
        // clear error messages
        let nserror: NSError? = nil
        // check for error messages
        if (nserror != nil)
        {
            displayError(error: nserror, title: "Error Saving Data in Master at 1\n",
                   message: "Unable to save contact")
        }
        else
            {   // if no error, display new contact details
if (showAll || showSaveEdit) {print("M.newContactSaved - 2")}
                // fetch section information
                let sectionInfo =
      self.fetchedResultsController.sections![0] as NSFetchedResultsSectionInfo
if (showAll || showSaveEdit) {print("M.rowNumber = \(sectionInfo.numberOfObjects)")}
                //  if let row = FIND(sectionInfo.objects as [NSManagedObject], controller.contact!) {
                // fetch row information
                let row = sectionInfo.numberOfObjects-1
                // if row is less than 0 - error
                if !(row < 0)
                {
if (showAll || showSaveEdit) {print("M.badRowNumber = \(row.description)")}
                    let path = NSIndexPath(row: row, section: 0)
                    tableView.selectRow(at: path as IndexPath, animated: true, scrollPosition: .middle)
                }
if (showAll || showSaveEdit) {print("M.segue showContactDetail - 3")}
                performSegue(withIdentifier: "showContactDetail",
                                   sender: nil)
            }
    }

   // called by DetailViewController after a contact is edited
   func didEditContact(controller: DetailViewController)
   {
if (showAll || showSaveEdit) {print("M.didEditContact")}
      let context = self.fetchedResultsController.managedObjectContext

      do
      {
if (showAll || showSaveEdit) {print("M.do try context.save")}
         try context.save()
      }
      catch
      {
if (showAll || showSaveEdit) {print("M.do catch")}
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
if (showAll || showError) {print("M.displayError")}
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
if (showAll || showTableView) {print("M4-9-14-18.numberOfSections")}
        return self.fetchedResultsController.sections?.count ?? 0
    }

  // callback that returns  number of rows in the UITbleView
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
if (showAll || showTableView) {print("M12-17-21.tableView.numberOfRowsInSection")}
     let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
     return sectionInfo.numberOfObjects
  }
  
  // callback that returns a configured cell for the given NSIndexPath
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath:  IndexPath) -> UITableViewCell
  {
if (showAll || showTableView) {print("M.tableView.cellForRowAt")}
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let event = self.fetchedResultsController.object(at: indexPath)
    self.configureCell(cell, withEvent: event)
    return cell
  }

  // callback that returns whether a cell is editable
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool 
  {
if (showAll || showTableView) {print("M.tableView.canEditRowAt")}
    // Return false if you do not want the specified item to be editable.
    return true
  }
  
  // callback that deletes a row from the UITableView
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) 
  {
if (showAll || showTableView) {print("M.tableView.commitEditingStyle")}
    if editingStyle == .delete 
    {
if (showAll || showTableView) {print("M.editingStyle")}
      let context = self.fetchedResultsController.managedObjectContext
      context.delete(self.fetchedResultsController.object(at: indexPath))
            
      do
      {
if (showAll || showTableView) {print("M.do2.context.save")}
        try context.save()
      }
      catch
      {
if (showAll || showTableView) {print("M.do2 catch")}
         // Replace this implementation with code to handle the error appropriately.
         // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         let nserror = error as NSError
         fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }

      displayContactListOrInstructions()
    }
  }

  func configureCell(_ cell: UITableViewCell, withEvent event: Contact)
  {
if (showAll || showTableView) {print("M.configureCell.withEvent")}
    if (managedObjectContext != nil) // ??????
    {
if (showAll || showTableView) {print("M.configureCell.gotData")}
       cell.textLabel?.text = event.firstname?.description
       cell.detailTextLabel?.text = event.lastname?.description
    }
    else
    {
if (showAll || showTableView) {print("M.configureCell.gotNoData")}
       cell.textLabel?.text = "Last Name"
//    cell.textLabel!.text = event.timestamp!.description
//    cell.textLabel!.text = event.lastname
       cell.detailTextLabel?.text = "Detail Name"
//    cell.detailTextLabel!.text = event.firstname
     }
  }


    // MARK: - Fetched results controller
   
   // create an empty fetched results controller to hold the Contact records
   var _fetchedResultsController: NSFetchedResultsController<Contact>? = nil

    var fetchedResultsController: NSFetchedResultsController<Contact>
    {
if (showAll || showFetchedData) {print("M5-10-13-15-17-19-22.fetchedResultsController")}

        // return only fetched results that are not empty, or nil
        if _fetchedResultsController != nil
        {
if (showAll || showFetchedData) {print("M11-14-16-18-20-23.fetchedResultscontroller is not nil")}
            return _fetchedResultsController!
        }

        // fetch another contact
        let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()

        // Set the batch size to a suitable number - 20.
        fetchRequest.fetchBatchSize = 20

        // Sort by timestamp
//     let timeStampSortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        // Sort by last name
        let lastNameSortDescriptor = NSSortDescriptor(key: "lastname", ascending: true)
        // Sort by first name
//     let firstNameSortDescriptor = NSSortDescriptor(key: "firstname", ascending: false)

        fetchRequest.sortDescriptors = [
//                                      timeStampSortDescriptor,
                                         lastNameSortDescriptor,
//                                      firstNameSortDescriptor
        ]

        // Create a FetchedResultsController and give it a cacheName
        // a sectionNameKeyPath: nil means "no sections"
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")

        // MVC is the delegate for aFetchedResultsController
        aFetchedResultsController.delegate = self

        // point it to the fetched results controller we created
        _fetchedResultsController = aFetchedResultsController

        // do try to fetch data from database, catch all errors
        do
        {
if (showAll) {print("M6.do3 try.fetchedResultsController")}
            // fetch data to the fetched results controller
            try _fetchedResultsController!.performFetch()
        }
        catch
        {
if (showAll) {print("M.do3 catch.fetchedResultsController")}
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            displayError(error: nserror, title: "Error Fetching Data", message: "Unable to get data from database")
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }

        // return the fetched results controller
        return _fetchedResultsController!
    }

  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
  {
if (showAll || showFetchedData) {print("M.controllerWillChangeContect")}
    self.tableView.beginUpdates()
  }

  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) 
  {
if (showAll || showFetchedData) {print("M.controller.didChange sectionInfo")}
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
if (showAll || showFetchedData) {print("M.controller.didChange anObject")}
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
if (showAll || showFetchedData) {print("M.controllerDidChangeContent.endUpdates")}
      self.tableView.endUpdates()
  }

   // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
   
   func controllerDidChangeContent(controller: NSFetchedResultsController<NSFetchRequestResult>) 
   {
if (showAll || showFetchedData) {print("M.controllerDidChangeContent.reloadData")}
      // In the simplest, most efficient, case, reload the table view.
      self.tableView.reloadData()
   }
  
  func insertNewObject(_ sender: Any)
  {
if (showAll || showFetchedData) {print("M.insertNewObject")}
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
