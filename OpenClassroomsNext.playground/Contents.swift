import UIKit

// Person struct

struct Person: Codable, Hashable {
    var name: String
    var age: Int
    var hometown: String
    var interests: [Interest]
    
    // implementing Hashable protocol, hasher.combine is creating a hash from the name, name is the unique variable
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
}


// Interest struct

struct Interest: Codable, Equatable {
    var title: String
    var why: String
    var description: String
}


// data for every person participating in the game in JSON format
var personsJSONString = String()

do {
    guard let fileURL = Bundle.main.url(forResource: "Names", withExtension: "json")
        else {
            fatalError()
    }
    try personsJSONString = String(contentsOf: fileURL)
} catch {
    print("opening the file failed")
}
// allows us to take the JSON data from all of the players. This is where we are decoding the data from the JSON and converting it into a swift native structure

let jsonData = personsJSONString.data(using: .utf8)!
var playerCandidates = try! JSONDecoder().decode([Person].self, from: jsonData)


// shuffles the players

playerCandidates.shuffle()


// allows us to pull a certain amount of players, it needs to be an even number

let maxPeople = playerCandidates.count
let randomPersonNumber = Int.random(in: 1...maxPeople/2) * 2

// places new number of players of type Person and places them into an array

var selectedPlayers: [Person] = []
for new in 0...randomPersonNumber - 1 {
    
    selectedPlayers.append(playerCandidates[new])
    print("Hi my name is \(playerCandidates[new].name)")
}

// shows the names and interested for the selectedPlayers, the selectedPlayers is our new array of Person type participants for the game

for player in selectedPlayers.shuffled() {
    
    for interest in player.interests.shuffled() {
        print("Hi I'm \(player.name), here is one of my interests: \(interest.title)")
        
    }
    
}


// this function is where we compare interests based on the person. when players have a matching interest, their points are higher. we return the basePerson and matchingPerson and their points - uses Tuple

func compareInterests(basePerson: Person, matchingPerson: Person) -> (playerOne: Person, playerTwo: Person, points: Int) {
    var points = 0
    for interest in basePerson.interests {
        if matchingPerson.interests.contains(interest) {
            points += 1
        }
        
    }
    
    return (basePerson, matchingPerson, points)
    
}



// array of players based on their points


var pointList: [(playerOne: Person, playerTwo: Person, points: Int)] = []


// nested for loop to append the pointList array with 2 players with matching points. Outer loop goes through all of the selectedPlayers except the last one, the nested loop is the remaining players
for i in 0...selectedPlayers.count - 2 {
    
    for k in i + 1...selectedPlayers.count - 1 {
        
        pointList.append(compareInterests(basePerson: selectedPlayers[i], matchingPerson: selectedPlayers[k]))
        
    }
}

// for loop to show the players and their interests

for (playerOne, playerTwo, points) in pointList {
    print("\(playerOne.name) and \(playerTwo.name) have \(points) common interests")
}

// closure which uses .sort to organize all of the players with low to high points. looking for the least amount of common interests

pointList.sort { (lhs, rhs) -> Bool in
    if lhs.points < rhs.points {
        return true
    }
    else {
        return false
    }
    
}



print("Matching is complete...")


// array to contain the newly sorted players

var playerMatching: [(playerOne: Person, playerTwo: Person)] = []

// new set which helps keep track of pairs and remove duplicates

var allPlayersList = Set(selectedPlayers)

// for loop which goes through the previous pointList that appends our new playerMatching list with the sorted players and removes duplicates

for (playerOne, playerTwo, points) in pointList {
    
  
    if allPlayersList.contains(playerOne) && allPlayersList.contains(playerTwo) {
        
        playerMatching.append((playerOne, playerTwo))
        allPlayersList.remove(playerOne)
        allPlayersList.remove(playerTwo)
    
        
        
        print("\(playerOne.name) and \(playerTwo.name) matched: they have \(points) interests in common")
        
    }
 
    
}















