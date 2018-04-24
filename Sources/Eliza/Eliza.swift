import Foundation

public struct Eliza {
  
    public init() {}
  
    // A list of introduction sentences for ELIZA.
    private let introductions = [
        "Hello. How are you feeling today?",
        "How do you do. Please tell me your problem.",
        "Please tell me what's been bothering you.",
        "Is something troubling you?"
    ]
    
    // A list of goodbye sentences for ELIZA.
    private let goodbyes = [
        "Goodbye. It was nice talking to you.",
        "Thank you for talking with me.",
        "Thank you, that will be $150. Have a good day!",
        "Goodbye. This was really a nice talk.",
        "Goodbye. I'm looking forward to our next session.",
        "This was a good session, wasn't it – but time is over now. Goodbye.",
        "Maybe we could discuss this over more in our next session? Goodbye.",
        "Good-bye."
    ]
    
    // A list of tuples of the form: (questionRegex, [answer1, answer2, ...])
    // Ordered by increasing generality of the question regexes
    private let psychobabble = [
        ("i need (.*)", [
            "Why do you need %s?",
            "Would it really help you to get %s?",
            "Are you sure you need %s?",
            ]),
        ("why don'?t you ([^\\?]*)\\??", [
            "Do you really think I don't %s?",
            "Perhaps eventually I will %s.",
            "Do you really want me to %s?",
            ]),
        ("why can'?t I ([^\\?]*)\\??", [
            "Do you think you should be able to %s?",
            "If you could %s, what would you do?",
            "I don't know -- why can't you %s?",
            "Have you really tried?",
            ]),
        ("i can'?t (.*)", [
            "How do you know you can't %s?",
            "Perhaps you could %s if you tried.",
            "What would it take for you to %s?",
            ]),
        ("i am (.*)", [
            "Did you come to me because you are %s?",
            "How long have you been %s?",
            "How do you feel about being %s?",
            ]),
        ("i'?m (.*)", [
            "How does being %s make you feel?",
            "Do you enjoy being %s?",
            "Why do you tell me you're %s?",
            "Why do you think you're %s?",
            ]),
        ("are you ([^\\?]*)\\??", [
            "Why does it matter whether I am %s?",
            "Would you prefer it if I were not %s?",
            "Perhaps you believe I am %s.",
            "I may be %s -- what do you think?",
            ]),
        ("what (.*)", [
            "Why do you ask?",
            "How would an answer to that help you?",
            "What do you think?",
            ]),
        ("how (.*)", [
            "How do you suppose?",
            "Perhaps you can answer your own question.",
            "What is it you're really asking?",
            ]),
        ("because (.*)", [
            "Is that the real reason?",
            "What other reasons come to mind?",
            "Does that reason apply to anything else?",
            "If %s, what else must be true?",
            ]),
        ("(.*) sorry (.*)", [
            "There are many times when no apology is needed.",
            "What feelings do you have when you apologize?",
            ]),
        ("^hello(.*)", [
            "Hello... I'm glad you could drop by today.",
            "Hi there... how are you today?",
            "Hello, how are you feeling today?",
            ]),
        ("^hi(.*)", [
            "Hello... I'm glad you could drop by today.",
            "Hi there... how are you today?",
            "Hello, how are you feeling today?",
            ]),
        ("^thanks(.*)", [
            "You're welcome!",
            "Anytime!",
            ]),
        ("^thank you(.*)", [
            "You're welcome!",
            "Anytime!",
            ]),
        ("^good morning(.*)", [
            "Good morning... I'm glad you could drop by today.",
            "Good morning... how are you today?",
            "Good morning, how are you feeling today?",
            ]),
        ("^good afternoon(.*)", [
            "Good afternoon... I'm glad you could drop by today.",
            "Good afternoon... how are you today?",
            "Good afternoon, how are you feeling today?",
            ]),
        ("I think (.*)", [
            "Do you doubt %s?",
            "Do you really think so?",
            "But you're not sure %s?",
            ]),
        ("(.*) friend (.*)", [
            "Tell me more about your friends.",
            "When you think of a friend, what comes to mind?",
            "Why don't you tell me about a childhood friend?",
            ]),
        ("yes", [
            "You seem quite sure.",
            "OK, but can you elaborate a bit?",
            ]),
        ("(.*) computer(.*)", [
            "Are you really talking about me?",
            "Does it seem strange to talk to a computer?",
            "How do computers make you feel?",
            "Do you feel threatened by computers?",
            ]),
        ("is it (.*)", [
            "Do you think it is %s?",
            "Perhaps it's %s -- what do you think?",
            "If it were %s, what would you do?",
            "It could well be that %s.",
            ]),
        ("it is (.*)", [
            "You seem very certain.",
            "If I told you that it probably isn't %s, what would you feel?",
            ]),
        ("can you ([^\\?]*)\\??", [
            "What makes you think I can't %s?",
            "If I could %s, then what?",
            "Why do you ask if I can %s?",
            ]),
        ("(.*)dream(.*)", [
            "Tell me more about your dream.",
            ]),
        ("can I ([^\\?]*)\\??", [
            "Perhaps you don't want to %s.",
            "Do you want to be able to %s?",
            "If you could %s, would you?",
            ]),
        ("you are (.*)", [
            "Why do you think I am %s?",
            "Does it please you to think that I'm %s?",
            "Perhaps you would like me to be %s.",
            "Perhaps you're really talking about yourself?",
            ]),
        ("you'?re (.*)", [
            "Why do you say I am %s?",
            "Why do you think I am %s?",
            "Are we talking about you, or me?",
            ]),
        ("i don'?t (.*)", [
            "Don't you really %s?",
            "Why don't you %s?",
            "Do you want to %s?",
            ]),
        ("i feel (.*)", [
            "Good, tell me more about these feelings.",
            "Do you often feel %s?",
            "When do you usually feel %s?",
            "When you feel %s, what do you do?",
            ]),
        ("i have (.*)", [
            "Why do you tell me that you've %s?",
            "Have you really %s?",
            "Now that you have %s, what will you do next?",
            ]),
        ("i would (.*)", [
            "Could you explain why you would %s?",
            "Why would you %s?",
            "Who else knows that you would %s?",
            ]),
        ("is there (.*)", [
            "Do you think there is %s?",
            "It's likely that there is %s.",
            "Would you like there to be %s?",
            ]),
        ("my (.*)", [
            "I see, your %s.",
            "Why do you say that your %s?",
            "When your %s, how do you feel?",
            ]),
        ("you (.*)", [
            "We should be discussing you, not me.",
            "Why do you say that about me?",
            "Why do you care whether I %s?",
            ]),
        ("why (.*)", [
            "Why don't you tell me the reason why %s?",
            "Why do you think %s?",
            ]),
        ("i want (.*)", [
            "What would it mean to you if you got %s?",
            "Why do you want %s?",
            "What would you do if you got %s?",
            "If you got %s, then what would you do?",
            ]),
        ("(.*) mother(.*)", [
            "Tell me more about your mother.",
            "What was your relationship with your mother like?",
            "How do you feel about your mother?",
            "How does this relate to your feelings today?",
            "Good family relations are important.",
            ]),
        ("(.*) father(.*)", [
            "Tell me more about your father.",
            "How did your father make you feel?",
            "How do you feel about your father?",
            "Does your relationship with your father relate to your feelings today?",
            "Do you have trouble showing affection with your family?",
            ]),
        ("(.*) child(.*)", [
            "Did you have close friends as a child?",
            "What is your favorite childhood memory?",
            "Do you remember any dreams or nightmares from childhood?",
            "Did the other children sometimes tease you?",
            "How do you think your childhood experiences relate to your feelings today?",
            ]),
        ("(.*)\\?", [
            "Why do you ask that?",
            "Please consider whether you can answer your own question.",
            "Perhaps the answer lies within yourself?",
            "Why don't you tell me?",
            ])
    ]
    
