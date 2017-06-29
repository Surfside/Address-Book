//
//  DetailViewController.swift
//  Address Book
//
//  Created by Wayne Hill on 6/27/17.
//  Copyright © 2017 Surfside Software Solution. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

  @IBOutlet weak var detailDescriptionLabel: UILabel!
  @IBOutlet weak var detailFirstnameLabel: UILabel!

  func configureView() {
    // Update the user interface for the detail item.
    if let detail = self.detailItem {
        if let label = self.detailDescriptionLabel {
          label.text = detail.timestamp!.description
        }
        if let label = self.detailFirstnameLabel {
          label.text = detail.firstname!.description
        }

    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    self.configureView()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  var detailItem: Contact? {
    didSet {
        // Update the view.
        self.configureView()
    }
  }


}

