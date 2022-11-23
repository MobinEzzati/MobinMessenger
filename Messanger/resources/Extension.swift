//
//  Extension.swift
//  Messanger
//
//  Created by mobin on 10/10/22.
//

import Foundation
import UIKit

extension UIView {
    public var width: CGFloat {
        
        return self.frame.size.width
    }
    
    public var height: CGFloat {
        return self.frame.size.height
    }
    
    public var top: CGFloat {
        return self.frame.origin.y
    }
    
    public var buttom: CGFloat {
        
        return self.frame.origin.y + self.frame.height
        
    }
    public var  right : CGFloat {
        
        return self.frame.size.width + self.frame.origin.x
    }
    
    
}
