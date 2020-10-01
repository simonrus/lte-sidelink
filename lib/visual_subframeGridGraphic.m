function visual_subframeGridGraphic( grid )
%VISUAL_GRIDGRAPHIC visually illustrates a subframe
%   Detailed explanation goes here

a = grid; 
b = [[a nan*zeros(size(a,1),1)] ; nan*zeros(1,size(a,2)+1)];
map = (abs(b)>0) * 1.0; % float matrix is required by pcolor in Octave
pcolor(map); colormap([1 1 1; 1 0 0]);
shading flat
colormap([1 1 1; 1 0 0]);
xlabel('SC-FDMA symbol');
ylabel('subcarrier');

end

