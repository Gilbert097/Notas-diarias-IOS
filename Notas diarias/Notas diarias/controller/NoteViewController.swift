//
//  ViewController.swift
//  Notas diarias
//
//  Created by Gilberto Silva on 13/03/21.
//

import UIKit

class NoteViewController: UIViewController {

    @IBOutlet weak var noteTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("NoteViewController - viewDidLoad")
    }

    @IBAction func saveButtonItemClick(_ sender: UIBarButtonItem) {
    }
    
}

