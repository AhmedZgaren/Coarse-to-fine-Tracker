function x = mit_cbcl(val)

if nargin<1
	val = 'remove';
end

user.desc = 'The purpose of the analysis is to develop a screening procedure to detect faces. ';

Data = load('faces7.dat');
labs = genlab ([2429 165], [1 0]');
x = pr_dataset(Data,labs);

x = setname(x,'mit_cbcl');

%[x,msg] = prmissingvalues(x,val);
%user.desc = [user.desc msg];
x = setuser(x,user);

return
