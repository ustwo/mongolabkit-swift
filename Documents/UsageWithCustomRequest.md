## Usage with custom requests

### Creating a GET request with query string parameters

``` Swift
let configuration = MongoLabApiV1Configuration(databaseName: "{DATABASE_NAME}", apiKey: "{API_KEY}")

let parameter1 = URLRequest.QueryStringParameter(key: "{PARAMETER_KEY}", value: "{PARAMETER_VALUE}")
let parameter2 = URLRequest.QueryStringParameter(key: "{PARAMETER_KEY}", value: "{PARAMETER_VALUE}")

let request = try MongoLabURLRequest.URLRequestWithConfiguration(configuration, relativeURL: "collections/[COLLECTION_NAME]", method: .GET, parameters: [parameter1, parameter2], bodyData: nil)
```

### Creating a POST request with body data

``` Swift
let configuration = MongoLabApiV1Configuration(databaseName: "{DATABASE_NAME}", apiKey: "{API_KEY}")

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
