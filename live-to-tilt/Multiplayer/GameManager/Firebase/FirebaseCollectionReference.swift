import FirebaseFirestore

enum FirebaseCollectionReference: String {
    case Game
}

func FirebaseReference(_ collectionReference: FirebaseCollectionReference) -> CollectionReference {
    Firestore.firestore().collection(collectionReference.rawValue)
}
