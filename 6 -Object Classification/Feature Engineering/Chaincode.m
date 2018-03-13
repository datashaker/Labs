function chaine = Chaincode(im)

im1=bwboundaries(Smallest_Object_Removing(im));

if size (im1,1)>1 % to avoid the case of the internal contour in the case of MiimI or CaafI characters
    im1=im1(1);
end

b=cell2mat(im1);
sb=circshift(b,[-1 0]);
delta=sb-b;

% check if boundary is close, if not cut last element
if abs(delta(end,1))>1 || abs(delta(end,2))>1
    delta=delta(1:(end-1),:);
end

% check if boundary is 8-connected

n8c=find(abs(delta(:,1))>1 | abs(delta(:,2))>1);
if size(n8c,1)>0 
    s='';
    for i=1:size(n8c,1)
        s=[s sprintf(' idx -> %d \n',n8c(i))];
    end
    error('Curve isn''t 8-connected in elements: \n%s',s);
end

idx=3*delta(:,1)+delta(:,2)+5;
cm([1 2 3 4 6 7 8 9])=[5 6 7 4 0 3 2 1];

% finally the chain code array and the starting point

cc.x0=b(1,2);
cc.y0=b(1,1);
cc.code=(cm(idx))';
b=cc.code;
chaine=NumberFrequency(b');
end
