function  output_bitseq  = tran_turbo_coding (input_bitseq, mode )
%tran_conv_coding implements 3GPP turbo coding (encoding & decoding)
% functionalities using MATLAB Communications System Toolbox System
% Objects: comm.TurboEncoder && ....
% 3GPPP 36.212 / 5.1.3.2
% mode 0: encoding
% mode 1: hard decoding
% mode 2: soft decoding
%#codegen

%persistent hTurboEnc;
output_bitseq = -1;

%% init
if mode == 0
    blkLen = length(input_bitseq);
else
    blkLen = (length(input_bitseq)-12)/3;    
end

% Interleaver parameters: Table 5.1.3-3 of the reference
% get f1,f2
% Allowed values of K
validK = [40:8:512 528:16:1024 1056:32:2048 2112:64:6144];
assert(ismember(blkLen, validK), 'comm:getf1f2:InvalidBlkLen', ...
    ['Invalid block length specified. The block length must be one',...
    ' out of [40:8:512 528:16:1024 1056:32:2048 2112:64:6144] values.']);
[f1, f2] = tran_turbo_coding_dil_params(blkLen); 
Idx      = (0:blkLen-1).';
indices  =  mod(f1*Idx + f2*Idx.^2, blkLen) + 1;

% for i=1:length(indices)
%     fprintf('%i,',indices(i));
% end
% keyboard

%% running

if mode == 0
    % create system object
    turboEnc = comm.TurboEncoder('TrellisStructure', poly2trellis(4, [13 15], 13),'InterleaverIndices', indices);
    % encode data
    yEnc = turboEnc(input_bitseq);
    % reorganize output in per stream format
    D = length(yEnc)/3;
    output_bitseq = zeros(3*D,1);
    y_perStream = -ones(D,3);
    y_perStream(:,1) = yEnc(1:3:3*D,1);
    y_perStream(:,2) = yEnc(2:3:3*D,1);
    y_perStream(:,3) = yEnc(3:3:3*D,1);
    output_bitseq(:) = y_perStream(:); % output: [D0 D1 D2]    
elseif mode == 1    
    % create system object
    turboDec  = comm.TurboDecoder('TrellisStructure', poly2trellis(4, [13 15], 13),'InterleaverIndices', indices, 'Algorithm', 'Max');
    % reorganize input from per-stream ([D0 D1 D2]) to mixed-stream format
    D = length(input_bitseq)/3;
    input_bitseq_mixedStream = -ones(3*D,1);   
    for i = 1:D
        input_bitseq_mixedStream((i-1)*3+1:3*i,1) = input_bitseq([i, i+D, i+2*D],1);
    end
    % decode data
    yDec = turboDec(input_bitseq_mixedStream);
    % assign    
    output_bitseq = zeros(blkLen,1);
    output_bitseq(:,1) = yDec(:,1);        
end % mode



end % function
