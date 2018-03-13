function  im=Lissage(im) 

[r c]=size(im);
im=[zeros(r,1),im,zeros(r,1)];
im=[zeros(1,c+2);im;zeros(1,c+2)];
cp=0;
newim=zeros(r);
while ~(isequal(im,newim))
    newim=im;
    for i=2:r
        for j=2:c
            if isequal(im(i,j-1),im(i-1,j-1),im(i-1,j),im(i-1,j+1),im(i,j+1))
                im(i,j)=im(i,j-1);
               
            end
            
            if isequal(im(i-1,j),im(i-1,j+1),im(i,j+1),im(i+1,j+1),im(i+1,j))
                im(i,j)=im(i-1,j);
             
            end
            
            if isequal(im(i,j-1),im(i+1,j-1),im(i+1,j),im(i+1,j+1),im(i,j+1))
                im(i,j)=im(i,j-1);
                
            end
            
            if isequal(im(i-1,j),im(i-1,j-1),im(i,j-1),im(i+1,j-1),im(i+1,j))
                im(i,j)=im(i-1,j);  
            
            end
        end
    end
    cp=cp+1;
end

im(:,1)=[];
im(:,c+1)=[];
im(1,:)=[];
im(r+1,:)=[];

end