    // If ELIZA doesn't understand the question, then it will reply with one of
    // these default responses.
    private let defaultResponses = [
        "Please tell me more.",
        "Let's change focus a bit... Tell me about your family.",
        "Can you elaborate on that?",
        "I see.",
        "Very interesting.",
        "I see. And what does that tell you?",
        "How does that make you feel?",
        "How do you feel when you say that?",
        ]
    
    // Statements that indicate the user wants to end the conversation.
    private let quitStatements = [
        "goodbye",
        "bye",
        "quit",
        "exit",
        ]
    
    // This is a table to reflect words in question fragments inside the response.
    // For example, "I want your jacket" should be reflected to "You want my jacket"
    // in the response.
    private let reflectedWords = [
        "am": "are",
        "was": "were",
        "i": "you",
        "i'd": "you would",
        "i've": "you have",
        "i'll": "you will",
        "my": "your",
        "are": "am",
        "you've": "I have",
        "you'll": "I will",
        "your": "my",
        "yours": "mine",
        "you": "me",
        "me": "you"
    ]
    
    // elizaHi will return a random greeting from Eliza.
    public func elizaHi() -> String {
        return introductions.randChoice()
    }
    
    // elizaBye will return a random goodbye from Eliza.
    public func elizaBye() -> String {
        return goodbyes.randChoice()
    }
    
