////
////  UIView.swift
////  Tracker
////
////  Created by Anton Filipchuk on 05.12.2023.
////
//
//import UIKit
//
//extension UIView {
//    @discardableResult func edgesToSuperview() -> Self {
//        guard let superview = superview else {fatalError("View не в иерархии")}
//        
//        translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            topAnchor.constraint(equalTo: superview.topAnchor),
//            leftAnchor.constraint(equalTo: superview.leftAnchor),
//            rightAnchor.constraint(equalTo: superview.rightAnchor),
//            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
//        ])
//        
//        return self
//    }
//}
