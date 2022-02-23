//
//  SwiftUIHostingController.swift
//  BomberMan
//
//  Created by Daniel Falkedal on 2022-02-23.
//

import UIKit
import SwiftUI

struct MyView: View {
    
    @State var startGame: Bool = false
    
    var body: some View {
        
        if startGame {
            ViewController()
                .ignoresSafeArea()
        }
        else {
            ZStack {
                Image("mainmenu_no_props")
                    
                Button(action: {
                    startGame = true
                }, label: {
                    Text("Start Game")
                })
            }
        }
        
    }
}



struct ViewController: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(identifier: "gameViewController")
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
       
    }
}

class SwiftUIHostingController: UIHostingController<MyView> {

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: MyView());
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
