//
//  ColorSchemes.swift
//  Virtual Tourist
//
//  Created by Dylan Edwards on 7/9/16.
//  Copyright © 2016 Slinging Pixels Media. All rights reserved.
//
//
// Adobe Color CC: https://color.adobe.com/create/color-wheel/
// Sip: http://sipapp.io
//
/**
 I generated the theme by searching Adobe Color CC for complimentary colors to
 colors in MKMapView.
 
 I then generated the UIColors using Sip
 */

import UIKit

struct Theme {
    /// Universal
    static let textLight                = UIColor.fantasy()
    static let textStrokeLight          = UIColor.pearlBush()
    static let textDark                 = UIColor.timberGreen()
    static let destructiveButtonTint    = UIColor.redOrange()
    static let buttonTint               = UIColor.blueBayoux()
    static let presentationDimBGColor   = UIColor.timberGreenAlpha50()
    
    /// Tab Bar / Navigation Bar
    static let barTintColor             = UIColor.fantasy()
    static let navBarTitleColor         = UIColor.blueBayoux()
    
    /// Map View
    static let activityIndicatorColor   = UIColor.rangoonGreen()
    static let selectedPin              = UIColor.blueBayoux()
    static let unselectedPin            = UIColor.redOrange()
    
    /// Photo Album View
    static let collectionViewBackground = UIColor.rangoonGreen()
    
}

/**
 Universal
 **/
extension UIColor {
    /**
     name: Red Orange
     hex: #FF3B30
     **/
    public class func redOrange() -> UIColor {
        return UIColor(red:1.00, green:0.23, blue:0.19, alpha:1.00)
    }
    
    /**
     name: Blizzard Blue
     hex: #AEE1F5
     **/
    public class func blizzardBlue() -> UIColor {
        return UIColor(red:0.68, green:0.88, blue:0.96, alpha:1.00)
    }
    
    /**
     name: Apricot
     hex: #F8D2B0
     **/
    public class func apricot() -> UIColor {
       return UIColor(red:0.97, green:0.82, blue:0.69, alpha:1.00)
    }
}

/**
 Virtual Tourist Color Palate 01
 **/

extension UIColor {
    /**
     name: Rangoon Green
     hex: #1F1F1A
     **/
    public class func rangoonGreen() -> UIColor {
        return UIColor(red: 0.1215686275, green: 0.1215686275, blue: 0.1019607843, alpha: 1.0000000000);
    }
    
    /**
     name: Tapa
     hex: #797874
     **/
    public class func tapa() -> UIColor {
        return UIColor(red: 0.4745098039, green: 0.4705882353, blue: 0.4549019608, alpha: 1.0000000000)
    }
    
    /**
     name: Cape Honey
     hex: #FDDCA6
     **/
    public class func capeHoney() -> UIColor {
        return UIColor(red: 0.9921568627, green: 0.8627450980, blue: 0.6509803922, alpha: 1.0000000000)
    }
    
    /** 
     name: Desert Storm
     hex: #EBE8E0
     **/
    public class func desertStorm() -> UIColor {
        return UIColor(red:0.92, green:0.91, blue:0.88, alpha:1.00)
    }
    
    /**
     name: Fantasy
     hex: #F9F5ED
     **/
    public class func fantasy() -> UIColor {
        return UIColor(red: 0.9764705882, green: 0.9607843137, blue: 0.9294117647, alpha: 1.0000000000)
    }
    
    /**
     name: Peat
     hex: #7B6A51
     **/
    public class func peat() -> UIColor {
        return UIColor(red: 0.4823529412, green: 0.4156862745, blue: 0.3176470588, alpha: 1.0000000000)
    }
    
    /**
     name: Mist Gray
     hex: #C6C3BC
     **/
    public class func mistGray() -> UIColor {
        return UIColor(red: 0.7764705882, green: 0.7647058824, blue: 0.7372549020, alpha: 1.0000000000)
    }
    
}

/**
 Virtual Tourist 02
 **/

extension UIColor {
    
    /**
     name: Fantasy
     hex: #FAF5ED
     **/

    /**
     name: Pearl Bush
     hex: #E8DED1
     **/
    
    public class func pearlBush() -> UIColor {
        return UIColor(red: 0.9098039216, green: 0.8705882353, blue: 0.8196078431, alpha: 1.0000000000);
    }
    
    /**
     name: Blue Bayoux
     hex: #5C7C7F
     **/
    
    public class func blueBayoux() -> UIColor {
        return UIColor(red: 0.3607843137, green: 0.4862745098, blue: 0.4980392157, alpha: 1.0000000000);
    }
    
    /**
     name: Bull Shot
     hex: #854A18
     **/
    
    public class func bullShot() -> UIColor {
        return UIColor(red: 0.5215686275, green: 0.2901960784, blue: 0.0941176471, alpha: 1.0000000000);
    }
    
    /**
     name: Rangoon Green
     hex: #1F1F1A
     **/
}

/**
 Virtual Tourist 03
 **/

extension UIColor {
    
    /**
     name: Blue Chalk
     hex: #EBD3E9
     **/
    public class func blueChalk() -> UIColor {
        return UIColor(red: 0.9215686275, green: 0.8274509804, blue: 0.9137254902, alpha: 1.0000000000);
    }
    
    /**
     name: Ce Soir
     hex: #9E6F9C
     **/
    public class func ceSoir() -> UIColor {
        return UIColor(red: 0.6196078431, green: 0.4352941176, blue: 0.6117647059, alpha: 1.0000000000);
    }
    
    /**
     name: Romance
     hex: #FFFFFE
     **/
    public class func romance() -> UIColor {
        return UIColor(red: 1.0000000000, green: 1.0000000000, blue: 0.9960784314, alpha: 1.0000000000);
    }
    
    /**
     name: Zanah
     hex: #DBEBD4
     **/
    public class func zanah() -> UIColor {
        return UIColor(red: 0.8588235294, green: 0.9215686275, blue: 0.8313725490, alpha: 1.0000000000);
    }
    
    /**
     name: Spanish Green
     hex: #899E7F
     **/
    public class func spanishGreen() -> UIColor {
        return UIColor(red: 0.5372549020, green: 0.6196078431, blue: 0.4980392157, alpha: 1.0000000000);
    }
    
    /**
     name: Timber Green
     hex: #343C35
     **/
    public class func timberGreen() -> UIColor {
        return UIColor(red: 0.2039215686, green: 0.2352941176, blue: 0.2078431373, alpha: 1.0000000000);
    }
    
    public class func timberGreenAlpha50() -> UIColor {
        return UIColor(red: 0.2039215686, green: 0.2352941176, blue: 0.2078431373, alpha: 0.5000000000);
    }
}
