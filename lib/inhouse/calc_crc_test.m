 pkg load communications
 test_payload = {   [1], ...
                    de2bi(hex2dec('C0FFEE'), 24, 'left-msb'), ...
                    de2bi(hex2dec('DEADBEAF'), 32, 'left-msb')};

 expected_crc16 = { de2bi(hex2dec('1021'), 16, 'left-msb'), ...
                    de2bi(hex2dec('39E8'), 16, 'left-msb'), ...
                    de2bi(hex2dec('8C93'), 16, 'left-msb')};
 
 expected_crc24A = {de2bi(hex2dec('864CFB'), 24, 'left-msb'), ...
                    de2bi(hex2dec('959E16'), 24, 'left-msb'), ...
                    de2bi(hex2dec('7D9117'), 24, 'left-msb')};

 for idx = 1:length(test_payload)
    crc16 = calc_crc(test_payload{idx}, 16);
    assert(all(crc16 == expected_crc16{idx}));
    crc24A = calc_crc(test_payload{idx}, '24A');
   assert(all(crc24A == expected_crc24A{idx}));
 end 
 
 %!test
 %! assert(1)