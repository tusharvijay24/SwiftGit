//
//  TvCellContributors.swift
//  SwiftyGit
//
//  Created by Tushar on 29/05/24.
//

import Foundation
import UIKit

class TvCellContributors: UITableViewCell {
    @IBOutlet weak var vwCard: UIView!
    @IBOutlet weak var ImgContributorsAvatar: UIImageView!
    @IBOutlet weak var lblContributorsName: UILabel!
    
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
    
//    func configure(with repository: RepositoryDetailsModel) {
//        lblContributorsName.text = repository.name
//        
//        if let url = URL(string: repository.owner.avatar_url) {
//            ImgContributorsAvatar.sd_setImage(with: url)
//        }
//    }
}
