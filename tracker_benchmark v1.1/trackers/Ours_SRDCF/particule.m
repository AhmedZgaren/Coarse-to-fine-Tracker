%function position=particule(c,i,k,ps)
function position=particule(c,r,ps)
 %r: nombre aleatoire entre {0,1}
 %ps: position de la cible dans la trame precedente
 
 %position: la position de la particule dans la trame courant
 
 x = ps(1,1);
 y = ps(1,2);
 w=ps(1,3);
 h=ps(1,4);
 theta=r*2*pi;
 xt=x+round(c*r*cos(theta));
 yt=y+round(c*r*sin(theta));
 %%Scale

 %w=ps(1,3)*r;
 %h=ps(1,4)*2*r;
 position = [xt yt w h];

end