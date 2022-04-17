import FirebaseFirestore

enum FirebaseCollectionReference: String {
    case Room
}

func FirebaseReference(_ collectionReference: FirebaseCollectionReference) -> CollectionReference {
    Firestore.firestore().collection(collectionReference.rawValue)
}
