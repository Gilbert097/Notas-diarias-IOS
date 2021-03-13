//
//  note.swift
//  Notas diarias
//
//  Created by Gilberto Silva on 13/03/21.
//

import Foundation

public class NoteModel {
    let id: String
    let text: String
    let createdDate: Date?
    let modifiedDate: Date?
    
    init(id: String? = nil,
         text: String,
         createdDate: Date? = nil,
         modifiedDate: Date? = nil
    ) {
        self.id = id ?? UUID().uuidString
        self.text = text
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
    }
}
