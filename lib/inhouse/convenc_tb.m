function [cw_seq] = convenc_tb(msg, trellis)
  %convenc_tb
  %The following function encodes message using full Convolutional Tail Biting 
  %coding
  %   trellis - trellis shall be created using poly2trellis function
  
  M = log2(trellis.numStates); % number of registers
  
  if (length(msg) >= M)
    % set state to last M information bitset
    istate = bi2de(msg(end - M + 1:end), 'right-msb'); % set inital state !(right msb)
  else
    assert("Failed, need an update");
  end

  [cw_seq, final_state] = convenc(msg, trellis,[], istate);
  assert(final_state == istate, "Tailbiting encoding failed: start and end state differs");
end
