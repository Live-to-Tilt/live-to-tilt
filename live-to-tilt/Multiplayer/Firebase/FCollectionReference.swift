import FirebaseFirestore

enum FCollectionReference: String {
    case Game
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    Firestore.firestore().collection(collectionReference.rawValue)
}
