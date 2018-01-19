import XCTest
@testable import fixed_size_buffer

class fixed_size_bufferTests: XCTestCase {
    func testBuffer() {
        let u8 : UInt8 = 2
        let i16 : Int16 = 787
        let i : Int = 350
        
        let b = FixedSizeBuffer(16)
        let w = FixedSizeBufferWriter(b)
        do {
//            print("\(w.buffer.data)")
            XCTAssertEqual(w.offset, 0)
            try w.write(i16)
//            print("\(w.buffer.data)")
            XCTAssertEqual(w.offset, 2)
            try w.write(u8)
//            print("\(w.buffer.data)")
            XCTAssertEqual(w.offset, 3)
            try w.write("test")
//            print("\(w.buffer.data)")
            XCTAssertEqual(w.offset, 15)
//            try w.write(i)
//            XCTAssertEqual(w.offset, 0)
        } catch let e {
            XCTFail("\(e)")
        }
        XCTAssertThrowsError(try w.write(i), "overflow")
        
        let r = FixedSizeBufferReader(b)
        do {
            print("read offset \(r.offset)")
            let got_i16 : Int16 = try r.read()
            print("read offset \(r.offset)")
            let got_u8 : UInt8 = try r.read()
            print("read offset \(r.offset)")
            let got_s : String = try r.read()
            print("read offset \(r.offset)")
            XCTAssertEqual(got_i16, i16)
            XCTAssertEqual(got_u8, u8)
            XCTAssertEqual(got_s, "test")
        } catch let e {
            XCTFail("\(e)")
        }
        
        var tmp : UInt64 = 999
        XCTAssertThrowsError(try tmp = r.read(), "overflow")
        XCTAssertEqual(tmp, 999)
        
        XCTAssertEqual(b.length, 16)
    }

    static var allTests = [
        ("testBuffer", testBuffer),
    ]
}
