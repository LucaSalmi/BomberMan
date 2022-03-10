//
//  SideViewMapMenu.swift
//  BomberMan
//
//  Created by Hampus Brandtman on 2022-03-01.
//

import SwiftUI
import CoreData

struct SideViewMapMenu: View {
        
    @Binding var startGame: Bool
    
    var body: some View {
        
        VStack{
            
            Spacer()
            
            VStack{
                
                HStack(spacing: 100){
                    
                    //ROW 1
                    Button {
                        
                        print("level 2 pressed")
                        
                        
                        withAnimation(.easeIn(duration: 0.3)){
                                                        
                            if checkAndStartLevel(id: 2){
                                
                                startGame = true
                            }
                        }
                        
                    } label: {
                        Text("level 2")
                    }
                    .foregroundColor(.white)
                    .font(Font.body.bold())
                    .font(.largeTitle)
                    .padding(.leading, 100)
                    
                    Button {
                        
                        print("level 3 pressed")
                        
                        if checkAndStartLevel(id: 3){
                            
                            startGame = true
                        }
                        
                    } label: {
                        Text("level 3")
                    }
                    .foregroundColor(.white)
                    .font(Font.body.bold())
                    .font(.largeTitle)
                    
                    Button {
                        
                        print("level 6 pressed")
                        
                        if checkAndStartLevel(id: 6){
                            
                            startGame = true
                        }
                        
                    } label: {
                        Text("level 6")
                    }
                    .foregroundColor(.white)
                    .font(Font.body.bold())
                    .font(.largeTitle)
                    
                }
                .padding(20)
                .padding(.horizontal, 60)
                
                //ROW 2 (only connecting lines)
                HStack() {
                    
                    let lineWidth: CGFloat = 1.5
                    let lineHeight: CGFloat = 50
                    let lineColor: Color = Color.black
                    
                    Rectangle()
                        .fill(lineColor)
                        .frame(width: lineWidth, height: lineHeight)
                        .padding(.leading, 90)
                    
                    Rectangle()
                        .fill(lineColor)
                        .frame(width: lineWidth, height: lineHeight)
                        .padding(.leading, 140)
                    
                    Rectangle()
                        .fill(lineColor)
                        .frame(width: lineWidth, height: lineHeight)
                        .padding(.leading, 140)
                    
                }
                
                //ROW 3
                HStack(spacing: 100){
                    Button {
                        
                        print("level 1 pressed")
                        
                        if checkAndStartLevel(id: 1){
                            
                            startGame = true
                        }
                        
                    } label: {
                        Text("level 1")
                        
                        
                    }
                    .foregroundColor(.white)
                    .font(Font.body.bold())
                    .font(.largeTitle)
                    .padding(.leading, 100)
                    
                    Button {
                        
                        print("level 4 pressed")
                        
                        if checkAndStartLevel(id: 4){
                            
                            startGame = true
                        }
                        
                    } label: {
                        Text("level 4")
                    }
                    .foregroundColor(.white)
                    .font(Font.body.bold())
                    .font(.largeTitle)
                    
                    Button {
                        
                        print("level 5 pressed")
                        
                        if checkAndStartLevel(id: 5){
                            
                            startGame = true
                        }
                        
                    } label: {
                        Text("level 5")
                    }
                    .foregroundColor(.white)
                    .font(Font.body.bold())
                    .font(.largeTitle)
                    
                }
                .padding(20)
                .padding(.horizontal, 60)
            }
            Spacer()
            
        }
        .scaledToFill()
        .foregroundColor(.white)
        .background(Image("MapRoll").resizable().scaledToFit())
        
        .edgesIgnoringSafeArea(.trailing)
    }
    
    func checkAndStartLevel(id: Int) -> Bool{
        
        print(UserData.currentLevel)
        
        if UserData.currentLevel == id{
            
            return true
            
        }else if UserData.currentLevel > id{
            
            UserData.currentLevel = id
            return true
            
        }else if UserData.currentLevel < id && UserData.lastSavedLevel >= id{
            
            UserData.currentLevel = id
            return true
        }
        
        return false
    }

}
