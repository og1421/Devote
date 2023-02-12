//
//  BlankView.swift
//  Devote
//
//  Created by Orlando Moraes Martins on 12/02/23.
//

import SwiftUI

struct BlankView: View {
    //MARK: - Properties
    
    //MARK: - Body
    var body: some View {
        VStack{
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(.black)
        .opacity(0.5)
        .edgesIgnoringSafeArea(.all)
    }
}

struct BlankView_Previews: PreviewProvider {
    static var previews: some View {
        BlankView()
    }
}
