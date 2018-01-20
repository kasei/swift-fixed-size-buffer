import XCTest
@testable import FixedSizeBuffer

class fixed_size_bufferTests: XCTestCase {
    func testBuffer() {
        let u8 : UInt8 = 2
        let i16 : Int16 = 787
        let i : Int = 350
        
        let b = FixedSizeBuffer(16)
        let w = b.writer()
        do {
            XCTAssertEqual(w.offset, 0)
            try w.write(i16)
            XCTAssertEqual(w.offset, 2)
            try w.write(u8)
            XCTAssertEqual(w.offset, 3)
            try w.write("test")
            XCTAssertEqual(w.offset, 15)
        } catch let e {
            XCTFail("\(e)")
        }
        XCTAssertThrowsError(try w.write(i), "overflow")
        
        let r = b.reader()
        do {
            let got_i16 : Int16 = try r.read()
            let got_u8 : UInt8 = try r.read()
            let got_s : String = try r.read()
            XCTAssertEqual(got_i16, i16)
            XCTAssertEqual(got_u8, u8)
            XCTAssertEqual(got_s, "test")
        } catch let e {
            XCTFail("\(e)")
        }

        var tmp : UInt64 = 999
        XCTAssertThrowsError(try tmp = r.read(), "overflow")
        XCTAssertEqual(tmp, 999)

        do {
            r.reset() // try reading the bytes as different datatypes
            let got_u8 : UInt8 = try r.read()
            let got_i16 : Int16 = try r.read()
            let got_u64 : UInt64 = try r.read()
            let got_u8_2 : UInt8 = try r.read()

            XCTAssertEqual(got_u8, 3) // high byte of short 787
            XCTAssertEqual(got_i16, 4866) // ((low byte of short 787) << 8) + 2
            XCTAssertEqual(got_u64, 4) // length of string
            XCTAssertEqual(got_u8_2, 116) // 't' ascii
            
            XCTAssertEqual(r.remaining, 4)
        } catch let e {
            XCTFail("\(e)")
        }

        XCTAssertEqual(b.length, 16)
    }

    func testBufferWriteOverflow() {
        let size = 1024
        let b = FixedSizeBuffer(size)
        let w = b.writer()
        for i in 0..<size {
            let u8 = UInt8(i % 256)
            XCTAssertNoThrow(try w.write(u8))
        }
        XCTAssertThrowsError(try w.write(UInt8(1)))
    }
    
    static var allTests = [
        ("testBuffer", testBuffer),
    ]
}
