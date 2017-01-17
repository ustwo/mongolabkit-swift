//
//  Service.swift
//  MongoLabKit
//
//  Created by luca strazzullo on 17/01/2017.
//
//

import Foundation

protocol ServiceDelegate: AnyObject {
    func serviceWillLoad<DataType>(_ service: Service<DataType>)
    func service<DataType>(_ service: Service<DataType>, didLoad data: DataType)
    func service<DataType>(_ service: Service<DataType>, didFailWith error: ErrorDescribable)
}


class Service<DataType> {

    typealias ParserFunction = (Any) throws -> (DataType)


    // MARK: Instance properties

    weak var delegate: ServiceDelegate?

    private var tasks = [URLSessionTask]()
    private let client: MongoLabClient


    // MARK: Object life cycle

    init(client: MongoLabClient) {
        self.client = client
    }


    // MARK: Public APIs

    public func perform(request: URLRequest, with parserFunction: @escaping ParserFunction) {
        let task = client.perform(request) {
            [weak self] result in

            self?.handle(result, with: parserFunction)
        }

        tasks.append(task)
    }


    public func stopAllTasks() {
        tasks.forEach({ $0.cancel() })
    }


    // MARK: Handle Result

    private func handle(_ result: MongoLabClient.Result, with parserFunction: ParserFunction) {
        switch result {
        case let .success(result):
            handle(result, with: parserFunction)
        case let .failure(error):
            handle(error)
        }
    }


    private func handle(_ result: Any, with parserFunction: ParserFunction) {
        do {
            let data = try parse(result, with: parserFunction)

            delegate?.service(self, didLoad: data)

        } catch let error {
            handle(error)
        }
    }


    private func handle(_ error: Error) {
        let error = parse(error)

        delegate?.service(self, didFailWith: error)
    }


    // MARK: Parsing

    private func parse(_ result: Any, with parserFunction: ParserFunction) throws -> DataType {
        return try parserFunction(result)
    }


    private func parse(_ error: Error) -> ErrorDescribable {
        guard let error = error as? ErrorDescribable else {
            return MongoLabError.generic
        }
        
        return error
    }

}
