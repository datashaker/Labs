function SquelDataSetFunction()

pathname = 'LocalisedDataSet\' ;
directories = dir(pathname);

for i=3:length(directories)
    [~,f]=fileparts(directories(i).name);
    k= 1;
    categorie='';
    while isletter(f(k)) 
        categorie = strcat (categorie,f(k));
        k=k+1;
    end
    
    % read image
    path_im=strcat(pathname,directories(i).name);
    im=imread(path_im);
   
    imth= ZhangSuenThinning(im); % Zhang and Suen algorithm
    
   imwrite(imth,directories(i).name);
    
   display (i / length(directories)*100)
end 

end
