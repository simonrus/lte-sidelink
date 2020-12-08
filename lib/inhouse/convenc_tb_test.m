if exist('OCTAVE_VERSION', 'builtin') ~= 0 
    pkg load communications
end 

trellis = poly2trellis(7, [133 171 165]);

if ~exist('gen_tv_flag', 'var')
    load('convenc_tb_tv.mat');
    for idx = 1:length(tv)
        input = tv{idx}.input;
        exp_output = tv{idx}.output;       
        
        our_output = convenc_tb(input, trellis);
        assert(all (exp_output == our_output));
    end
else
    addpath("..");
    disp('generating test vectors for convenc_tb');
    payload_sizes = [6, 16, 35, 100];
    tv = cell(length(payload_sizes), 1);
    
    hChanEnc = comm.ConvolutionalEncoder(...
                'TrellisStructure',trellis, ...
                'TerminationMethod','Truncated', ...
                'InitialStateInputPort',true, ...
                'FinalStateOutputPort',true);
    
    for idx = 1:length(payload_sizes)
        input_bitseq = rand(payload_sizes(idx), 1) > 0.5;
        
        D = length(input_bitseq);

        % trellis termination
        % Get the last 6 information bits and set them as initial state to the encoder
        InitState_bitseq = double(input_bitseq(end-6+1:end));
        %InitState_int = step(hBitToIntBCHinit,InitState_bitseq);
        InitState_int = bitTodec(InitState_bitseq, false); % MSB-->last
        % Encode data with the above initial state
        outConvEnc = step(hChanEnc, input_bitseq, InitState_int);
      
        tv{idx} = struct();
        tv{idx}.input = input_bitseq;
        tv{idx}.output = outConvEnc;
    end
    save('convenc_tb_tv.mat','tv','-v7.3');
end

%% Unittest declaration for Octave (https://wiki.octave.org/Tests)
%!test
 %! assert(1)

