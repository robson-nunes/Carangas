//
//  CarsTableViewController.swift
//  Carangas
//
//  Created by Eric Brito on 21/10/17.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit
import RNActivityView

class CarsTableViewController: UITableViewController {
    
    
    // MARK: - Properties
    var cars: [Car] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
        
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCars()
    }
    
    
    // MARK: - Flow
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewSegue" {
            let vc = segue.destination as! CarViewController
            vc.car = cars[tableView.indexPathForSelectedRow!.row]
        }
    }
    
    // MARK: - Private methods
    private func loadCars() {
        self.view.showActivityView(withLabel: "Carregando carros ...")
        ApiCars.getCars { (cars) in
            DispatchQueue.main.async {
                self.view.hideActivityView()
            }
            self.cars = cars
        } onError: { (error) in
            DispatchQueue.main.async {
                self.view.hideActivityView()
            }
            UIAlertController.showAlert(withTitle: "Atenção", withMessage: error.errorDescription!)
        }
    }
}


// MARK: - Table view data source
extension CarsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let car = cars[indexPath.row]
        
        cell.textLabel?.text = car.name
        cell.detailTextLabel?.text = car.brand
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let car = cars[indexPath.row]
            
            ApiCars.deleteCar(car: car) { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.cars.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                } else {
                    UIAlertController.showAlert(withTitle: "Atenção", withMessage: "Não é possível excluir")
                }
            }
        }
    }
}
