//
//  Loader.swift
//  PremierSwift
//
//  Created by Senthil Kumar on 27/04/23.
//  Copyright © 2023 Deliveroo. All rights reserved.
//

import UIKit

fileprivate let overlayTag: Int = -999
fileprivate let activityIndicatorTag: Int = -1000
public let footerViewSpinnerHeight : CGFloat = 100

extension UIViewController {
    private var overlayContainerView: UIView {
        if let navigationView: UIView = navigationController?.view {
            return navigationView
        }
        return view
    }
    // Showing loader
    func showLoaderIndicatorView() {
        self.overlayContainerView.showLoader()
    }
    // Hiding loader
    func hideIndicatorView() {
        self.overlayContainerView.hideLoader()
    }
}

extension UIView {
    
    // Showing loader
    func showLoader() {
        self.setIndicatorView()
    }
    // Hiding loader
    func hideLoader() {
        self.removeIndicatorView()
    }
    
    private var activityIndicator: UIActivityIndicatorView {
        let view: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tag = activityIndicatorTag
        return view
    }

    private var overlayView: UIView {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.tag = overlayTag
        return view
    }

    private func setIndicatorView() {
        guard !isIndicatorDisplaying() else { return }
        let overlayView: UIView = self.overlayView
        let activityIndicatorView: UIActivityIndicatorView = self.activityIndicator

        //adding views
        overlayView.addSubview(activityIndicatorView)
        addSubview(overlayView)

        //overlay constraints
        overlayView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        overlayView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true

        //indicator constraints
        activityIndicatorView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor).isActive = true

        activityIndicatorView.startAnimating()
    }

    private func removeIndicatorView() {
        guard let overlayView = viewWithTag(overlayTag), let activityIndicator = viewWithTag(activityIndicatorTag) as? UIActivityIndicatorView else {
            return
        }
        UIView.animate(withDuration: 0.2, animations: {
            overlayView.alpha = 0.0
            activityIndicator.stopAnimating()
        }) { _ in
            activityIndicator.removeFromSuperview()
            overlayView.removeFromSuperview()
        }
    }
    
    private func isIndicatorDisplaying() -> Bool {
        viewWithTag(overlayTag) != nil && viewWithTag(activityIndicatorTag) != nil
    }
    
    func getFooterViewSpinner() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: footerViewSpinnerHeight))
        let spinnerView = UIActivityIndicatorView()
        spinnerView.center = footerView.center
        footerView.addSubview(spinnerView)
        spinnerView.startAnimating()
        return footerView
    }
}
