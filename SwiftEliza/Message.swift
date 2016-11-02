import Foundation

/// The type of message
enum MessageType {
    case question
    case answer
}

/// A conversation entry made by the user of the app
struct Message {
    let date: Date
    let text: String
    let type: MessageType
}

/// The welcoming text to display to open the conversation
let openingLine = Message(date: Date(), text: "Hello, my name is Eliza.\nWe can talk about anything you'd like.", type: .answer)
