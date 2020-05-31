//
//  Language.swift
//  NetworkingLayer
//
//  Created by 肖培德 on 5/31/20.
//  Copyright © 2020 肖培德. All rights reserved.
//

import UIKit

/*"LanguagePK": 65,
"LangName": "Arabic",
"CultureName": "ar-EG",
"BaseCulture": "ar",
"BaseLangName": "Arabic"*/

struct Language: Codable {
    let LanguagePK: Int
    let LangName: String
    let CultureName: String
    let BaseCulture: String
    let BaseLangName: String
}

