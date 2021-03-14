//
//  ViewController.swift
//  Notas diarias
//
//  Created by Gilberto Silva on 13/03/21.
//

import UIKit

class NoteViewController: UIViewController {
    
    @IBOutlet weak var noteTextView: UITextView!
    
    private let noteRepository: NoteRepository = { () -> NoteRepository in
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        return NoteRepository(viewContext: context)
    }()
    
    var noteSelected: NoteModel? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    private func initialize() {
        //Configurações iniciais
        self.noteTextView.becomeFirstResponder()
        
        if let note = noteSelected {
            noteTextView.text = note.text
        }
    }
    
    @IBAction func saveButtonItemClick(_ sender: UIBarButtonItem) {
        if let note = noteSelected {
            updateNote(note: note)
        } else {
            saveNote()
        }
    }
    
    private func saveNote() {
        let text = noteTextView.text ?? ""
        let note = NoteModel(text: text, createdDate: Date())
        let isSuccess = noteRepository.save(note: note)
        
        if isSuccess {
            AlertHelper.shared.showMessage(viewController: self, message: "Nota salva com sucesso!") { _ in
                //Retorna para a tela anterior
                self.navigationController?.popToRootViewController(animated: true)
            }
        } else {
            AlertHelper.shared.showMessage(viewController: self, message: "Erro ao salvar nota!")
        }
    }
    
    private func updateNote(note:NoteModel) {
        let text = noteTextView.text ?? ""
        let note = NoteModel(id: note.id, text: text, createdDate: note.createdDate, modifiedDate: Date())
        let isSuccess = noteRepository.update(note: note)
        
        if isSuccess {
            AlertHelper.shared.showMessage(viewController: self, message: "Nota atualizada com sucesso!") { _ in
                //Retorna para a tela anterior
                self.navigationController?.popToRootViewController(animated: true)
            }
        } else {
            AlertHelper.shared.showMessage(viewController: self, message: "Erro ao atualizar nota!")
        }
    }
    
}

