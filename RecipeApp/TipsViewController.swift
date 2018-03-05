//
//  TipsViewController.swift
//  RecipeApp
//
//  Created by Marcus Gardner on 28/02/2018.
//  Copyright © 2018 (s) Marcus Gardner. All rights reserved.
//

import UIKit

class TipsViewController: UIViewController {
    
    var currentTip = [TipsModel]()
    
    @IBOutlet weak var lblTipName: UILabel!
    @IBOutlet weak var lblTipDescrip: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblTipName.text = currentTip[0].name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
