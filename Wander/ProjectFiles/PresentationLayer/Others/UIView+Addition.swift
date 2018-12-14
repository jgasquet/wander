//
//  UIButton+Addition.swift
//  Wander
//
//  Created by IOS on 04/12/17.
//  Copyright © 2017 IOS. All rights reserved.
//

import UIKit

extension UIView {
    
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyBorder(color: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 4.0
        self.layer.masksToBounds = true
    }
    
    func applyShadow(color: UIColor) {
        self.layer.shadowColor = COLOR_THEME_BLUE.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 4.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 4.0
    }
    
    func applyBorderAndShadow(color: UIColor) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1.0
        self.layer.shadowColor = COLOR_THEME_BLUE.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 4.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 4.0
    }
    
    func removeBorder() {
        self.layer.borderColor = nil
        self.layer.borderWidth = 0.0
    }
    
    func applyCornerRadius() {
        self.layer.cornerRadius = 4.0
        self.layer.masksToBounds = true
    }
    
    func showWithAnimation() {
        let dur: Float = 0.2
        self.isHidden = false
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: TimeInterval(dur), animations: {
            self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }, completion:{ _ in
            UIView.animate(withDuration: TimeInterval(dur), animations: {
                self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }, completion:{ _ in
                UIView.animate(withDuration: TimeInterval(dur), animations: {
                    self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }, completion:{ _ in
                    
                })
            })
        })
    }
    
    func hideWithAnimation() {
        let dur: Float = 0.2
        self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        UIView.animate(withDuration: TimeInterval(dur), animations: {
            self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }, completion:{ _ in
            UIView.animate(withDuration: TimeInterval(dur), animations: {
                self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion:{ _ in
                UIView.animate(withDuration: TimeInterval(dur), animations: {
                    self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                }, completion:{ _ in
                    self.isHidden = true
                })
            })
        })
    }
    
    func createGradientView(FirstColor: UIColor, SecondColor: UIColor, width: CGFloat, height: CGFloat, direction: String, alpha: CGFloat) {
        for view in self.subviews{
            view.removeFromSuperview()
        }
        let vw: UIView = UIView()
        vw.frame = CGRect(x: 0, y: 0, width: width, height: height)
        vw.backgroundColor = UIColor.clear
        self.addSubview(vw)
        self.sendSubview(toBack: vw)
        var gradientLayer: CAGradientLayer!
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = vw.frame
        gradientLayer.colors = [FirstColor.cgColor, SecondColor.cgColor]
        if direction == HORIZONTAL {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
        else {
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        }
        vw.layer.addSublayer(gradientLayer)
        vw.alpha = alpha
    }
}

extension UIViewController {
    
    func showMessage(message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showProgressIndicator() -> UIActivityIndicatorView {
        let myActInd = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        myActInd.center = view.center
        myActInd.color = COLOR_THEME_BLUE
        myActInd.startAnimating()
        view.addSubview(myActInd)
        view.bringSubview(toFront: myActInd)
        return myActInd
    }
    
    func hideProgressIndicator(actInd: UIActivityIndicatorView) {
        actInd.stopAnimating()
        actInd.removeFromSuperview()
    }
}

extension String {
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isValidPhoneNo: Bool {
        let phoneRegEx = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phoneTest.evaluate(with: self)
    }
    
    var isValidPasword: Bool {
        return self.count >= 6 && self.count <= 12 ? true : false
    }
    
    var isNumeric: Bool {
        if let _ = Int(self) {
            return true
        }
        return false
    }
}

