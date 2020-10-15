// Test for various UVM sequence items
// Compile with:
// qrun -quiet top.sv +define+FM
// qrun -quiet top.sv +define+DO
// qrun -quiet top.sv +define+hybrid
//

// Package should go in separate file. However, trying to keep this simple.
package xact_pkg;
  import uvm_pkg::*;
`include "uvm_macros.svh"

  typedef enum {READ, WRITE, NOOP} command_t;

// Every include file defines the same tx_item class, just different styles
`ifdef DO
 `include "do.svh"
`elsif FM
 `include "fm.svh"
`else // Default
 `include "hybrid.svh"
`endif

endpackage : xact_pkg



//////////////////////////////////////////////////////////////////
module top;
  import uvm_pkg::*;
`include "uvm_macros.svh"
  import xact_pkg::*;


  tx_item t1, t2, t3;
  bit r;
  initial begin
    t1 = tx_item::type_id::create("t1");
    t1.src = 0;
    t1.dst = 3;
    t1.cmd = READ;
    t1.result = 9;
    $cast(t2, t1.clone());
    $display("t1.sprint():\n%s", t1.sprint());
    $display("t2.sprint():\n%s", t2.sprint());

    $display("\n Comparing identical objects");
    $display("t1.compare(t2) = %b, expected 1", t1.compare(t2));

    $display("\n Comparing objects with different src, WRITE command, should fail");
    t1.cmd = WRITE;
    t2.cmd = WRITE;
    t1.src = 1;
    t2.src = 2;
    r = t1.compare(t2);
    $display("t1.compare(t2) = %b, expected 0", r);

    $display("\n Comparing objects with different src, NOOP command, should succeed");
    t1.cmd = NOOP;
    t2.cmd = NOOP;
    r = t1.compare(t2);
    $display("t1.compare(t2) = %b, expected 1", r);
  end
endmodule
