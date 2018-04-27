//
//  EmotionApiController.swift
//  PokePicker
//
//  Created by Jordan Lafontant on 4/18/18.
//  Copyright © 2018 Sportify, INC. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit


class EmotionApiController: UIViewController {

    
    
    var image: UIImage!
    @IBOutlet weak var emotionImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emotionImage.image = image
        let pokemon = ["charizard", "pickachu", "squirtle", "snorlax", "jigglypuff", "wobbuffet", "jynx"]
        let randomItem = pokemon[Int(arc4random_uniform(UInt32(pokemon.count)))]
        label.text = randomItem
    }
    
    
    
    func getEmotions(_ completion: @escaping (_ response: [[String : AnyObject]]?) -> Void) {
        
        let path = "https://api.projectoxford.ai/emotion/v1.0/recognize"
        
        let requestURL = URL(string: path)!
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        let key = "8886105a98004128a5fb00fccfd74802"
        
        // Request Parameter
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        request.httpBody =  UIImagePNGRepresentation(image)
        

        
        request.setValue(key, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        
        
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            if error != nil{
                print("Error -> \(error)")
                completion(nil)
                return
            } else {
                
                if let results = try! JSONSerialization.jsonObject(with: data!, options: []) as? [[String : AnyObject]] {
                    // Hand dict over
                    DispatchQueue.main.async {
                        completion(results)
                        print(results)
                    }
                }
                else {
                    print((try! JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]) ?? "Something went wrong with the Emotion API")
                }
            }
            
        }
        task.resume()
    }
    
}



