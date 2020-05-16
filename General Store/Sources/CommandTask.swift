//
//  CommandTask.swift
//  General Store
//
//  Created by Yumenosuke Koukata on 2020/05/14.
//  Copyright © 2020 ZYXW. All rights reserved.
//

import Foundation

class CommandTask: Equatable {
	
	private static let ENCODING = String.Encoding.utf8
	private static var tasks = [CommandTask]()
	
	private let task = Process()
	private let outputPipe = Pipe()
	private let inputPipe = Pipe()
	
	private var outputObserver: ((String) -> ())?
	private var completionHandler: (() -> ())?
	
	init(cmd: String, arguments: String...) {
		task.launchPath = cmd
		task.arguments = arguments
		task.standardInput = inputPipe
		task.standardOutput = outputPipe
	}
	
	static func ==(lhs: CommandTask, rhs: CommandTask) -> Bool {
		return lhs.task == rhs.task
	}
	
	func setCurrentDirectoryPath(_ path: String) -> Self {
		task.currentDirectoryPath = path
		return self
	}
	
	func addObserver(_ observer: @escaping (String) -> ()) -> Self {
		self.outputObserver = observer
		return self
	}
	
	func addCompletionHandler(_ handler: @escaping () -> ()) -> Self {
		self.completionHandler = handler
		return self
	}
	
	func resetObserver() {
		outputObserver = nil
		completionHandler = nil
	}
	
	func launch() -> Self {
		guard !task.isRunning else {
			return self
		}
		
		NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: outputPipe.fileHandleForReading, queue: nil, using:  { [weak self] (notification: Notification!) in
			guard let `self` = self else {
				return
			}
			
			let dataHandler: (Data) -> () = { data in
				if let outStr = NSString(data: data, encoding: CommandTask.ENCODING.rawValue) {
					let s = outStr as String
					if s != "" {
						self.outputObserver?(s)
					}
				}
			}
			dataHandler(self.outputPipe.fileHandleForReading.availableData)
			
			if self.task.isRunning {
				self.outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
			} else {
				let data = self.outputPipe.fileHandleForReading.readDataToEndOfFile()
				dataHandler(data)
				self.completionHandler?()
				self.terminate()
			}
		})
		outputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
		
		if !CommandTask.tasks.contains(where: { $0 == self }) {
			CommandTask.tasks.append(self)
		}
		print(CommandTask.tasks)
		
		task.launch()
		
		return self
	}
	
	func waitUntilExit() -> Int32 {
		task.waitUntilExit()
		return task.terminationStatus
	}
	
	func terminate() {
		task.terminate()
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name.NSFileHandleDataAvailable, object: outputPipe.fileHandleForReading)
		CommandTask.tasks = CommandTask.tasks.filter { $0 != self }
	}
	
	func afterTermination() {
		
	}
	
	func resume() -> Bool {
		return task.resume()
	}
	
	func suspend() -> Bool {
		return task.suspend()
	}
	
	func interrupt() {
		task.interrupt()
	}
	
	func writeData(_ data: Data) {
		inputPipe.fileHandleForWriting.write(data)
	}
	
	func write(_ string: String) {
		guard let data = string.data(using: CommandTask.ENCODING) else {
			return
		}
		writeData(data)
	}
	
	func writeln(_ string: String) {
		write(string + "\n")
	}
}