    // replyTo will construct a reply for a given statement using Eliza's rules.
    public func replyTo(_ statement: String) -> String {
        // First, preprocess the statement for more effective matching
        let statement = preprocess(statement)
        
        // Then, we check if this is a quit statement
        if quitStatements.contains(statement)  {
            return elizaBye()
        }
        
        // Next, we try to match the statement to a statement that ELIZA can
        // recognize, and construct a pre-determined, appropriate response.
        for (pattern, responses) in psychobabble {
            // Apply the regex re to the statement string
            let re = try! NSRegularExpression(pattern: pattern)
          #if swift(>=3.2)
            let matches = re.matches(in: statement,
                                     range: NSRange(location: 0, length: statement.count))
            
          #else
            let matches = re.matches(in: statement,
                                     range: NSRange(location: 0, length: statement.characters.count))
          #endif
          
            // If the statement matched any recognizable statements
            if matches.count > 0 {
                // There should only be one match
                let match = matches[0]
                
                // If we matched a regex capturing group in parentheses, get the first one.
                // The matched regex group will match a "fragment" that will form
                // part of the response, for added realism.
                var fragment = ""
                if match.numberOfRanges > 1 {
                  #if os(Linux)                  
                    fragment = NSString(string: statement).substring(with: match.range(at: 1))
                  #elseif swift(>=4.0)
                    fragment = (statement as NSString).substring(with: match.range(at: 1))
                  #else
                    fragment = (statement as NSString).substring(with: match.rangeAt(1))
                  #endif
                    fragment = reflect(fragment)
                }
                
                // Choose a random appropriate response, and format it with the
                // fragment, if needed.
                var response = responses.randChoice()
                response = response.replacingOccurrences(of: "%s", with: fragment)
                return response
            }
        }
        
        // If no patterns were matched, return a default response.
        return defaultResponses.randChoice()
    }
    
    // preprocess will normalization a statement string for better regex matching.
    private func preprocess(_ statement: String) -> String {
        let trimmed = statement.trimmingCharacters(in: .whitespacesAndNewlines)
        let lowercased = trimmed.lowercased()
        return lowercased
    }
    
    // reflect flips a few words in an input fragment (such as "I" -> "you").
    private func reflect(_ fragment: String) -> String {
        var words = fragment.components(separatedBy: " ")
        for (i, word) in words.enumerated() {
            if let reflectedWord = reflectedWords[word] {
                words[i] = reflectedWord
            }
        }
        return words.joined(separator: " ")
    }
}

#if os(Linux)
    import SwiftGlibc
#endif

// Add a randChoice method to Array's, which returns a random element.
extension Array {
    func randChoice() -> Element {
        #if os(Linux)
            func arc4random_uniform(_ max: UInt32) -> Int32 {
                return (SwiftGlibc.rand() % Int32(max-1))
            }
            let index = Int(arc4random_uniform(UInt32(self.count)))
        #else
            let index = Int(arc4random_uniform(UInt32(self.count)))
        #endif
        return self[index]
    }
}
