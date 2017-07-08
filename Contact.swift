//
//  Contact+CoreDataClass.swift
//  Address Book
//
//  Created by Wayne Hill on 7/4/17.
//  Copyright © 2017 Surfside Software Solution. All rights reserved.
//

import Foundation
import CoreData

@objc(Contact)
public class Contact: NSManagedObject 
{

  @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> 
  {
     return NSFetchRequest<Contact>(entityName: "Contact");
  }
  
  @NSManaged public var timestamp: NSDate?
  @NSManaged public var lastName: String?
  @NSManaged public var firstName: String?
  @NSManaged public var email: String?
  @NSManaged public var phone: String?
  @NSManaged public var street: String?
  @NSManaged public var city: String?
  @NSManaged public var state: String?
  @NSManaged public var zip: String?
}
