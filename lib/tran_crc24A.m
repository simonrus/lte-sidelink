function [output_bitseq, CRCerror_flg] = tran_crc24A( input_bitseq, mode )
%TRAN_CRC24A implements CRC of size 24 type A functionalities (attaching,
%detecting), following 36.212 - 5.1.1
% Inputs:
%   input_bitseq : input bit sequence
%   mode : 'encoding' for attaching, 'recover' for detecting
%#codegen

if ((license('test','Communication_Toolbox') == 0) || ...
    !isempty(getenv('USE_INHOUSE_IMPLEMENTATION')))

    crc_len = 24;

    if isequal(mode, 'encode')
        [crc_bits] = calc_crc(input_bitseq.', '24A');
        output_bitseq = [input_bitseq;crc_bits.'];
        CRCerror_flg = NaN;
    elseif isequal(mode, 'recover')
        [crc_bits] = calc_crc(input_bitseq.', '24A');
              
        CRCerror_flg = any(crc_bits == 1);
        
        output_bitseq = input_bitseq(1:length(input_bitseq) - crc_len);
    end
else
    % persistent hCRCEnc;
    % persistent hCRCDet;

    % if isempty(hCRCEnc)
        gCRC = zeros(1,25);
        gCRC(1,25-[24,23,18,17,14,11,10,7,6,5,4,3,1,0])=1;
        hCRCEnc = comm.CRCGenerator('Polynomial', gCRC);
    % end
    % if isempty(hCRCDet)
        gCRC = zeros(1,25);
        gCRC(1,25-[24,23,18,17,14,11,10,7,6,5,4,3,1,0])=1;
        hCRCDet = comm.CRCDetector('Polynomial', gCRC);
    % end


    if isequal(mode, 'encode')
        output_bitseq = step(hCRCEnc, input_bitseq);
        CRCerror_flg = NaN;
    elseif isequal(mode, 'recover')
        [output_bitseq, CRCerror_flg] = step(hCRCDet, input_bitseq);
    end
end 

end %function [output_bitseq, CRCerror_flg] = tran_crc24A( input_bitseq, mode )

