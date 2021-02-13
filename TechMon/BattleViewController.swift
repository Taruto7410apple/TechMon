//
//  BattleViewController.swift
//  TechMon
//
//
//

import UIKit

class BattleViewController: UIViewController {
    
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var playerImageView: UIImageView!
    @IBOutlet var playerHPLabel: UILabel!
    @IBOutlet var playerMPLabel:UILabel!
    @IBOutlet var playerTPLabel:UILabel!
    
    @IBOutlet var enemyNameLabel:UILabel!
    @IBOutlet var enemyImageView: UIImageView!
    @IBOutlet var enemyHPLabel:UILabel!
    @IBOutlet var enemyMPLabel:UILabel!
    
    let techMonManager = TechMonManager.shared//音楽再生クラス
    
//    var playerHP=100
//    var playerMP=0
//    var enemyHP=200
//    var enemyMP=0
    
    var player:Character!
    var enemy:Character!
    
    var gameTimer:Timer!//ゲーム用タイマー
    var isPlayerAttackAvailable: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //キャラクターの読み込み
        player=techMonManager.player
        enemy=techMonManager.enemy
        
        //プレイヤーのステータスを反映
          playerNameLabel.text=player.name
//        playerImageView.image=UIImage(named: "yusya.png")
          playerImageView.image=player.image
//        playerHPLabel.text="\(playerHP) / 100"
//        playerMPLabel.text="\(playerMP) / 20"
        
        //敵のステータスを反映
          enemyNameLabel.text=enemy.name
          enemyImageView.image=enemy.image
//        enemyHPLabel.text="\(enemyHP) / 200"
//        enemyMPLabel.text="\(enemyMP) / 35"
    
        
        //ゲームスタート
        gameTimer=Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateGame), userInfo: nil, repeats: true)
        
        gameTimer.fire()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        techMonManager.playBGM(fileName: "BGM_battle001")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        techMonManager.stopBGM()
        techMonManager.resetStatus()
    }
    
    //タイマーで実行する・0.1秒ごとにゲームの状態を更新する
    @objc func updateGame(){
        //プレイヤーのステータスを更新
        player.currentMP+=1
        if player.currentMP >= 20 {//MPが20超えたら攻撃できる・MPは21以上にならない
            isPlayerAttackAvailable=true
            player.currentMP=20
        } else {
            isPlayerAttackAvailable = false
        }
        
        //敵のステータスを更新
        enemy.currentMP += 1
        if enemy.currentMP >= 35{
            enemyAttack()//MPが35までいったら自動で一回攻撃する
            enemy.currentMP=0
        }
        
//        playerMPLabel.text="\(player.currentMP) / 20"
//        enemyMPLabel.text="\(enemy.currentMP) / 35"
        updateUI()
    }
    
    //敵の攻撃
    func enemyAttack(){
        techMonManager.damageAnimation(imageView: playerImageView)
        techMonManager.playSE(fileName: "SE_attack")
        
        player.currentHP -= enemy.attackPoint
        playerHPLabel.text="\(player.currentHP) / 100"
        
//        if player.currentHP <= 0{
//            finishBattle(vanishImageView:playerImageView,isPlayerWin:false)
//        }
        judgeBattle()
    }
    
    //勝敗が決定したときの処理
    func finishBattle(vanishImageView:UIImageView,isPlayerWin:Bool){
        techMonManager.vanishAnimation(imageView: vanishImageView)
        techMonManager.stopBGM()
        gameTimer.invalidate()
        isPlayerAttackAvailable=false
        
        var finishMessage : String=""
        
        if isPlayerWin{
            techMonManager.playSE(fileName: "SE_fanfare")
            finishMessage="勇者の勝利！！"
        }else{
            techMonManager.playSE(fileName: "SE_gameover")
            finishMessage="勇者の敗北…"
        }
        
        let alert=UIAlertController(title: "バトル終了", message:finishMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"OK",style:.default,handler:{ _ in
            self.dismiss(animated:true,completion:nil)
            
        }))
        present(alert,animated:true,completion:nil)
    }
    
    //攻撃するメソッド
    @IBAction func attackAction(){
        if isPlayerAttackAvailable{
            techMonManager.damageAnimation(imageView: enemyImageView)
            techMonManager.playSE(fileName: "SE_attack")
            
            //enemy.currentHP-=30
            enemy.currentHP-=player.attackPoint
            
            player.currentTP+=10//攻撃するとTPが10たまる
            if player.currentTP>=player.maxTP{
                player.currentTP=player.maxTP
            }
            player.currentMP=0
            
//            enemyHPLabel.text="\(enemyHP) / 200"
//            playerMPLabel.text="\(playerMP) / 20"
            //updateUI()
            
//            if enemy.currentHP<=0{
//                finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
//            }
            judgeBattle()
        }
    }
    
    //ステータスの反映
    func updateUI(){
        playerHPLabel.text="\(player.currentHP) / \(player.maxHP)"
        playerMPLabel.text="\(player.currentMP) / \(player.maxMP)"
        playerTPLabel.text="\(player.currentTP) / \(player.maxTP)"
        
        enemyHPLabel.text="\(enemy.currentHP) / \(enemy.maxHP)"
        enemyMPLabel.text="\(enemy.currentMP) / \(enemy.maxMP)"
    }
    
    //勝利判定をする
    func judgeBattle(){
        if player.currentHP<=0{
            finishBattle(vanishImageView: playerImageView, isPlayerWin: false)
        }else if enemy.currentHP<=0{
            finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
        }
    }
    
    @IBAction func tameruAction(){
        if isPlayerAttackAvailable{
            techMonManager.playSE(fileName:"SE_charge")
            player.currentTP+=40
            if player.currentTP>=player.maxTP{
                player.currentTP=player.maxTP
            }
            
            player.currentMP=0
        }
    }
    
    @IBAction func fireAcition(){
        if isPlayerAttackAvailable && player.currentTP>=40{
            techMonManager.damageAnimation(imageView: enemyImageView)
            techMonManager.playSE(fileName: "SE_fire")
            
            enemy.currentHP-=100
            
            player.currentTP-=40
            if player.currentTP<=0{
                player.currentTP=0
            }
            player.currentMP=0
            
        judgeBattle()
            
        }
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
