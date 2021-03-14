//
//  NoteTableViewCell.swift
//  Notas diarias
//
//  Created by Gilberto Silva on 14/03/21.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var textNoteLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var modifiedDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
