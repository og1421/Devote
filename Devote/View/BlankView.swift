//
//  BlankView.swift
//  Devote
//
//  Created by Orlando Moraes Martins on 12/02/23.
//

import SwiftUI

struct BlankView: View {
    //MARK: - Properties
    var backgroundColor: Color
    var backgroundOpacity: Double
    
    //MARK: - Body
    var body: some View {
        VStack{
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(backgroundColor)
        .opacity(backgroundOpacity)
        .blendMode(.overlay)
        .edgesIgnoringSafeArea(.all)
    }
}

struct BlankView_Previews: PreviewProvider {
    static var previews: some View {
        BlankView(backgroundColor: Color.black, backgroundOpacity: 0.3)
            .background(backgroundGradient.ignoresSafeArea(.all))
    }
}
