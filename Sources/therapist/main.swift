//
//  main.swift
//  ElizaTool
//
//  Created by Helge Hess on 14.04.18.
//

import Dispatch
import Foundation
import Eliza

var buf = [ Int8 ](repeating: 0, count: 500)

class Therapist {
  
  let Q            : DispatchQueue = DispatchQueue(label: "eliza")
  var isThinking   = false
  let thinkingTime : TimeInterval = 2
  let eliza        = Eliza()
  
  func ask(_ question: String, _ cb: @escaping ( String? ) -> ()) {
    guard !isThinking else { return cb(nil) }
    
    isThinking = true
    Q.asyncAfter(deadline: .now() + thinkingTime) {
      self.isThinking = false
      let answer = self.eliza.replyTo(question)
      cb(answer)
    }
  }
}

let eliza = Therapist()
print(eliza.eliza.elizaHi())

repeat {
  let cstr = gets(&buf)!
  let s = String(cString: cstr)
  
  eliza.ask(s) { answer in
    guard let answer = answer else { return }
    print(answer)
  }
}
while true

