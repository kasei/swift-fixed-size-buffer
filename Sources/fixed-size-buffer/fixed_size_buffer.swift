import Foundation

enum FixedSizeBufferError : Error {
    case overflow
}

private func _sizeof<T>(_ value: T.Type) -> Int {
    return MemoryLayout<T>.size
}

public class FixedSizeBuffer {
    let length : Int
    var data : Data
    public init(_ length : Int) {
        self.length = length
        self.data = Data(repeating: 0, count: length)
    }
}

public class FixedSizeBufferReader {
    let buffer : FixedSizeBuffer
    var offset : Int
    public init(_ buffer : FixedSizeBuffer) {
        self.offset = 0
        self.buffer = buffer
    }
    
    func read() throws -> Int {
        let value : UInt64 = try self.read()
        return Int(value)
    }
    
    func read<T : FixedWidthInteger>() throws -> T {
        let size = _sizeof(T.self)
        guard (offset + size) <= buffer.length else { throw FixedSizeBufferError.overflow }
        defer { self.offset += size }
        let subdata = buffer.data.subdata(in: offset..<(offset+size))
        return subdata.withUnsafeBytes { (ptr) in
            return T(bigEndian: ptr.pointee)
        }
    }
    
    func read() throws -> String {
        let size : Int = try self.read()
        print("reading string of length \(size)")
        guard (offset + size) <= buffer.length else { throw FixedSizeBufferError.overflow }
        defer { self.offset += size }
        let subdata = buffer.data.subdata(in: offset..<(offset+size))
        return String(data: subdata, encoding: .utf8)!
    }
}

public class FixedSizeBufferWriter {
    let buffer : FixedSizeBuffer
    var offset : Int
    public init(_ buffer : FixedSizeBuffer) {
        self.offset = 0
        self.buffer = buffer
    }
    
    func write(_ value : Int) throws {
        try self.write(UInt64(value))
    }
    
    func write<T : FixedWidthInteger>(_ value : T) throws {
        let size = _sizeof(T.self)
        guard (offset + size) <= buffer.length else { throw FixedSizeBufferError.overflow }
        defer { self.offset += size }
        
        var v = value.bigEndian
        withUnsafeBytes(of: &v) { (ptr) in
            let range : Range<Int> = offset..<(offset+size)
            print("writing \(size) byte \(T.self) (\(range)) to buffer at offset \(offset) from \(ptr)")
            buffer.data.replaceSubrange(range, with: ptr.baseAddress!, count: size)
        }
    }
    
    func write(_ value : String) throws {
        let chars = value.utf8.map { UInt8($0) }
        let size : Int = chars.count
        print("writing \(size) byte string to buffer at offset \(offset)")
        guard (offset + size + _sizeof(UInt64.self)) <= buffer.length else { throw FixedSizeBufferError.overflow }
//        defer { self.offset += size }
        try self.write(size)
        
        for c in chars {
            try self.write(c)
        }
    }
}

