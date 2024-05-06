import Foundation
import Fakery
import RxDataSources

let faker = Faker(locale: "ru")

struct Ad: Decodable {
    let id: UUID
    let title: String
    let description: String
    let category: Category
    
    struct Category: Decodable {
        let title: String
        
        static var placeholder: Category {
            Category(title: faker.lorem.word())
        }
    }
    
    static var placeholder: Ad {
        Ad(
            id: UUID(),
            title: faker.lorem.words().capitalized,
            description: faker.lorem.paragraphs(amount: 2),
            category: .placeholder
        )
    }
}

extension Ad: Equatable {
    static func == (lhs: Ad, rhs: Ad) -> Bool {
        lhs.title == rhs.title
    }
}

extension Ad: IdentifiableType {
    var identity: String {
        id.uuidString
    }
}

