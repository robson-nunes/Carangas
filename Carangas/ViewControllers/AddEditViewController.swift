//
//  AddEditViewController.swift
//  Carangas
//
//  Created by Eric Brito.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit
import RNActivityView

class AddEditViewController: UIViewController {
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var tfBrand: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var scGasType: UISegmentedControl!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    
    // MARK: - Properties
    private lazy var pickerView: UIPickerView  = {
        let picker = UIPickerView()
        picker.backgroundColor = .white
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    var viewModel = AddEditCarViewModel()
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadBrands()
    }
    
    
    // MARK: - IBActions
    @IBAction func addEdit(_ sender: UIButton) {
        sender.isEnabled = false
        sender.backgroundColor = .gray
        sender.alpha = 0.5
        loading.startAnimating()
        
        saveOrUpdateCar()
    }   
    
    
    // MARK: - Private Methods
    private func goBack() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupView() {
        setupInit()
        setupToolBar()
    }
    
    private func setupToolBar() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        toolbar.tintColor = UIColor(named: "main")
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [cancelButton, spaceButton, doneButton]
        tfBrand.inputAccessoryView = toolbar
        tfBrand.inputView = pickerView
    }
    
    private func setupInit() {
        if viewModel.currentState == .edit {
            tfBrand.text = viewModel.brand
            tfName.text = viewModel.name
            tfPrice.text = viewModel.price
            scGasType.selectedSegmentIndex = viewModel.gasType
            btAddEdit.setTitle("Alterar", for: .normal)
        }
    }
    
    private func loadBrands() {
        viewModel.loadBrands {
            DispatchQueue.main.async {
                self.pickerView.reloadAllComponents()
            }
        }
    }
    
    private func saveOrUpdateCar() {
        viewModel.addEditCar(brand: tfBrand.text!,
                             name: tfName.text!,
                             gasType: scGasType.selectedSegmentIndex,
                             price: tfPrice.text!, completion: { result in
                                switch result {
                                case .failure(let error):
                                    print(error.localizedDescription)
                                case .success:
                                    self.goBack()
                                }
                             })
    }
    
    // MARK: obj-c Methods
    @objc private func cancel(){
        tfBrand.resignFirstResponder()
    }
    
    @objc private func done(){
        if let brand = viewModel.getBrand(at: pickerView.selectedRow(inComponent: 0)) {
            tfBrand.text = brand.name
        }
        cancel()
    }
}


// MARK: -  UIPickerViewDelegate & UIPickerViewDataSource
extension AddEditViewController:  UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.numberOfBrands
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let brand = viewModel.getBrand(at: row) else { return "" }
        return brand.name
    }
}
