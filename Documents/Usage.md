## Usage

*An example is available [here](../MongoLabKit/MongoLabKitExamples/ViewController.swift)*

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

---

## Usage with custom requests

### Creating a GET request with query string parameters

``` Swift
let configuration = MongoLabConfiguration(baseURL: "{BASE_URL}", apiKey: "{API_KEY}")

let parameter1 = MongoLabURLRequest.RequestParameter(parameter: "{PARAMETER_NAME}", value: "{PARAMETER_VALUE}")
let parameter2 = MongoLabURLRequest.RequestParameter(parameter: "{PARAMETER_NAME}", value: "{PARAMETER_VALUE}")

let request = try MongoLabURLRequest.URLRequestWithConfiguration(configuration, relativeURL: "collections/[COLLECTION_NAME]", method: .GET, parameters: [parameter1, parameter2], bodyData: nil)
```

### Creating a POST request with body data

``` Swift
let configuration = MongoLabConfiguration(baseURL: "{BASE_URL}", apiKey: "{API_KEY}")

let body: [String: AnyObject] = [{PARAMETER_KEY}: [{PARAMETER_KEY}: {PARAMETER_VALUE}]]

let request = try MongoLabURLRequest.URLRequestWithConfiguration(configuration, relativeURL: "collections/[COLLECTION_NAME]", method: .POST, parameters: [], bodyData: body)
```

### Making REST call

``` Swift
let client = MongoLabClient()

client.performRequest(request) {
result in

switch result {
case let .Success(response):
print("Success \(response)")

case let .Failure(error):
print("Error \(error)")

}
}
```