A=[];
for i=1:9
img = strcat('face/face0000',int2str(i),'.pgm');
a=imread(img);
b=double(a);
g=reshape(b,19*19,1);
h=double(g);
A=[A h];
end

 for i=10:99
 img = strcat('face/face000',int2str(i),'.pgm');
 a=imread(img);
 b=double(a);
 g=reshape(b,19*19,1);
 h=double(g);
 A=[A h];
 end

for i=100:999
img = strcat('face/face00',int2str(i),'.pgm');
a=imread(img);
b=double(a);
g=reshape(b,19*19,1);
h=double(g);
A=[A h];
end

for i=1000:2429
img = strcat('face/face0',int2str(i),'.pgm');
a=imread(img);
b=double(a);
g=reshape(b,19*19,1);
h=double(g);
A=[A h];
end

% for i=0:9
% img = strcat('face/cmu000',int2str(i),'.pgm');
% a=imread(img);
% b=double(a);
% g=reshape(b,19*19,1);
% h=double(g);
% A=[A h];
% end
% 
%  for i=10:99
%  img = strcat('face\cmu00',int2str(i),'.pgm');
%  a=imread(img);
%  b=double(a);
%  g=reshape(b,19*19,1);
%  h=double(g);
%  A=[A h];
%  end
% 
% for i=100:451
% img = strcat('face\cmu0',int2str(i),'.pgm');
% a=imread(img);
% b=double(a);
% g=reshape(b,19*19,1);
% h=double(g);
% A=[A h];
% end
% 

% for i=1:9
% img = strcat('non-face/B1_0000',int2str(i),'.pgm');
% a=imread(img);
% b=double(a);
% g=reshape(b,19*19,1);
% h=double(g);
% A=[A h];
% end
% 
%  for i=10:99
%  img = strcat('non-face/B1_000',int2str(i),'.pgm');
%  a=imread(img);
%  b=double(a);
%  g=reshape(b,19*19,1);
%  h=double(g);
%  A=[A h];
%  end
% 
% for i=100:559
% img = strcat('non-face/B1_00',int2str(i),'.pgm');
% a=imread(img);
% b=double(a);
% g=reshape(b,19*19,1);
% h=double(g);
% A=[A h];
% end


% for i=0:9
% img = strcat('non-face/B5_0000',int2str(i),'.pgm');
% a=imread(img);
% b=double(a);
% g=reshape(b,19*19,1);
% h=double(g);
% A=[A h];
% end
% 
% for i=10:99
% img = strcat('non-face/B5_000',int2str(i),'.pgm');
% a=imread(img);
% b=double(a);
% g=reshape(b,19*19,1);
% h=double(g);
% A=[A h];
% end
% 
% for i=100:340
% img = strcat('non-face/B5_00',int2str(i),'.pgm');
% a=imread(img);
% b=double(a);
% g=reshape(b,19*19,1);
% h=double(g);
% A=[A h];
% end

% for i=1507:4305
% img = strcat('non-face/B20_0',int2str(i),'.pgm');
% a=imread(img);
% b=double(a);
% g=reshape(b,19*19,1);
% h=double(g);
% A=[A h];
% end

% for i=0:227
% img = strcat('non-face/geyser27_',int2str(i),'.pgm');
% a=imread(img);
% b=double(a);
% g=reshape(b,19*19,1);
% h=double(g);
% A=[A h];
% end

% for i=0:227
% img = strcat('non-face/goldwater67_',int2str(i),'.pgm');
% a=imread(img);
% b=double(a);
% g=reshape(b,19*19,1);
% h=double(g);
% A=[A h];
% end

% for i=0:227
% img = strcat('non-face/graves111_',int2str(i),'.pgm');
% a=imread(img);
% b=double(a);
% g=reshape(b,19*19,1);
% h=double(g);
% A=[A h];
% end

for i=0:164
img = strcat('non-face/GULF_',int2str(i),'.pgm');
a=imread(img);
b=double(a);
g=reshape(b,19*19,1);
h=double(g);
A=[A h];
end

Data = A';
save('faces7.mat','Data');
save('faces7.dat','Data','-ascii');

% labs = genlab ([2429 1749], [1 0]');
% 
% x = pr_dataset(Data,labs);
%  
% x = setname(x,'mit_cbcl')
% 
% x = setuser(x,user);
