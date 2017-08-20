//
//  MasterViewController.swift
//  Address Book
//
//  Created by Wayne Hill on 6/27/17.
//  Copyright © 2017 Surfside Software Solution. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController,NSFetchedResultsControllerDelegate, 
   AddEditTableViewControllerDelegate,
   DetailViewControllerDelegate
{

let showAll = false                    // everything
let showTableView = true        // only table view
let showFetchedData = false    // only fetched data
let showInstructions = false     // only Instructions
let showSegues = false             // only Segues
let showSave = false                 // only Save functions
let showEdit = false                 // only Edit stuff
let showError = false               // only Errors
let showSplit = false                // only Split
let showCell = false                 // only Cell
let showRow = false                 // only Row


    //NSFetchedResultsController informs MasterViewcontroller if the underlying data has changed i.e. a Contact has been changed

    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil

    // configure popover for UITableView on IPad
    override func awakeFromNib()
    {
if (showAll) {print("M1.awakeFromNib")}
        super.awakeFromNib()

        // if the device is an IPad display the screen properly
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            // do not clear the selected row before the view will appear; false == do not clear
            self.clearsSelectionOnViewWillAppear = false
//            self.clearsSelectionOnViewWillAppear = true

            // set the screen size for the IPad rather than the IPhone
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }


    // called just before MasterViewController is presented on the screen
    override func viewWillAppear(_ animated: Bool)
    {
if (showAll) {print("M7.viewWillAppear")}
        super.viewWillAppear(animated)

// clear selected row
//self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed

        // display either the selected first contact, or instructions
        displayFirstContactOrInstructions()
    }


    // if the UISplitViewController is not collapsed
    // select first contact or display InstructionsViewController
    func displayFirstContactOrInstructions()
    { // chooses which VC to display Contact List or Instructions
if (showAll || showInstructions) {print("M.displayFirstContactOrInstructions")}

        if let splitViewController = self.splitViewController
        { // get the split view controller
if (showAll || showInstructions) {print("M.get splitViewController")}

        // splitViewController is NOT collapsed because
        // there is a second controller displayed to
        // the right of the Master view controller
        if !splitViewController.isCollapsed
        { // there is a second controller to the right of the Master
if (showAll || showInstructions) {print("M.!splitVC.isCollapsed")}

            // select and display the master's first contact if there
            // is one, or show the instructions if not
            if self.tableView.numberOfRows(inSection: 0) > 0
            { // the table contains a least one row of contacts
if (showAll || showInstructions) {print("M.numberOfRowsInSection(0) > 0: \(self.tableView.numberOfRows(inSection: 0))")}

                // get the indexPath to the first row
                let indexPath = NSIndexPath(row: 0, section: 0)
if (showAll || showInstructions){print("M.indexPath = \(indexPath)")}

                // select the first row and make it visible
                self.tableView.selectRow(at: indexPath as IndexPath,
                   animated: false,
                   scrollPosition: UITableViewScrollPosition.top)
if(showAll || showInstructions){print("M.scrollPosition.top")}

                // show the contact list for the selected contact
                self.performSegue(withIdentifier: "showContactDetail", sender: self)
if (showAll || showInstructions){print("M.segue showContactDetail")}

            }
            else
                {   // since there are NO rows in the table anyways

if (showAll || showInstructions) {print("M.performSegue.showInstructions")}

                    // so display the Instructions View Controller
                    self.performSegue(withIdentifier: "showInstructions", sender: self)
if (showAll || showInstructions){print("M.segue showInstrtuctions")}

                }
            // split View Controller is not collapsed and 
            // a secondary is assigned
            }
        // no secondary exists to the right of Master
        }
    // either the contact list or the instructions are displayed now
if (showAll || showInstructions){print("M. either a Contact List or Instructions should be shown now")}
    }



   // called after the view loads
   override func viewDidLoad()
   {  // perform additional setup after loading the view from a nib
      super.viewDidLoad()
if (showAll) {print("M2.viewDidLoad begins")}
      
      /*
       *    self.navigationItem.leftBarButtonItem = self.editButtonItem
       *    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
       *    self.navigationItem.rightBarButtonItem = addButton
       */

      // get the split view controller
      if let split = self.splitViewController
      {  // get its other view controllers
if (showAll || showSplit) {print("M3.get splitVC")}

         // get the controllers for split
         let controllers = split.viewControllers
if (showAll || showSplit){print("M.get splitVC.controllers")}

            // make detail view controller the top view controller
            self.detailViewController =
            (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
if (showAll || showSplit){print("M.detailVC is topVC")}
      }
if (showAll || showSplit){print("M.viewDidLoad finished")}
   }
   


    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    { // which segue do we prepare for
if (showAll || showSegues) {print("M.prepareForSegue")}
        if segue.identifier == "showContactDetail"
        { // if segue to detail view controller
if (showAll || showSegues) {print("M.showContactDetail")}
            if let indexPath = self.tableView.indexPathForSelectedRow
            {   // get indexPath to the selected row
if (showAll || showSegues) {print("M.indexPath")}
                // retreive Contacts information for selected row
                let selectedContact = self.fetchedResultsController.object(at: indexPath) as Contact
if (showAll || showSegues) {print("M.select a contact")}
                // get the DetailViewController
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
if (showAll || showSegues) {print("M.segue to DetailVC")}
                // assign its delegate
                controller.delegate = self
if (showAll || showSegues) {print("M.assign delegate")}
                // get the selected detail item
                controller.detailItem = selectedContact
if (showAll || showSegues) {print("M.detailItem is: \(controller.detailItem.description)")}
                // get the left bar button items mode
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
if (showAll || showSegues) {print("M.display Mode Button")}
                // show the left items name in back button
                controller.navigationItem.leftItemsSupplementBackButton = true
if (showAll || showSegues) {print("M.name back button")}
            }
        // contact's detail view is shown
        }
        else if segue.identifier == "showAddContact"
            {   // if segue is to add contact
if (showAll || showSegues) {print("M.prepareForSegue.showAddContact")}
                // get a contact object that is not yet managed
                let entity = self.fetchedResultsController.fetchRequest.entity!
if (showAll || showSegues) {print("M.fetchentity: \(entity.description)")}
                // prepare to insert the new contact's data
                let newContact = Contact(entity: entity,
              insertInto: nil)
if (showAll || showSegues) {print("M.grab the new contact")}
                // configure the AddEditTableViewController
                let controller = (segue.destination as!
               UINavigationController).topViewController as!
               AddEditTableViewController
if (showAll || showSegues) {print("M.topVC is AETVC")}
                // update the navigationItems title
                controller.navigationItem.title = "Add Contact"
if (showAll || showSegues) {print("M.name title: Add Contact")}
                // set this controller's delegate
                controller.delegate = self
if (showAll || showSegues) {print("M.assign delegate")}
                // true - edit the new contact, false is adding
                controller.editingContact = false // adding
if (showAll || showSegues) {print("M.adding a contact")}
                // insert the new contact
                controller.contact = newContact
if (showAll || showSegues) {print("M.insert new contact")}
            }
        // not showContactDetail nor showAddContact, so...
if (showAll || showSegues) {print("M.finished preparing segue")}
        }



    // MARK: - Save or Edit Contact

    // called by AddEditTableViewController after a contact is added
    func didSaveContact(controller: AddEditTableViewController)
    {   // AETVC protocol - required
if (showAll || showSave) {print("M.didSaveContact - begins")}
        // get NSManagedObjectContext
        let context = self.fetchedResultsController.managedObjectContext
if(showAll || showSave){print("M.ManagedObjectContext: \(context.description)")}
        // insert new contact into it
        context.insert(controller.contact!)
if (showAll || showSave) {print("M.insert contact into context")}
        // popToRootViewController
self.navigationController!.popToRootViewController(animated: true)
if (showAll || showSave) {print("M.pop to Root VC")}
//      self.navigationController!.popViewController(animated: true)
//if (showAll || showSave) {print("M.pop top VC from stack")}

      // clear error messages
      let nserror: NSError? = nil
if (showAll || showSplit){print("M. nserror is nil")}

      // check for error messages
      if (showAll || showSave) {print("M.error is nil")}
        do
            {
                try context.save()
if (showAll || showSave) {print("M.do try save context")}
            }
        catch
            {   // error saving contact data
                displayError(error: nserror, title: "Error Saving Data in Master\n",
                   message: "Unable to save contact at 1")
            }
        if nserror == nil
            {   // if no errors, display new contact details
if (showAll || showSave) {print("M.no errors and newContactSaved")}
                // fetch section information
                let sectionInfo =
      self.fetchedResultsController.sections![0] as NSFetchedResultsSectionInfo
if (showAll || showSave) {print("M.sectionInfo named:  \(sectionInfo.name)")}
                //  if let row = FIND(sectionInfo.objects as [NSManagedObject], controller.contact!) {
                // fetch row information
                let row = sectionInfo.numberOfObjects-1
if (showAll || showSave) {print("M.number of Objects: \(sectionInfo.numberOfObjects)")}
                // if row is less than 0 - error
                if !(row < 0)
                {  // if at least one row exists
if (showAll || showSave) {print("M.some row exists: \(row.description)")}
// get the path to each row
                    let path = NSIndexPath(row: row, section: 0)
if (showAll || showSave) {print("M.path points to row: \(row.description)")}
// select a row and keep it in view
                    tableView.selectRow(at: path as IndexPath, animated: true, scrollPosition: .middle)
if (showAll || showSave) {print("M.row: \(row.description)  selected")}
                }  // even if no rows exist
if (showAll || showSave) {print("M.negative or no rows?")}
                // segue to detail information
//                performSegue(withIdentifier: "showContactDetail",
 //                                  sender: nil)
if (showAll || showSave) {print("M.without segue to showContactDetail")}
            // end else if no errors
            }
    // didSaveContact finished
if (showAll || showSave) {print("M.didSaveContact finished")}
    }



   // called by DetailViewController after a contact is edited
   func didEditContact(controller: DetailViewController)
   {
if (showAll || showEdit) {print("M.didEditContact")}
      let context = self.fetchedResultsController.managedObjectContext
if (showAll || showEdit){print("M.get context")}

      do
      {
if (showAll || showEdit) {print("M.do try context.save")}
         try context.save()
      }
      catch
      {
if (showAll || showEdit) {print("M.do catch")}
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        displayError(error: nserror, title: "Error Saving Data in Master at 2\n",
                     message: "Unable to save contact")
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
// throw??
   }


   // indicate that an error occurred when saving database changes
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
    {   // get the number of Sections in the table
if (showAll || showTableView) {print("M.numberOfSections: \(self.fetchedResultsController.sections?.count)")}
        return self.fetchedResultsController.sections?.count ?? 0
    }

  // callback that returns  number of rows in the UITbleView
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
if (showAll || showTableView) {print("M.numberOfRowsInSection")}

     // get sectionInfo
     let sectionInfo = self.fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo

if (showAll || showTableView){print("M.numberOfObjects: \(sectionInfo.numberOfObjects)")}
     // return number of objects in section
     return sectionInfo.numberOfObjects
  }
  
  // callback that returns a configured cell for the given NSIndexPath
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath:  IndexPath) -> UITableViewCell
  {
if (showAll || showTableView) {print("M.tableView.cellForRowAt")}

    // get reusable cell
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
if (showAll || showCell) {print("M.cell Cell")}

   // get contact
    let object = self.fetchedResultsController.object(at: indexPath)
if (showAll || showCell) {print("M.object: \(object.firstname)")}

    // configure cell with contact
    self.configureCell(cell, withEvent: object)
if (showAll || showCell) {print("M.cell configured")}

    return cell
  }

  // callback that returns whether a cell is editable
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool 
  {
if (showAll || showRow) {print("M.row is NOT editable")}
    // Return false if you do not want the specified item to be editable.
    return true
  }
  
  // callback that deletes a row from the UITableView
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) 
  {
if (showAll || showTableView) {print("M.commitEditingStyle")}
    if editingStyle == .delete 
    {
if (showAll || showTableView) {print("M.editingStyle .delete")}
      // get context
      let context = self.fetchedResultsController.managedObjectContext

      // delete object from context
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

      //  display either the contact list or instructions
      //  based on if there are contacts in the database
      displayFirstContactOrInstructions()
    }
  }

    // configure cell with contacts
    func configureCell(_ cell: UITableViewCell, withEvent event: Contact)
    {  // contacts are called events
if (showAll || showCell) {print("M.configureCell.withEvent")}

        // if managed object exists
        if (managedObjectContext != nil)
        {  // and the managed object does contain a contact
if (showAll || showCell) {print("M.configureCell.gotData")}

            // update label text with contact's firstname
            cell.textLabel?.text = event.firstname?.description

            // updarte lebel text with contact's lastname
            cell.detailTextLabel?.text = event.lastname?.description

        }
        else // else the managed object does not exist
        {  // thus the managed object has no contact

if (showAll || showTableView) {print("M.managed object does not exist, so give it place holder data")}

            cell.textLabel?.text = "Last Name"
//         cell.textLabel!.text = event.timestamp!.description
//         cell.textLabel!.text = event.lastname
            cell.detailTextLabel?.text = "Detail Name"
//         cell.detailTextLabel!.text = event.firstname
        }
if (showAll || showCell) {print("M.cell configured finished")}
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
