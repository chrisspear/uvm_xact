// UVM sequence item example with do methods

// A transaction class defined with the do method style
class tx_item extends uvm_sequence_item;
  `uvm_object_utils(tx_item)
  function new(string name="tx_item");
    super.new(name);
  endfunction
  rand logic [31:0] src, dst;
  rand command_t    cmd;
  logic [31:0]      result;


  virtual function void do_copy(uvm_object rhs);
    tx_item rhs_;
    if (!$cast(rhs_, rhs)) $fatal(0, "$cast failed");
    super.do_copy(rhs);
    this.src = rhs_.src;
    this.dst = rhs_.dst;
    this.cmd = rhs_.cmd;
    this.result = rhs_.result;
  endfunction


  virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    tx_item rhs_;
    if (!$cast(rhs_, rhs)) $fatal(0, "$cast failed");

    // For NOOP command, always return success
    if (cmd == NOOP) 
      do_compare = 1;
    else
      do_compare = (super.do_compare(rhs, comparer) &&
		    (this.src === rhs_.src) &&
		    (this.dst === rhs_.dst) &&
		    (this.cmd === rhs_.cmd) &&
		    (this.result === rhs_.result));
  endfunction


  virtual function void do_print(uvm_printer printer);
    printer.m_string = $sformatf("tx_item: cmd=%s(%0x) src=0x%0x dst=0x%0x result=0x%0x",
				 cmd.name(), cmd, src, dst, result);
  endfunction

endclass
