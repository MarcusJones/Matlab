clear

for k = 1:16
	plot(fft(eye(k+16)))
	axis equal
	Frames = getframe;
end

%movie(M,30)
colormap('default')
map = colormap

mpgwrite(Frames,map,'sstmovie.mpg')

   colormap('jet')

   
   

nframes = 12;              % number of frames in the movie
Frames = moviein(nframes); % initialize the matrix 'Frames'

%figure
for k = 1:5
    Mol = TwoPointMollier(Air.Amb(k,2),Air.Amb(k,4),Air.Proc(k,2),Air.Proc(k,4));
	axis equal
	Frames(k) = getframe(Mol);
    hold on
end

colormap('default')

mpgwrite(M,colormap,'sstmovie.mpg')
   
   
   % Load in monthly coads climatology and display as a movie
% written  for oc3030

reruns=1;                  % number of times movie is to play
fps=5;                     % frames per second

nframes = 12;              % number of frames in the movie
Frames = moviein(nframes); % initialize the matrix 'Frames'

title('SST Climatology')    

% Load each month, contour it and save it in a frame:
   load sstjan.dat
   contourf(sstjan); 
   colormap('jet')
   Frames(:,1)=getframe;
%
   load sstfeb.dat
   contourf(sstfeb);
   Frames(:,2) = getframe;
%
   ...

   ... do all 12 months that way, ending with:
   Frames(:,12) = getframe;

% Now play the movie: 
   movie(Frames,reruns,fps)
