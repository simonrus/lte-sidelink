function [crc_bits] = calc_crc(in_bits, crc_type)
  %calc_crc
  %Cyclic redundancy check calculation and appending
  %The function is similar to lteCRCEncode(Matlab) or lte_calc_crc(openlte)
  % crc_type can be 16 or '24A'
  
  if(crc_type == 16)
      crc_poly = [1 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 1];
      crc_len = 16;
  elseif(crc_type == "24A")
      crc_poly = [1 1 0 0 0 0 1 1 0 0 1 0 0 1 1 0 0 1 1 1 1 1 0 1 1];
      crc_len = 24;
  else
      error(sprintf("Wrong parameter crc_type while calling calc_crc method"))
  end
  
  msg = [in_bits zeros(1, crc_len)];

  [q, r] = deconv(msg, crc_poly);
  
  crc_bits = mod(r, 2);
  crc_bits = crc_bits (end - crc_len + 1:end);
  
end