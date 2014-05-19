; Show that we detect when a negative offset is used within a relocation.

; RUN: llvm-as < %s | pnacl-freeze | pnacl-bcdis  | FileCheck %s

@bytes = internal global [7 x i8] c"abcdefg"
@addend_negative = internal global i32 add (i32 ptrtoint ([7 x i8]* @bytes to i32), i32 -1)

; CHECK:            0:0|<65532, 80, 69, 88, 69, 1, 0,|Magic Number: 'PEXE' (80, 69, 88, 69)
; CHECK-NEXT:          | 8, 0, 17, 0, 4, 0, 2, 0, 0, |PNaCl Version: 2
; CHECK-NEXT:          | 0>                          |
; CHECK-NEXT:      16:0|1: <65535, 8, 2>             |module {  // BlockID = 8
; CHECK-NEXT:      24:0|  3: <1, 1>                  |  version 1;
; CHECK-NEXT:      26:4|  1: <65535, 0, 2>           |  abbreviations {  // BlockID = 0
; CHECK-NEXT:      27:6|  0: <65534>                 |  }
; CHECK-NEXT:     132:0|  1: <65535, 17, 3>          |  types {  // BlockID = 17
; CHECK-NEXT:     149:2|    3: <1, 0>                |    count 0;
; CHECK-NEXT:     151:7|  0: <65534>                 |  }
; CHECK-NEXT:     156:0|  1: <65535, 19, 4>          |  globals {  // BlockID = 19
; CHECK-NEXT:     164:0|    3: <5, 2>                |    count 2;
; CHECK-NEXT:     166:6|    4: <0, 0, 0>             |    var @g0, align 0,
; CHECK-NEXT:     168:1|    7: <3, 97, 98, 99, 100,  |      { 97,  98,  99, 100, 101, 102, 
; CHECK-NEXT:          |        101, 102, 103>       |       103}
; CHECK-NEXT:     176:3|    4: <0, 0, 0>             |    var @g1, align 0,
; CHECK-NEXT:     177:6|    9: <4, 0, 4294967295>    |      reloc @g0 - 1;
; CHECK-NEXT:     184:2|  0: <65534>                 |  }
; CHECK-NEXT:     188:0|  1: <65535, 14, 3>          |  valuesymtab {  // BlockID = 14
; CHECK-NEXT:     196:0|    6: <1, 1, 97, 100, 100,  |    @g1 : "addend_negative";
; CHECK-NEXT:          |        101, 110, 100, 95,   |
; CHECK-NEXT:          |        110, 101, 103, 97,   |
; CHECK-NEXT:          |        116, 105, 118, 101>  |
; CHECK-NEXT:     209:3|    6: <1, 0, 98, 121, 116,  |    @g0 : "bytes";
; CHECK-NEXT:          |        101, 115>            |
; CHECK-NEXT:     215:2|  0: <65534>                 |  }
; CHECK-NEXT:     216:0|0: <65534>                   |}
