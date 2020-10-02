// UVM sequence item example with do methods

// This class is a dummy in the initial version
class tx_payload extends uvm_sequence_item;
  `uvm_object_utils(tx_payload)
  function new(string name="tx_payload");
    super.new(name);
  endfunction
endclass


// This is the transaction
class tx_item extends uvm_sequence_item;
  `uvm_object_utils(tx_item)
  function new(string name="tx_item");
    super.new(name);
  endfunction
  rand logic [31:0] src, dst;
  rand command_t    cmd;
  rand tx_payload   pay_h;
  logic [31:0] result;
  logic [99:0] temp; // Not copied or compared


  virtual function void do_copy(uvm_object rhs);
    tx_item rhs_;
    if (!$cast(rhs_, rhs)) $fatal(0, "$cast failed");
    super.do_copy(rhs);
    this.src = rhs_.src;
    this.dst = rhs_.dst;
    this.cmd = rhs_.cmd;
    this.result = rhs_.result;
    this.pay_h = rhs_.pay_h;
  endfunction


  virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    tx_item rhs_;
    if (!$cast(rhs_, rhs)) $fatal(0, "$cast failed");
    do_compare = (super.do_compare(rhs, comparer) &&
		  (this.src === rhs_.src) &&
		  (this.dst === rhs_.dst) &&
		  (this.cmd === rhs_.cmd) &&
		  (this.result === rhs_.result));
  endfunction

  virtual function string convert2string();
    return $sformatf("tx_item: cmd=%s(%0x) src=0x%0x dst=0x%0x result=0x%0x",
		     cmd.name(), cmd, src, dst, result);
  endfunction

  virtual function void do_print(uvm_printer printer);
    printer.m_string = convert2string();
  endfunction
    


endclass
