function A_P_R = Area_Perimeter_Ratio(im)
L=bwlabel(im);
Z1=regionprops(L,'Area');
Z2=regionprops(L,'Perimeter');
A_P_R= cell2mat(struct2cell(Z1))/cell2mat(struct2cell(Z2));
A_P_R(~isfinite(A_P_R))=0;

end

