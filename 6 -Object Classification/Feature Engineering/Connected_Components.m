function Nb_CC=CC_Final(im)
    

    [C,Nb_CC]= bwlabel(im);
    ccprops=regionprops(bwlabel(im),'Area');
    
    if Nb_CC > 1
        switch Nb_CC
             case 2,
                 m=min(cell2mat(struct2cell(ccprops)));
                 if m>100
                     Nb_CC=Nb_CC+1;
                 end
             case 3,
                 t=sort(cell2mat(struct2cell(ccprops)));
                 if t(2)>100
                     Nb_CC=Nb_CC+1;
                 end
        end
   
    end
     Nb_CC;
end
