function V=NumberFrequency(A) 
unqA=unique(A);
[r c]=size(unqA);
countElA=histc(A,unqA);%# get the count of elements
V=zeros(1,8);
for i=1:c
    V(unqA(i)+1)=countElA(i);
end
 V;
end