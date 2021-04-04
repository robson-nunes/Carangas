//
//  CarViewController.swift
//  Carangas
//
//  Created by Eric Brito on 21/10/17.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit
import WebKit

class CarViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var lbBrand: UILabel!
    @IBOutlet weak var lbGasType: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    
    // MARK: - Properties
    var car: Car!
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupWebView()
    }
    
    
    // MARK: - Flow
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddEditViewController
        vc.car = car
    }
    
    // MARK: - Flow
    private func loadCar() {
        self.title = car.name
        lbBrand.text = car.brand
        lbGasType.text = car.gas
        lbPrice.text = String(car.price)
    }
    
    private func setupWebView() {
        loadCar()
        let searchTerm = carSearchTerm(car)
        let urlString = "https://www.google.com.br/search?q=\(searchTerm)0&tbm=isch"
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsLinkPreview = true
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.load(request)
    }
    
    private func carSearchTerm(_ carSearch: Car) -> String {
        let searchTerm = (carSearch.name + "+" + carSearch.brand).replacingOccurrences(of: " ", with: "+")
        return searchTerm
    }
}


// MARK: -  WKNavigationDelegate & WKUIDelegate
extension CarViewController: WKNavigationDelegate, WKUIDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loading.stopAnimating()
    }
}
