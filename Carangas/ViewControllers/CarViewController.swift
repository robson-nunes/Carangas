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
    var viewModel: CarDetailViewModel!
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard let viewModel = viewModel else { return }
        setupView(viewModel)
    }
    
    
    // MARK: - Flow
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AddEditViewController
        let car = viewModel.car
        vc.viewModel = AddEditCarViewModel(car: car)
    }
    
    private func setupView(_ viewModel: CarDetailViewModel) {
        title = viewModel.name
        
        lbBrand.text = viewModel.brand
        lbPrice.text = viewModel.price
        lbGasType.text = viewModel.gas
        
        let searchTerm = viewModel.nameSearch
        let urlString = "https://www.google.com.br/search?q=\(searchTerm)0&tbm=isch"
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsLinkPreview = false
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.load(request)
    }
}


// MARK: -  WKNavigationDelegate & WKUIDelegate
extension CarViewController: WKNavigationDelegate, WKUIDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loading.stopAnimating()
    }
}
