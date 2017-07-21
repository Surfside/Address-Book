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
 @IBOutlet var inputFields: [UITextField]!

  // field name used in loops to get/set ontact attribute values via
  // NSManagedObjet methods valueForKey and setValue
  private let fieldNames = ["firstname","lastname","email",
                            "phone","street","city","state","zip"]
  
  var delegate: AddEditTableViewControllerDelegate!
  var contact: Contact? // Contact to add or edit
  var editingContact = false // differentiates adding / editing

    override func viewWillAppear(_ animated: Bool)
    {
      super.viewWillAppear(animated)
print("AddEditTableViewController.viewWillAppear")
      // listen for keyboard show/hide notifications
      NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
      NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);

    }

    // called when AddEditTableViwControler about to disappear
    override func viewWillDisappear(_ animated: Bool)
    {
      super.viewWillDisappear(animated)
print("AddEditTableViewController.viewWillDisappear")
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
print("AddEditTableViewController.viewDidLoad")
        // set AddEditTableViewController as the UITetFieldDelegate
        for textField in inputFields
        {
print("AddEditTableViewController.textField.delegate")
            textField.delegate = self
        }

        // if editing a Contact, display its data
        if editingContact
        {
print("AddEditTableViewController.editingContact")
            for i in 0..<fieldNames.count
            {
print("AddEditTableViewController.counting")
                // query Contact object with valueForKey
                if let value: AnyObject =  contact?.value(forKey: fieldNames[i]) as AnyObject?
                {
                    inputFields[i].text = (value as AnyObject).description
print("(inputFields[i].text)")
                }
            }
print("AddEditTableViewController.editingContact.end")
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }


  
  // MARK: - Actions
  
//  @objc private func keyboardWillShow(notification: Notification) {
//    print("keyboardWillShow called")
//  }
    func keyboardWillShow(notification: NSNotification)
    {
print("AddEditTableViewController:KeyboardWillShow")
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
print("AddEditTableViewController.keyboardWillHide")
        var insets = self.tableView.contentInset
        insets.bottom = 0
        self.tableView.contentInset = insets
        self.tableView.scrollIndicatorInsets = insets
    }

    // hide keyboard if user touches Return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
print("AddEditTableViewController.textFieldShouldReturn")
        textField.resignFirstResponder()
        return true
    }

  @IBAction func saveButtonPressed(_ sender: Any) {
print("AddEditTableViewController.saveButtonPressed")
    // ensure that first name and last name UITextFields are not empty
    if (inputFields[0].text?.isEmpty)! || (inputFields[1].text?.isEmpty)!
    {
print("AddEditTableViewController.inputFields.isEmpty")
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
print("AddEditTableViewController.inputFields.NotEmpty")
      // update the Contract using NSManagedObject method setValue
      for i in 0..<fieldNames.count
      {
print("AddEditTableViewController.inputFields.array")
        let value = (!((inputFields[i].text?.isEmpty)!) ?  inputFields[i].text : nil)
        self.contact?.setValue(value, forKey: fieldNames[i])
      }
print("AddEditTableViewController.inputFields.ended")
      self.delegate?.didSaveContact(controller: self)
    }
  }

    override func didReceiveMemoryWarning() 
    {
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

}
