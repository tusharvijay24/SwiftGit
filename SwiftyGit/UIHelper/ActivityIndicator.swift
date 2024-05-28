//
//  ActivityIndicator.swift
//  SwiftyGit
//
//  Created by Tushar on 28/05/24.
//

import Foundation
import UIKit

var container: UIView = UIView()
var loadingView: UIView = UIView()
var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

func ShowActivityIndicator(uiView: UIView, indicatorColor: UIColor = UIColor.black) {
    container.frame = uiView.frame
    container.center = uiView.center
    container.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.5)
    
    loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
    loadingView.center = uiView.center
    loadingView.backgroundColor = .clear
    loadingView.clipsToBounds = true
    loadingView.layer.cornerRadius = 10
    
    activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
    activityIndicator.style = UIActivityIndicatorView.Style.large
    activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
    activityIndicator.color = indicatorColor
    
    loadingView.addSubview(activityIndicator)
    container.addSubview(loadingView)
    uiView.addSubview(container)
    activityIndicator.startAnimating()
}

func HideActivityIndicator(uiView: UIView) {
    activityIndicator.stopAnimating()
    container.removeFromSuperview()
}

func Round(str: NSString) -> String {
    return String(format: "%.1f", (str.floatValue))
}

