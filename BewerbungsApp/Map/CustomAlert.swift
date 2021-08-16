//
//  CustomAlert.swift
//  BewerbungsApp
//
//  Created by Malo Jaboulet on 06.08.21.
//

import SwiftUI

struct CustomAlert: View {
    
    
    let screenSize = UIScreen.main.bounds
    @Binding var isShown: Bool
    @Binding var text: String
    var onDone: (String) -> Void = { _ in }
    
    
    var body: some View {
        
        VStack(spacing: 20) {
            Text("Stadtnamen eingeben")
                .font(.headline)
            TextField("", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            HStack(spacing: 20) {
                Button("Done") {
                    self.isShown = false
                    self.onDone(self.text)
                }
                
            }
        }
        .padding()
        .frame(width: screenSize.width * 0.7, height: screenSize.height * 0.3)
        .border(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
        .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
        .offset(y: isShown ? 0 : screenSize.height)
        .animation(.spring())
        
    }
}

struct CustomAlert_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlert(isShown: .constant(true), text: .constant(""))
    }
}
