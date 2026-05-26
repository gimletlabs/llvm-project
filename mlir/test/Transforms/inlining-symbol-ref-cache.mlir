// RUN: mlir-opt %s -allow-unregistered-dialect -inline='default-pipeline=''' | FileCheck %s

// The same flat symbol ref can refer to different symbols in different sibling
// symbol tables. Inliner liveness must resolve symbol refs in their local scope
// instead of reusing a previous resolution from another symbol table.

module {
  // CHECK-LABEL: module @prefill
  module @prefill {
    // CHECK: "test.symbol_ref_attr"() {symbol = @shared}
    "test.symbol_ref_attr"() {symbol = @shared} : () -> ()

    // CHECK: func.func private @shared()
    func.func private @shared() {
      return
    }
  }

  // CHECK-LABEL: module @decode
  module @decode {
    // CHECK: "test.symbol_ref_attr"() {symbol = @shared}
    "test.symbol_ref_attr"() {symbol = @shared} : () -> ()

    // CHECK: func.func private @shared()
    func.func private @shared() {
      return
    }
  }
}
