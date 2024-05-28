//
//  TvCellRepositoryList.swift
//  SwiftyGit
//
//  Created by Tushar on 28/05/24.
//

import Foundation
import UIKit

class TvCellRepositoryList: UITableViewCell {
    @IBOutlet weak var vwCard: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lbldescription: UILabel!
    @IBOutlet weak var imgrepo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCardView()
    }
    
    private func setupCardView() {
        vwCard.layer.cornerRadius = 8
        vwCard.layer.shadowColor = UIColor.black.cgColor
        vwCard.layer.shadowOpacity = 0.1
        vwCard.layer.shadowOffset = CGSize(width: 0, height: 2)
        vwCard.layer.shadowRadius = 4
    }
    
    func configure(with repository: RepositoryListModel) {
        lblName.text = repository.name
        lbldescription.text = repository.description
        
        if let imageData = CoreDataManager.shared.fetchImageData(for: repository.id) {
            imgrepo.image = UIImage(data: imageData)
        } else if let url = URL(string: repository.owner.avatar_url) {
            imgrepo.sd_setImage(with: url)
        }
    }
}

