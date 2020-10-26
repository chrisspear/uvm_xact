// UVM sequence item example with just field macros
// This gives false miscompares no compare should be done when cmd==NOOP

// A transaction class defined with the field macro style
class tx_item extends uvm_sequence_item;
  function new(string name="tx_item");
    super.new(name);
  endfunction

  rand logic [31:0] src, dst;
  rand command_t    cmd;
  logic [31:0]      result;

  // Macros create code to manipulate the properties
  `uvm_object_utils_begin(tx_item)
    `uvm_field_int(src, UVM_ALL_ON)
    `uvm_field_int(dst, UVM_ALL_ON)
    `uvm_field_enum(command_t, cmd, UVM_ALL_ON)
    `uvm_field_int(result, UVM_ALL_ON)
  `uvm_object_utils_end

endclass
