//
//  EntryDetailViewController.swift
//  CK_Journal_27
//
//  Created by Leah Cluff on 7/8/19.
//  Copyright © 2019 Leah Cluff. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    var entry: Entry? {
        didSet{
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateViews(){
        guard let entry = entry else { return }
        titleTextField.text = entry.title
        bodyTextView.text = entry.body
    }

  
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty, !bodyTextView.text.isEmpty else { return }
        EntryController.sharedInstance.createEntry(title: title, body: bodyTextView.text) { (true) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        titleTextField.text = ""
        bodyTextView.text = ""
      
            }
        }
 
