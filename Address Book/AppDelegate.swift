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

let showAll = false                  // show everything
let showApp = false               // show application processes
let showCoreData = false      // show core data functions
let showSplitVC = false      // show split view functions
let showSteps = false            // show internal steps


  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool 
  {
if (showAll || showApp) {print("AD1.LaunchWOptions")}
    // Override point for customization after application launch.
    let splitViewController = self.window!.rootViewController as! UISplitViewController
if (showAll || showSteps) {print("AD.splitVC assigned")}
    let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
if (showAll || showSteps) {print("AD.splitVC.count = \(splitViewController.viewControllers.count)")}
    navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
if (showAll || showApp) {print("AD.navVC.topVC.leftButton goes back to splitVC")}
    splitViewController.delegate = self
if (showAll || showSteps) {print("splitVC.delegate is AppDel")}
    let masterNavigationController = splitViewController.viewControllers[0] as! UINavigationController
if (showAll || showSteps){print("AD.masterNC = splitVC")}
    let controller = masterNavigationController.topViewController as! MasterViewController
if (showAll || showSteps) {print("AD.point to masterVC")}
    controller.managedObjectContext = self.persistentContainer.viewContext
if (showAll || showSteps) {print("AD.MOContext is PC.viewContext")}
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
if (showAll) {print("AD6.appDidBecomeActive")}
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
if (showAll || showSplitVC) {print("AD3.splitVC.collapseSecondVC onto PrimaryVC")}
        if let secondaryAsNavController = secondaryViewController as? UINavigationController
        {   // if secondary is Navigation Controller
if (showAll || showSplitVC) {print("AD.splitVC.secondaryNC is secondaryVC as NC")}
            if let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController
            {   // and if it's topVC is DetailViewController
if (showAll || showSplitVC) {print("AD.splitVC.topVC is DetailVC")}
                if topAsDetailController.detailItem == nil
                { // and if that detail controller has no contact information
                  // then the secondary controller will be discarded
if (showAll || showSplitVC) {print("AD.splitVC.DVC.detailItem == nil")}
                    // true indicates that we have handled the collapse by doing nothing
                    return true
                }
                // maybe add code here if that detail controller has some contact information
if (showAll || showSplitVC) {print("AD.splitVD.DVC.detailItem != nil")}
            }  //  so topVC is not DetailViewController
            else if (secondaryAsNavController.topViewController as? InstructionsViewController) != nil
            { // if topVC is Instructions
if (showAll || showSplitVC) {print("AD4.topVC is Instructions")}
                // true indicates that we have handled the collapse by doing nothing
                return true
            } // so topVC is not InstructionsViewController of DetailViewController
if (showAll || showSplitVC) {print("AD not InstructionsVC nor DetailVC")}
        }  // there is no top View Controller
if (showAll || showSplitVC) {print("AD.topVC is MasterVC")}
        // false indicates that we have handled the collapse by doing something
        return false
    }



    // MARK: - Core Data stack

   /*
    The persistent container for the application. This
    implementation creates and returns a container, having
    loaded the store for the application to it. This property
    is optional since there are legitimate error conditions
    that could cause the creation of the store to fail.
    */

    lazy var persistentContainer: NSPersistentContainer =
    {  // create a persistent container and load the store called AddressBook
let showLazy = false
if (showLazy || false) {print("AD.creating persistentContainer")}
        let container = NSPersistentContainer(name: "AddressBook")
if (showLazy || false) {print("AD.container named: \(container.name)")}
        container.loadPersistentStores(completionHandler:
        {
          (storeDescription, error) in
            if let nserror = error as NSError?
            {
if (showLazy || false) {print("AD.while trying to load the store this error occurred: \(nserror)")}
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. 
            // You should not use this function in a shipping application, although it may be useful during development.
               
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
        })
if (showLazy || false) {print("AD.persistentContainer: \(container.name) was returned")}
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

