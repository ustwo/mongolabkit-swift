## Usage with service

### Listing collections

``` swift
let configuration = MongoLabConfiguration(baseURL: "{BASE_URL}", apiKey: "{API_KEY}")

let service = CollectionService(configuration: configuration, delegate: self)

service.loadCollections()
```

---

### Listing documents in a collection

``` swift
let configuration = MongoLabConfiguration(baseURL: "{BASE_URL}", apiKey: "{API_KEY}")

let service = DocumentService(configuration: configuration, delegate: self)

service.loadDocumentsForCollection(Collection("{COLLECTION_NAME}"))
```

---

### Adding a document in a collection

``` swift
let configuration = MongoLabConfiguration(baseURL: "{BASE_URL}", apiKey: "{API_KEY}")

let document = Document(payload: {JSON_OBJECT})

let service = DocumentService(configuration: configuration, delegate: self)

service.addDocument(document, inCollection: Collection("{COLLECTION_NAME}"))
```