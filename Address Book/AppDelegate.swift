//
//  AppDelegate.swift
//  Address Book
//     using Core Data
//
//  Created by Wayne Hill on 6/27/17.
//  Copyright © 2017 Surfside Software Solution. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate 
{

let showAll = false                // show everything
let showCoreData = false      // show core data functions
let showSplitView = false      // show split view functions


  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool 
  {
if (showAll) {print("AppDel.application.didFinishLaunchingWithOptions")}
    // Override point for customization after application launch.
    let splitViewController = self.window!.rootViewController as! UISplitViewController

let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
    splitViewController.delegate = self

    let masterNavigationController = splitViewController.viewControllers[0] as! UINavigationController
    let controller = masterNavigationController.topViewController as! MasterViewController
    controller.managedObjectContext = self.persistentContainer.viewContext
if (showAll) {print("AppDel.application:didFinishLaunching")}
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) 
  {
if (showAll) {print("AppDel.applicationWillResignActive")}
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.

  }

  func applicationDidEnterBackground(_ application: UIApplication)
  {
if (showAll) {print("AppDel.applicationDidEnterBackground")}
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) 
  {
if (showAll) {print("AppDel.applicationWillEnterForeground")}
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) 
  {
if (showAll) {print("AppDel.applicationDidBecomeActive")}
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) 
  {
if (showAll) {print("AppDel.applicationWillTerminate")}
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    self.saveContext()
  }


  // MARK: - Split view

   func splitViewController(_ splitViewController: UISplitViewController,
          collapseSecondary secondaryViewController:UIViewController, 
          onto primaryViewController:UIViewController)
               -> Bool
  {
if (showAll || showSplitView) {print("AppDel.splitViewController.collapseSecondary.onto PrimaryVC")}
      if let secondaryAsNavController = secondaryViewController as? UINavigationController {
         if let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController {  // else { return false }
            if topAsDetailController.detailItem == nil
            {
if (showAll || showSplitView) {print("AppDel.topAsDetailController == nil")}
               // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
               return true
            }
         } else if (secondaryAsNavController.topViewController as? InstructionsViewController) != nil
              {
if (showAll || showSplitView) {print("AppDel.secondaryAsNavConroller is InstructionsViewController")}
                 return true
              }
      }
      return false
   }


  // MARK: - Core Data stack

  lazy var persistentContainer: NSPersistentContainer =
  {
let showLazy = false
if (showLazy || false) {print("AppDel.persistentContainer.created.")}
/*
  The persistent container for the application. This
  implementation creates and returns a container, having
  loaded the store for the application to it. This property
  is optional since there are legitimate error conditions
  that could cause the creation of the store to fail.
*/
    let container = NSPersistentContainer(name: "AddressBook")
if (showLazy || false) {print("AppDel.container is set to \(container.name)")}
    container.loadPersistentStores(completionHandler:
    {
      (storeDescription, error) in
          if let nserror = error as NSError?
          {
if (showLazy || false) {print("AppDel.error is: \(nserror)")}
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
               
            /*
               Typical reasons for an error here include:
               * The parent directory does not exist, cannot be created, or disallows writing.
               * The persistent store is not accessible, due to permissions or data protection when the device is locked.
               * The device is out of space.
               * The store could not be migrated to the current model version.
               Check the error message to determine what the actual problem was.
            */
            fatalError("Unresolved error in Persistent Container: \(nserror), \(nserror.userInfo)")
          }
//abort() // added by wayne
      })
if (showLazy || false) {print("AppDel.returnedContainer is \(container.name)")}
      return container
  }()


  // MARK: - Core Data Saving support

  func saveContext () 
  {
if (showAll || showCoreData) {print("AppDel.saveContext")}
    let context = persistentContainer.viewContext
    if context.hasChanges
      {
if (showAll || showCoreData) {print("AppDel.context.hasChanges")}
        do
          {
if (showAll || showCoreData) {print("AppDel.try context.save")}
            try context.save()
          }
        catch
          {
if (showAll || showCoreData) {print("AppDel.catch")}
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
          }
if (showAll || showCoreData) {print("AppDel.end context.hasChanges")}
      }
if (showAll || showCoreData) {print("AppDel.end saveContext")}
  }

}

