//
//  Extensions.swift
//  InstagramClone
//
//  Created by Nuno Pereira on 02/12/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}

extension Date {
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let mounth = 4 * week
        
        let quocient: Int
        let unit: String
        
        if secondsAgo < minute {
            quocient = secondsAgo
            unit = "second"
        }
        else if secondsAgo < hour {
            quocient = secondsAgo / minute
            unit = "min"
        }
        else if secondsAgo < day {
            quocient = secondsAgo / hour
            unit = "hour"
        }
        else if secondsAgo < week {
            quocient = secondsAgo / day
            unit = "day"
        }
        else if secondsAgo < mounth {
            quocient = secondsAgo / week
            unit = "week"
        }
        else {
            quocient = secondsAgo / mounth
            unit = "mounth"
        }
        
        return "\(quocient) \(unit)\(quocient == 1 ? "" : "s") ago"
    }
}
