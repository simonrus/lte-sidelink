if exist('OCTAVE_VERSION', 'builtin') ~= 0 
    pkg load communications
end 

if ~exist('gen_tv_flag', 'var')
    load('turboenc_tv.mat');
    
    for idx = 1:length(tv)
        input = tv{idx}.input;
        exp_output = tv{idx}.output;
        our_output = turboenc(input, 0);
        assert(all (exp_output == our_output));
    end
else
    addpath("..");
    disp('generating test vectors for turboenc');
    
    payload_sizes = [40, 120, 480, 1056,  6144];
    tv = cell(length(payload_sizes), 1);
    for idx = 1:length(payload_sizes)
        blkLen = payload_sizes(idx);
        [f1, f2] = tran_turbo_coding_dil_params(blkLen); 
        assert(~((f1 == 1) && (f2 == 1))); % f1 and f2 cannot be equal to one together
        Idx      = (0:blkLen-1).';
        indices  =  mod(f1*Idx + f2*Idx.^2, blkLen) + 1;
        
        turboEnc = comm.TurboEncoder('TrellisStructure', poly2trellis(4, [13 15], 13),'InterleaverIndices', indices);
        
        input_bitseq = rand(payload_sizes(idx), 1) > 0.5;
        % encode data

        output = turboEnc(input_bitseq);
         
        tv{idx} = struct();
        tv{idx}.input = input;
        tv{idx}.output = output;
    end
    
    save('turboenc_tv.mat','tv','-v7.3');
    % create system object
end
  