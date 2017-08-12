//
//  AddEditViewController.swift
//  Address Book
//
//  Created by Wayne Hill on 7/1/17.
//  Copyright © 2017 Surfside Software Solution. All rights reserved.
//

import UIKit
import CoreData

class AddEditViewController: UITableViewController, UITextFieldDelegate, NSFetchedResultsControllerDelegate
{
let showAll = true
let showInsertObject = false
let showSegues = false
let showTable = false
let showFetchedResults = false


  @IBOutlet var inputFields: [UITextField]!

  var detailViewController: DetailViewController? = nil
  var managedObjectContext: NSManagedObjectContext? = nil

  override func viewDidLoad() 
  {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
if (showAll) {print("AEVC.viewDidLoad")}
/*
    self.navigationItem.leftBarButtonItem = self.editButtonItem

    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
    self.navigationItem.rightBarButtonItem = addButton
    if let split = self.splitViewController 
    {
      let controllers = split.viewControllers
      self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
    }
*/
  }
  
  override func viewWillAppear(_ animated: Bool) 
  {
if (showAll) {print("AEVC.viewWillAppear")}
    self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
    super.viewWillAppear(animated)
  }
  
  override func didReceiveMemoryWarning() 
  {
    super.didReceiveMemoryWarning()
if (showAll) {print("AEVC.didReceiveMemoryWarning")}
    // Dispose of any resources that can be recreated.
  }
  
  func insertNewObject(_ sender: Any) 
  {
if (showAll || showInsertObject) {print("AEVC.insertNewObject")}
    let context = self.fetchedResultsController.managedObjectContext
    let newEvent = Contact(context: context)
    
    // If appropriate, configure the new managed object.
    newEvent.timestamp = NSDate()
    
    // Save the context.
    do 
    {
if (showAll || showInsertObject) {print("AEVC.do.try1")}
      try context.save()
    } 
    catch
    {
if (showAll || showInsertObject) {print("AEVC.do.catch1")}
      // Replace this implementation with code to handle the error appropriately.
      // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }
  }
  
  // MARK: - Segues

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) 
  {
if (showAll || showSegues) {print("AEVC.prepare")}
    if segue.identifier == "showContactDetails" 
    {
if (showAll || showSegues) {print("AEVC.segue.showContactDetails")}
      if let indexPath = self.tableView.indexPathForSelectedRow 
      {
if (showAll || showSegues) {print("AEVC.indexPath")}
        let object = self.fetchedResultsController.object(at: indexPath)
        let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
        controller.detailItem = object
        controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
        controller.navigationItem.leftItemsSupplementBackButton = true
      }

    }

  }


  // MARK: - Table View
  
  override func numberOfSections(in tableView: UITableView) -> Int 
  {
if (showAll || showTable) {print("AEVC.numberOfSections")}
    return self.fetchedResultsController.sections?.count ?? 0
//return 0
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int 
  {
if (showAll || showTable) {print("AEVC.numberOfRowsInSection")}
    let sectionInfo = self.fetchedResultsController.sections![section]
    return sectionInfo.numberOfObjects
//return 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell 
  {
if (showAll || showTable) {print("AEVC.cellForRowAt indexPath")}
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let event = self.fetchedResultsController.object(at: indexPath)
    self.configureCell(cell, withEvent: event)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool 
  {
if (showAll || showTable) {print("AEVC.canEditRowAt indexPath")}
    // Return false if you do not want the specified item to be editable.
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) 
  {
if (showAll || showTable) {print("AEVC.commit editingStyle")}
    if editingStyle == .delete 
    {
if (showAll || showTable) {print("AEVC.delete")}
       let context = self.fetchedResultsController.managedObjectContext
       context.delete(self.fetchedResultsController.object(at: indexPath))
      
       do 
       {
if (showAll || showTable) {print("AEVC.do.try1")}
        try context.save()
       } 
       catch 
       {
if (showAll || showTable) {print("AEVC.do.catch1")}
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
  func configureCell(_ cell: UITableViewCell, withEvent event: Contact)
  {
if (showAll || showTable) {print("AEVC.configureCell")}
    cell.textLabel!.text = event.timestamp!.description
  }


  // MARK: - Fetched results controller

  var fetchedResultsController: NSFetchedResultsController<Contact>
  {
if (showAll || showFetchedResults) {print("AEVC.fetchedResultController")}
    if _fetchedResultsController != nil 
    {
      return _fetchedResultsController!
    }
    
    let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
    
    // Set the batch size to a suitable number.
    fetchRequest.fetchBatchSize = 20
    
    // Edit the sort key as appropriate.
    let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
    
    fetchRequest.sortDescriptors = [sortDescriptor]
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
    aFetchedResultsController.delegate = self
    _fetchedResultsController = aFetchedResultsController
    
    do {
if (showAll || showFetchedResults) {print("AEVC.do.performFetch2")}
      try _fetchedResultsController!.performFetch()
    } catch {
if (showAll || showFetchedResults) {print("AEVC.catch2")}
      // Replace this implementation with code to handle the error appropriately.
      // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      let nserror = error as NSError
      fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    }

    return _fetchedResultsController!
  }

  var _fetchedResultsController: NSFetchedResultsController<Contact>? = nil
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) 
  {
if (showAll || showFetchedResults) {print("AEVC.controllerwillChangeContent")}
    self.tableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) 
  {
if (showAll || showFetchedResults) {print("AEVC.didChange sectionInfo")}
    switch type {
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
if (showAll || showFetchedResults) {print("AEVC.didChange anObject")}
    switch type {
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
if (showAll || showFetchedResults) {print("AEVC.controllerDidChangecontent1")}
    self.tableView.endUpdates()
  }

   // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
   
  func controllerDidChangeContent(controller: NSFetchedResultsController<NSFetchRequestResult>)
  { // In the simplest, most efficient, case, reload the table view.
if (showAll || showFetchedResults) {print("AEVC.controllerDidChangeContent2")}
    self.tableView.reloadData()
  }

}


