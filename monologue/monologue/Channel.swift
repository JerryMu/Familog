//  Familog
//
//  Created by 刘仕晟 on 2019/10/6.
//

import FirebaseFirestore

struct Channel {
  
    let id: String?
    let name: String
  
    init(name: String, id : String) {
        self.id = id
        self.name = name
    }
  
  init?(document: QueryDocumentSnapshot) {
    let data = document.data()
    
    guard let name = data["name"] as? String else {
      return nil
    }
    guard let id = data["id"] as? String else {
      return nil
    }

    
    self.id = id
    self.name = name
  }
  
}

extension Channel: DatabaseRepresentation {
  
  var representation: [String : Any] {
    var rep = ["name": name]
    
    if let id = id {
      rep["id"] = id
    }
    
    return rep
  }
  
}

extension Channel: Comparable {
  
  static func == (lhs: Channel, rhs: Channel) -> Bool {
    return lhs.id == rhs.id
  }
  
  static func < (lhs: Channel, rhs: Channel) -> Bool {
    return lhs.name < rhs.name
  }

}
