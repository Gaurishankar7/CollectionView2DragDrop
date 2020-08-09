//
//  ViewController.swift
//  CellPassbyCV
//
//  Created by GS on 09/08/20.
//  Copyright © 2020 Gaurishankar Vibhute. All rights reserved.
//

import UIKit


class DataItem : Equatable {
    
    var indexes: String
    var colour: UIColor
    init(_ indexes: String, _ colour: UIColor = UIColor.clear) {
        self.indexes    = indexes
        self.colour     = colour
    }
    
    static func ==(lhs: DataItem, rhs: DataItem) -> Bool {
        return lhs.indexes == rhs.indexes && lhs.colour == rhs.colour
    }
}

extension UIColor {
    static var kdBrown:UIColor {
        return UIColor(red: 177.0/255.0, green: 88.0/255.0, blue: 39.0/255.0, alpha: 1.0)
    }
    static var kdGreen:UIColor {
        return UIColor(red: 138.0/255.0, green: 149.0/255.0, blue: 86.0/255.0, alpha: 1.0)
    }
   
    
}

let colours = [UIColor.kdBrown, UIColor.kdGreen]

class ViewController: UIViewController, KDDragAndDropCollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var firstCollectionView: KDDragAndDropCollectionView!
    @IBOutlet weak var secondCollectionView: KDDragAndDropCollectionView!
    
    var data : [[DataItem]] = [[DataItem]]() // just for this example
    
    var dragAndDropManager : KDDragAndDropManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        self.dragAndDropManager = KDDragAndDropManager(canvas: self.view, collectionViews: all)
//
        // generate some mock data (change in real world project)
        
        let width = 100
        let layout = firstCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        
           self.data = (0...1).map({ i in (0...20).map({ j in DataItem("\(String(i)):\(String(j))", colours[i])})})
        
           self.dragAndDropManager = KDDragAndDropManager(
               canvas: self.view,
               collectionViews: [firstCollectionView, secondCollectionView]
        )
    }
    
  
    
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[collectionView.tag].count
    }
    
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ColorCell
        
        let dataItem = data[collectionView.tag][indexPath.item]
            
        cell.label.text = String(indexPath.item) + "\n\n" + dataItem.indexes
        cell.backgroundColor = dataItem.colour
        
        cell.isHidden = false
        
        if let kdCollectionView = collectionView as? KDDragAndDropCollectionView {
            
            if let draggingPathOfCellBeingDragged = kdCollectionView.draggingPathOfCellBeingDragged {
                
                if draggingPathOfCellBeingDragged.item == indexPath.item {
                    
                    cell.isHidden = true
                    
                }
            }
        }
        
        return cell
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout

         func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
         {
            return CGSize(width: 100.0, height: 100.0)
         }
    
   // MARK : KDDragAndDropCollectionViewDataSource
   
   func collectionView(_ collectionView: UICollectionView, dataItemForIndexPath indexPath: IndexPath) -> AnyObject {
    
    print("data is \(data[collectionView.tag][indexPath.item])")
       return data[collectionView.tag][indexPath.item]
   }
   func collectionView(_ collectionView: UICollectionView, insertDataItem dataItem : AnyObject, atIndexPath indexPath: IndexPath) -> Void {
       
 
       if let di = dataItem as? DataItem {
        print("index is \(di.indexes)")
        let tmp = di.indexes.split(separator: ":")
        let tmp1 = Int(tmp[1])
        print("index new is \(tmp1)")
        data[collectionView.tag].insert(di, at: tmp1!)
       }
       
       
   }
   func collectionView(_ collectionView: UICollectionView, deleteDataItemAtIndexPath indexPath : IndexPath) -> Void {
       data[collectionView.tag].remove(at: indexPath.item)
   }
   
   func collectionView(_ collectionView: UICollectionView, moveDataItemFromIndexPath from: IndexPath, toIndexPath to : IndexPath) -> Void {
       
       let fromDataItem: DataItem = data[collectionView.tag][from.item]
       data[collectionView.tag].remove(at: from.item)
       data[collectionView.tag].insert(fromDataItem, at: from.item)
   }
   
   func collectionView(_ collectionView: UICollectionView, indexPathForDataItem dataItem: AnyObject) -> IndexPath? {
       
       guard let candidate = dataItem as? DataItem else { return nil }
       
       for (i,item) in data[collectionView.tag].enumerated() {
           if candidate != item { continue }
           return IndexPath(item: i, section: 0)
       }
       
       return nil
       
   }
    
   

}

