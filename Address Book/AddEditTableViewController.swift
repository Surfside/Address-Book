//
//  AddEditTableViewController.swift
//  Address Book
//
//  Created by Wayne Hill on 7/5/17.
//  Copyright © 2017 Surfside Software Solution. All rights reserved.
//

import CoreData
import UIKit

// MasterViewController and DetailViewController conform to this
protocol AddEditTableViewControllerDelegate
{
   func didSaveContact(controller: AddEditTableViewController)
}

class AddEditTableViewController: UITableViewController, UITextFieldDelegate
{  // called to notify delegate to store changes in the model

let showAll = true                  // show everything
let showSave = false               // show Save functions
let showKeyboard = false       // show keyboard activations
let showEditContact = false   // show edit contact


 @IBOutlet var inputFields: [UITextField]!

  // field name used in loops to get/set contact attribute values
  // via NSManagedObjet methods valueForKey and setValue
  private let fieldNames = ["firstname","lastname","email",
                            "phone","street","city","state","zip"]
  
  var delegate: AddEditTableViewControllerDelegate!
  var contact: Contact? // Contact to add or edit
  var editingContact = false // differentiates adding / editing

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
if (showAll) {print("AETVC.viewWillAppear")}
        // listen for keyboard show/hide notifications
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
    }

    // called when AddEditTableViwControler about to disappear
    override func viewWillDisappear(_ animated: Bool)
    {
      super.viewWillDisappear(animated)
if (showAll) {print("AETVC.viewWillDisappear")}
      // unregister for keyboard show/hide notifications
      NotificationCenter.default.removeObserver(self, 
                  name: NSNotification.Name.UIKeyboardWillShow, 
                  object: nil)
      NotificationCenter.default.removeObserver(self, 
                  name: NSNotification.Name.UIKeyboardWillHide, 
                  object: nil)
    }

    override func viewDidLoad() 
    {
        super.viewDidLoad()
if (showAll) {print("AETVC.viewDidLoad")}
        // set AddEditTableViewController as the UITetFieldDelegate
        for textField in inputFields
        {
if (showAll) {print("ATVC.textField.delegate = self")}
            textField.delegate = self
        }

        // if editing a Contact, display its data
        if editingContact
        {
if (showAll || showEditContact) {print("AETVC.editingContact")}
            for i in 0..<fieldNames.count
            {
if (showAll || showEditContact) {print("AETVC.counting1")}
                // query Contact object with valueForKey
                if let value: AnyObject =  contact?.value(forKey: fieldNames[i]) as AnyObject?
                {
                    inputFields[i].text = (value as AnyObject).description
if (showAll || showEditContact) {print("(inputFields[i].text)")}
                }
            }
if (showAll || showEditContact) {print("AETVC.editingContact.end")}
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }


  
    // MARK: - Actions
  
    func keyboardWillShow(notification: NSNotification)
    {
if (showAll || showKeyboard) {print("AETVC:KeyboardWillShow")}
        let userInfo = notification.userInfo!
        let frame = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue!
        let size = frame?.cgRectValue.size // keyboard's size

        // get duration of keyboard's slid-in animation
        let animationTime = (userInfo[UIKeyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue
      
        // scroll self.tableView so selected UITextField stays above keyboard
        UIView.animate(withDuration: animationTime!)
        {
          var insets = self.tableView.contentInset
          insets.bottom = (size?.height)!
          self.tableView.contentInset = insets
          self.tableView.scrollIndicatorInsets = insets
        }
    }

    // called when app receives UIKeyboardWillHideNotification
    func keyboardWillHide(notification: NSNotification)
    {
if (showAll || showKeyboard) {print("AETVC.keyboardWillHide")}
        var insets = self.tableView.contentInset
        insets.bottom = 0
        self.tableView.contentInset = insets
        self.tableView.scrollIndicatorInsets = insets
    }

    // hide keyboard if user touches Return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
if (showAll || showKeyboard) {print("AETVC.textFieldShouldReturn")}
        textField.resignFirstResponder()
        return true
    }

    @IBAction func saveButtonPressed(_ sender: Any) 
    {
if (showAll || showSave) {print("AETVC.saveButtonPressed")}
        // ensure that first name and last name UITextFields are not empty
        if (inputFields[0].text?.isEmpty)! || (inputFields[1].text?.isEmpty)!
        {
if (showAll || showSave) {print("AETVC.inputFields.isEmpty")}
            // create UIAlertController to display error message
            let alertController = UIAlertController(title: "Error",
                                              message: "First name and last name are required",
                                              preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK",
                                   style: UIAlertActionStyle.cancel, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true,
              completion: nil)
        }
        else
        {
if (showAll || showSave) {print("AETVC.inputFields.NotEmpty")}
            // update the Contract using NSManagedObject method setValue
            for i in 0..<fieldNames.count
            {
               if (showAll || showSave) {print("AETVC.counting2")}
                // query Contact object with valueForKey
                let value = (!((inputFields[i].text?.isEmpty)!) ?  inputFields[i].text : nil)
                self.contact?.setValue(value, forKey: fieldNames[i])
if (showAll || showSave) {print("\n\(fieldNames[i]): \(value)")}
            }
if (showAll || showSave) {print("AETVC.inputFields.ended")}
                self.delegate?.didSaveContact(controller: self)
        }
if (showAll || showSave) {print("AETVC.saveButtonPressed.end")}
    }

}

/*
    override func didReceiveMemoryWarning() 
    {
if (showAll) {print("AETVC.didReceiveMemoryWarning")}
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

/*
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
*/

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
*/
