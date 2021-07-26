//
//  TestTableViewController.swift
//  firstApp
//
//  Created by Nguyen Nhat Duy on 05/04/2021.
//  Copyright © 2021 ChinhPV. All rights reserved.
//

import UIKit
import Kingfisher

class MealTableController: UITableViewController, UITextViewDelegate {
    
    //constant
    let mealCellNib: String = "MealCell"
    let emptyCellNib : String = "EmptyCell"
    let mealCellIdentifier = "MealCell"
    let emptyCellIdentifier = "EmptyCell"
    let apis : fetchAPIs = fetchAPIs()
    let group : DispatchGroup = DispatchGroup()
    //var
    var flagEdit: Bool = false
    var meals:[Meal] = [Meal]()
    var user_id : Int = 0
    var updateMeal:((_ meals: [Meal]) -> Void)?
    var content : [Meal] = [Meal]()
    var limit : Int = 8
    var offset: Int = 0
    var total : Int = 30
    
    
    
    override func viewDidLoad() {
        print("meal count: ", meals.count)
        super.viewDidLoad()
        tableInit()
        var index = 0
        while index < limit {
            content.append(self.meals[index])
            index += 1
        }
    }

    private func tableInit(){
//        let refreshControl = UIRefreshControl()
//        refreshControl.attributedTitle = NSAttributedString(string: "Loading")
//        self.tableView.addSubview(refreshControl)
//        refreshControl.addTarget(self, action: #selector(test(refreshControl: refreshControl)), for: .valueChanged)
        if meals.count != 0{
            self.tableView.rowHeight = 160
            self.tableView.separatorStyle = .singleLine
            self.navigationItem.title = "Meal List"
        } else {
            print("Empty cell init")
            self.navigationItem.title = "Meal Empty"
            let label = UILabel(frame: CGRect(x: 20, y: 20, width: 300, height: 60))
            label.text = "Click button + above to add a new meal"
            self.tableView.addSubview(label)
            self.tableView.isScrollEnabled = false
            self.tableView.separatorStyle = .none
            self.tableView.rowHeight = UITableView.automaticDimension
        }
    }
    
    @objc func test(refreshControl: UIRefreshControl){
        print("User load")
        refreshControl.endRefreshing()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.content.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: mealCellIdentifier, for: indexPath) as? MealCell else {
            fatalError("test cell error")
        }
        let meal = content[indexPath.row]
        cell.meal_id = meal.id
        cell.mealRating.rating = meal.rating
        cell.mealName.text = meal.name
        if meal.address.isEmpty {
            cell.mealAddress.text = "Address empty!!"
        } else{
            cell.mealAddress.text = meal.address
        }
        if meal.photo.isEmpty{
            cell.mealImg.image = UIImage(named: "emptyMealImg")
        } else {
            print("Meal photo: ", meal.photo)
            cell.mealImg.kf.setImage(with: URL(string: meal.photo))
        }
        return cell
    }
    
  
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            self.meals.remove(at: indexPath.row)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("User reach last row")
        if indexPath.row == content.count - 1 {
            if content.count < total {
                var index = content.count
                limit += index
                while index < (limit<total ? limit : total) {
                    content.append(self.meals[index])
                    index += 1
                }
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let meal = meals[indexPath.row]
        if let mealDetail = storyboard?.instantiateViewController(identifier: "MealDetail") as? UINavigationController {
            let vc = mealDetail.viewControllers.first as! MealDetailController
            vc.meal = meal
            vc.row = indexPath.row
            vc.update = { (meal: Meal, row: Int) in
                self.meals[row] = meal
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    //Func
    
    @IBAction func newMeal(_ sender: Any) {
        if let navCon = storyboard?.instantiateViewController(identifier: "MealDetail") as? UINavigationController {
            let mealDetail = navCon.viewControllers.first as! MealDetailController
            mealDetail.user_id = self.user_id
            mealDetail.flagCreate = true
            mealDetail.create = { (meal: Meal) in
                self.meals.append(meal)
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(mealDetail, animated: true)
        }
    }
    
    @IBAction func back(_ sender: Any) {
        updateMeal?(self.meals)
        self.dismiss(animated: true, completion: nil)
    }
    
}
