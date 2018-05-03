//
//  ViewController.swift
//  XcodeNew
//
//  Created by Thuc on 9/20/17.
//  Copyright © 2017 NetworkingThuc. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
	
    let networkUrl = "https://api.themoviedb.org/3/movie/"
    let api_key = "6ecbe31355b17d770f1b37056322a3cd"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        download()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func download() { 
        
        let op = OperationQueue()
        op.maxConcurrentOperationCount = 1
        
        for i in 2..<101 {
            let baseURL = URL(string: networkUrl)
            let component = "\(i)?api_key=\(api_key)"
            let url = baseURL?.appendingPathComponent(component)
            if let url = url {
                let task = NetworkOperation(url: url) { 
                	(data, error) in
                    if let data = data {
                        print("=== time: \(i) ==== \(data)")
                        return
                    }
                    if let error = error {
                        print("=== time: \(i) ==== \(error.localizedDescription)")
                        return
                    }
                }
                op.addOperation(task)
            }
        }
    }
}
