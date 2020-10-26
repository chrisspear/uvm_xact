// UVM sequence item example with a combination of field macros and do_methods
// This needs a special do_compare as no compare is done when cmd==NOOP

// A transaction class defined with a hybrid style
class tx_item extends uvm_sequence_item;
  function new(string name="tx_item");
    super.new(name);
  endfunction

  rand logic [31:0] src, dst;
  rand command_t    cmd;
  logic [31:0]      result;

  // This block is almost the same as fm.svh, just with "| UVM_NOCOMPARE:
  `uvm_object_utils_begin(tx_item)
    `uvm_field_int(src, UVM_ALL_ON | UVM_NOCOMPARE)
    `uvm_field_int(dst, UVM_ALL_ON | UVM_NOCOMPARE)
    `uvm_field_enum(command_t, cmd, UVM_ALL_ON | UVM_NOCOMPARE)
    `uvm_field_int(result, UVM_ALL_ON | UVM_NOCOMPARE)
  `uvm_object_utils_end


  virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    tx_item rhs_;
    if (!$cast(rhs_, rhs)) $fatal(0, "$cast failed");

    // For NOOP command, always return success
    if (cmd == NOOP)
      do_compare = 1;
    else begin
      // This is an example of calling the verbose compare methods
      do_compare = (super.do_compare(rhs, comparer) &&
		    comparer.compare_field("src", this.src, rhs_.src, 32) &&
		    comparer.compare_field("dst", this.dst, rhs_.dst, 32) &&
		    comparer.compare_field("cmd", this.cmd, rhs_.cmd, 2, UVM_ENUM) &&
		    comparer.compare_field("result", this.result, rhs_.result, 32));
    end
  endfunction

endclass
