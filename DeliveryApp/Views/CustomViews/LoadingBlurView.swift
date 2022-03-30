//
//  LoadingBlurView.swift
//  DeliveryApp
//
//  Created by Садык Мусаев on 30.03.2022.
//

import UIKit

class LoadingBlurView: UIView{
    
    private let blurView: UIVisualEffectView
    
    private let activityView: UIActivityIndicatorView
    
    init(frame: CGRect, blurStyle: UIBlurEffect.Style, activityStyle: UIActivityIndicatorView.Style) {
        
        activityView = UIActivityIndicatorView(style: activityStyle)
        activityView.frame = frame
        
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        
        super.init(frame: frame)
        
        self.alpha = 0.0
        self.addSubview(blurView, activityView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        activityView.frame = self.frame
        blurView.frame = self.frame
    }
    
    func enableActivityWithAnimation(completionBlock: @escaping () -> ()){
        
        self.activityView.startAnimating()
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [ .curveEaseOut]) {
            
            self.alpha = 1.0
        } completion: { _ in
            
            completionBlock()
        }

    }
    
    func disableActivityWithAnimation(completionBlock: @escaping () -> ()){
        
        UIView.animate(withDuration: 0.25, delay: 0.5, options: [ .curveEaseOut]) {
            
            self.alpha = 0.0
        } completion: { _ in
            
            self.activityView.stopAnimating()
            completionBlock()
        }
    }
    
    func enableActivityWithAnimation(withDelay delay: TimeInterval, completionBlock: @escaping () -> ()){
        
        self.activityView.startAnimating()
        
        UIView.animate(withDuration: 0.5, delay: delay, options: [ .curveEaseOut]) {
            
            self.alpha = 1.0
        } completion: { _ in
            
            completionBlock()
        }
    }
    
    func disableActivityWithAnimation(withDelay delay: TimeInterval, completionBlock: @escaping () -> ()){
        
        UIView.animate(withDuration: 0.5, delay: delay, options: [ .curveEaseOut]) {
            
            self.alpha = 0.0
        } completion: { _ in
            
            self.activityView.stopAnimating()
            completionBlock()
        }
    }
}
