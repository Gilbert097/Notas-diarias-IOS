//
//  ViewController.swift
//  Notas diarias
//
//  Created by Gilberto Silva on 13/03/21.
//

import UIKit

class NoteViewController: UIViewController {
    
    @IBOutlet weak var noteTextView: UITextView!
    
    var noteRepository: NoteRepository = { () -> NoteRepository in
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        return NoteRepository(viewContext: context)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func saveButtonItemClick(_ sender: UIBarButtonItem) {
        let text = noteTextView.text ?? ""
        let note = NoteModel(text: text, createdDate: Date())
        let isSuccess = noteRepository.save(note: note)
        
        if isSuccess {
            AlertHelper.shared.showMessage(viewController: self, message: "Nota salva com sucesso!")
        } else {
            AlertHelper.shared.showMessage(viewController: self, message: "Erro ao salvar nota!")
        }
        
    }
    
}

