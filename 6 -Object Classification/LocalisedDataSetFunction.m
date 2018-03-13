function LocalisedDataSetFunction()

pathname = 'CleanedDataSet\' ; 
directories = dir(pathname);

% a+ : Append data to the end of the file, w+ : Discard existing contents, if any.
%fid = fopen('C:\Users\Desktop\MyThesis\File_Features.txt','W');

for i=3:length(directories)
    [~,f]=fileparts(directories(i).name);
    k= 1;
    categorie='';
    while isletter(f(k)) 
        categorie = strcat (categorie,f(k));
        k=k+1;
    end
    
    % reading image
    path_im=strcat(pathname,directories(i).name);
    im=~imread(path_im);
    
    % Image localization , 1: Black and 0 : white
    
    imloc=discourser(~im);
    imwrite(imloc,directories(i).name);
    display (i / length(directories)*100)
end % end for

end
