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
    var car: Car!
    var brands: [Brand] = []
    private lazy var pickerView: UIPickerView  = {
        let picker = UIPickerView()
        picker.backgroundColor = .white
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        //loadBrands()
    }
    
    
    // MARK: - IBActions
    @IBAction func addEdit(_ sender: UIButton) {
        sender.isEnabled = false
        sender.backgroundColor = .gray
        sender.alpha = 0.5
        loading.startAnimating()
    
        loadDataCar()
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
        //setupToolBar()
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
        if car != nil {
            tfBrand.text = car.brand
            tfName.text = car.name
            tfPrice.text = String(car.price)
            scGasType.selectedSegmentIndex = car.gasType
            btAddEdit.setTitle("Alterar Carro", for: .normal)
        }
    }
    
    private func loadBrands() {
        ApiCars.getBrands { (brands) in
            self.brands = brands.sorted(by: {$0.name < $1.name})
            DispatchQueue.main.async {
                self.pickerView.reloadAllComponents()
            }
        } onError: { (error) in
            guard let errorDescription = error.errorDescription else { return }
            UIAlertController.showAlert(withTitle: "Atenção", withMessage: errorDescription)
        }
    }
    
    private func loadDataCar() {
        if car == nil {
            car = Car(id: nil)
        }
        
        guard let name = tfName.text else { return }
        guard let brand = tfBrand.text else { return }
        guard let price = Double(tfPrice.text ?? "") else { return }
        
        car.name = name
        car.brand = brand
        car.price = price
        car.gasType = scGasType.selectedSegmentIndex
    }
    
    private func saveOrUpdateCar() {
        if car.id == nil {
            ApiCars.saveCar(car: car) { (sucess) in
                self.goBack()
            }
        } else {
            ApiCars.updateCar(car: car) { (success) in
                self.goBack()
            }
        }
    }
    
    // MARK: obj-c Methods
    @objc private func cancel(){
        tfBrand.resignFirstResponder()
    }
    
    @objc private func done(){
        tfBrand.text = brands[pickerView.selectedRow(inComponent: 0)].name
        cancel()
    }
}


// MARK: -  UIPickerViewDelegate & UIPickerViewDataSource
extension AddEditViewController:  UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return brands.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let brand = brands[row]
        return brand.name
    }
}
