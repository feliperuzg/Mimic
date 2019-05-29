//
//  ViewController.swift
//  MimicExample
//
//  Created by Felipe Ruz on 5/23/19.
//  Copyright © 2019 Felipe Ruz. All rights reserved.
//

import UIKit
import Mimic

class ViewController: UIViewController {
    private let endpoint = "https://rickandmortyapi.com/api/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapNormalRequest() {
        makeRequest()
    }
    
    @IBAction func didTapSwizzledRequest() {
        Mimic.mimic(
            request: request(with: <#T##MimicHTTPMethod#>, url: <#T##String#>),
            delay: 1,
            response: response(with: <#T##Any#>, status: <#T##Int#>, headers: <#T##[String : String]?#>))
        )
        makeRequest()
    }
    
    func show(json: [String: AnyObject]) {
        let alert = UIAlertController(
            title: "Result",
            message: json.description,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            Mimic.stopAllMimics()
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func makeRequest() {
        guard let url = URL(string: endpoint) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if
                let data = data,
                let text = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments]),
                let json = text as? [String: AnyObject]
            {
                DispatchQueue.main.async {
                    self.show(json: json)
                }
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "Error",
                        message: error.debugDescription,
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        task.resume()
    }
}

