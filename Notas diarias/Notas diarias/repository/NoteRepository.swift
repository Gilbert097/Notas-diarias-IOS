//
//  NoteRepository.swift
//  Notas diarias
//
//  Created by Gilberto Silva on 13/03/21.
//

import Foundation
import CoreData

private extension String {
    static let id = "id"
    static let text = "text"
    static let createdDate = "created_date"
    static let modifiedDate = "modified_date"
}

public class NoteRepository{
    private let entityName = "Note"
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext){
        self.viewContext = viewContext
    }
   
    public func save(note: NoteModel) -> Bool {
        do {
            let noteEntity = NSEntityDescription.insertNewObject(forEntityName: self.entityName, into: self.viewContext)
            updateEntityByModel(noteEntity, note)
            try self.viewContext.save()
            print("Nota salva com sucesso!")
            return true
        } catch {
            print(error.localizedDescription)
        }
        return false
    }

    public func update(note: NoteModel) -> Bool{
        do {
            let request = createRequestWithIdPredicate(noteId: note.id)
            let entitys = try self.viewContext.fetch(request)
            if let list = entitys as? [NSManagedObject] {
                for noteItem in list {
                    updateEntityByModel(noteItem, note)
                    try self.viewContext.save()
                    print("Registro alterado com sucesso!")
                    return true
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return false
    }
//
//    public func delete(userModel: NoteModel){
//        do {
//            let request = createRequestWithIdPredicate(userId: userModel.id)
//            let usersEntity = try self.viewContext.fetch(request)
//            if let list = usersEntity as? [NSManagedObject] {
//                for userItem in list {
//                    self.viewContext.delete(userItem)
//                    try self.viewContext.save()
//                    print("Registro deletado com sucesso!")
//                }
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//
    private func createRequestWithIdPredicate(noteId: String) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)

        let idPredicate = NSPredicate(format: "\(String.id) ==  %@", noteId)
        request.predicate = idPredicate

        return request
    }

    private func updateEntityByModel(_ noteEntity: NSManagedObject, _ note: NoteModel) {
        noteEntity.setValue(note.id, forKey: .id)
        noteEntity.setValue(note.text, forKey: .text)
        noteEntity.setValue(note.createdDate, forKey: .createdDate)
        noteEntity.setValue(note.modifiedDate, forKey: .modifiedDate)
    }

    public func getAll() -> [NoteModel]?
    {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
        return executeFecth(request)
    }
//
//    public func getAllAndOrderById() -> [NoteModel]?
//    {
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
//
//        let idSortDescriptor = NSSortDescriptor(key: .id, ascending: true)
//        request.sortDescriptors = [idSortDescriptor]
//
//        return executeFecth(request)
//    }
//
//    public func getByName(name: String) -> [NoteModel]?
//    {
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
//
//        let predicate = NSPredicate(format: "\(String.name) contains %@", name)
//        //[c] -> Este sinal trata todas as letras como minusculo.
//        //let predicate = NSPredicate(format: "\(String.name) contains [c] %@", name)
//
//        //beginwith -> retorna valores que começam com o valor informado.
//        //let predicate = NSPredicate(format: "\(String.name) beginwith %@", name)
//
//        request.predicate = predicate
//
//        return executeFecth(request)
//    }
//
//    public func getBySearch(text: String) -> [NoteModel]?
//    {
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: self.entityName)
//
//        let namePredicate = NSPredicate(format: "\(String.name) ==  %@", text)
//        let idPredicate = NSPredicate(format: "\(String.id) ==  %@", text)
//        let predicates = [namePredicate, idPredicate]
//        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
//
//        return executeFecth(request)
//    }
//
//    public func getById(id: String) -> NoteModel?
//    {
//        let request = createRequestWithIdPredicate(userId: id)
//
//        if let result = executeFecth(request) {
//            return result.first
//        }
//
//        return nil
//    }
//
    private func executeFecth(_ request: NSFetchRequest<NSFetchRequestResult>) -> [NoteModel]? {
        var notes: [NoteModel] = []
        do {
            let entitys = try self.viewContext.fetch(request)
            if let list = entitys as? [NSManagedObject] {
                for noteItem in list {
                    let note = createNoteByEntity(noteEntity: noteItem)
                    notes.append(note)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return notes
    }

    private func createNoteByEntity(noteEntity: NSManagedObject)-> NoteModel {
        let id: String? = noteEntity.value(forKey: .id) as? String
        let text: String = noteEntity.value(forKey: .text) as? String ?? ""
        let createdDate: Date? = noteEntity.value(forKey: .createdDate) as? Date
        let modifieldDate: Date? = noteEntity.value(forKey: .modifiedDate) as? Date

        return NoteModel(id: id, text: text, createdDate: createdDate, modifiedDate: modifieldDate)
    }
}
