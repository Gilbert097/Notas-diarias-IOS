//
//  TableViewController.swift
//  Notas diarias
//
//  Created by Gilberto Silva on 13/03/21.
//

import UIKit

class NoteTableViewController: UITableViewController {
    
    private var notes: [NoteModel] = []
    
    private let noteRepository: NoteRepository = { () -> NoteRepository in
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        return NoteRepository(viewContext: context)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 125
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadNotes()
    }
    
    private func loadNotes() {
        self.notes = noteRepository.getAll() ?? []
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int { 1 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { notes.count }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentNote = notes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteTableViewCell
        cell.textNoteLabel?.text = currentNote.text
        cell.createdDateLabel?.text = currentNote.getCreatedDateFormatted()
        cell.modifiedDateLabel?.text = currentNote.getModifiedDateFormatted()

        //Ocultando linha de separação dos items
        //cell.separatorInset = UIEdgeInsets(top: CGFloat(0), left: cell.bounds.size.width, bottom: CGFloat(0), right: CGFloat(0));
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentNote = notes[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "noteDetail", sender: currentNote)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "noteDetail", let item = sender {
            let  noteViewController  = segue.destination as! NoteViewController
            noteViewController.noteSelected = item as? NoteModel
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let currentNote = notes[indexPath.row]
        if editingStyle == .delete {
            deleteCell(currentNote)
        }
    }
    
    private func deleteCell(_ currentNote: NoteModel) {
        let message = "Deseja deletar a nota: \(currentNote.text)?"
        let positiveHandler:((UIAlertAction) -> Void)? = { (action) in
            let isSuccess = self.noteRepository.delete(note: currentNote)
            if isSuccess {
                AlertHelper.shared.showMessage(viewController: self, message: "Nota deletada com sucesso!")
                self.loadNotes()
            }else {
                AlertHelper.shared.showMessage(viewController: self, message: "Error ao deletar nota!")
            }
        }
        AlertHelper.shared.showConfirmationMessage(viewController: self, message: message, positiveHandler: positiveHandler)
    }
}
