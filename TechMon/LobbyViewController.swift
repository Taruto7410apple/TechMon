//
//  LobbyViewController.swift
//  TechMon
//
//
//

import UIKit

class LobbyViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var staminaLabel: UILabel!
    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var staminaNameLabel: UILabel!
    @IBOutlet  var battleButton:UIButton!
    
    let techMonManager=TechMonManager.shared
    
    var stamina : Int = 100
    var staminaTimer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()

        //UIの設定
        nameLabel.text="勇者"
        self.setLabelFont(label:nameLabel)
        staminaLabel.text = "\(stamina)/100"
        self.setLabelFont(label:staminaLabel)
        
        self.setLabelFont(label:levelLabel)
        self.setLabelFont(label:staminaNameLabel)
        
        //ボタンのフォントの設定
        self.setButtonFont(button:battleButton)
        
        //タイマーの設定
        staminaTimer=Timer.scheduledTimer(
            timeInterval: 3,
            target: self,
            selector: #selector(updateStaminaValue),
            userInfo: nil,
            repeats: true)
        
        staminaTimer.fire()
    }
    
    //ロビ画面が見えるようになると呼ばれる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        techMonManager.playBGM(fileName: "lobby")
    }
    //ロビー画面が見えなくなる時に呼ばれる
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        techMonManager.stopBGM()
    }
    
    @IBAction func toBattle(){
        
        //スタミナファ50以上あればスタミナ50を消費して戦闘画面へ
        if stamina >= 50{
            stamina -= 50
            staminaLabel.text="\(stamina) / 100"
            performSegue(withIdentifier: "toBattle", sender: nil)
        }else{
            let alert = UIAlertController(
                title:"バトルに行けません",
                message: "スタミナをためてください",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK", style:.default,handler:nil))
            present(alert,animated: true,completion: nil)
            
        }
    }
    
    //スタミナの回復
    @objc func updateStaminaValue(){
        if stamina < 100{
            stamina+=1
            staminaLabel.text = "\(stamina) / 100"
        }
    }
    
    func setLabelFont(label:UILabel){
        label.font=UIFont(name: "MisakiGothic", size: 17)
    }
    func setButtonFont(button:UIButton){
        button.titleLabel!.font=UIFont(name: "MisakiGothic", size: 17)!
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
