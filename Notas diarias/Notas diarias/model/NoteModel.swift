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
    let createdDate: Date
    let modifiedDate: Date?
    private let dateFormat = "dd/MM/yy HH:mm"
    init(id: String? = nil,
         text: String,
         createdDate: Date,
         modifiedDate: Date? = nil
    ) {
        self.id = id ?? UUID().uuidString
        self.text = text
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
    }
    
    func getTextDates() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let dateCreatedText = getCreatedDateFormatter(dateFormatter)
        let dateModifiedText = getModifiedDateFormatter(dateFormatter)
        
        var result = "Created Date: \(dateCreatedText)"
        
        if let dateModified = dateModifiedText {
            result.append(", Modified Date: \(dateModified)")
        }
        
        return result
    }
    
    private func getCreatedDateFormatter(_ dateFormatter: DateFormatter) -> String {
        return dateFormatter.string(from: self.createdDate)
    }
    
    private func getModifiedDateFormatter(_ dateFormatter: DateFormatter) -> String? {
        if let dateModified = self.modifiedDate {
            return dateFormatter.string(from: dateModified)
        }
        return nil
    }
}
