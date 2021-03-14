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
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)
        cell.textLabel?.text = currentNote.text
        
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


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
