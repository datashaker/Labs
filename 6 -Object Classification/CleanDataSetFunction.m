function CleanDataSetFunction()

pathname = '' ; 
directories = dir(pathname);

for i=3:length(directories)
    path_im=strcat(pathname,directories(i).name);
    im=imread(path_im);
    
%   Remove isolated pixels
    imclean=bwmorph(im,'clean');
    
%   Lissage
   imliss=Lissage(~imclean);
     
   imwrite(imliss,directories(i).name);

   display (i / length(directories)*100)
end % end for

end

