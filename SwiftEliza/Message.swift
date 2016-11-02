import Foundation

// The type of message
enum MessageType {
    case question
    case answer
}

// A conversation entry made by the user of the app
struct Message {
    let date: Date
    let text: String
    let type: MessageType
}
