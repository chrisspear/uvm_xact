// Test for various UVM sequence items
// Compile with:
// qrun -quiet top.sv +define+FM
// qrun -quiet top.sv +define+DO
// qrun -quiet top.sv +define+hybrid
//
module top;
  import uvm_pkg::*;
`include "uvm_macros.svh"
  typedef enum {READ, WRITE} command_t;

`ifdef FM
 `include "fm.svh"
`elsif DO
  `include "do.svh"
`elsif HYBRID
  `include "hybrid.svh"
`endif

  tx_item t1, t2, t3;
  initial begin
    t1 = tx_item::type_id::create("t1");
    t1.src = 0;
    t1.dst = 3;
    t1.cmd = READ;
    t1.result = 9;
    $cast(t2, t1.clone());
    $display("t1.sprint()\n%s", t1.sprint());
    $display("t2.sprint()\n%s", t2.sprint());

    $display("\n Comparing identical objects");
    $display("t1.compare(t2) = %b, expected 1", t1.compare(t2));

    $display("\n Comparing objects with different src");
    t1.src = 1;
    t2.src = 2;
    $display("t1.compare(t2) = %b, expected 0", t1.compare(t2));
  end
endmodule


/*
 DO:
 (No message from compare)

 FM:
# UVM_INFO @ 0: reporter [MISCMP] Miscompare for t1.src: lhs = 'h1 : rhs = 'h2
# UVM_INFO @ 0: reporter [MISCMP] 1 Miscompare(s) for object t1@470 vs. t1@466

 HYBRID:
# UVM_INFO @ 0: reporter [MISCMP] Miscompare for t1.src: lhs = 'h1 : rhs = 'h2
# UVM_INFO @ 0: reporter [MISCMP] 1 Miscompare(s) for object t1@470 vs. t1@466

 */
