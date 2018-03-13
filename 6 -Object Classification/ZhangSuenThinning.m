function ImThin=ZhangSuenThinning(ImageToThining)

continue_it = 1;

while continue_it
im_org_old=ImageToThining;
im_org_del=zeros(size(ImageToThining));

for i=2:size(ImageToThining,1)-1
    for j = 2:size(ImageToThining,2)-1
        P = [ImageToThining(i,j) ImageToThining(i-1,j) ImageToThining(i-1,j+1) ImageToThining(i,j+1) ImageToThining(i+1,j+1) ImageToThining(i+1,j) ImageToThining(i+1,j-1) ImageToThining(i,j-1) ImageToThining(i-1,j-1) ImageToThining(i-1,j)];
        if P(2)*P(4)*P(6)==0 && P(4)*P(6)*P(8)==0 && sum(P(2:end-1))<=6 && sum(P(2:end-1)) >=2
            A = 0;
            for k = 2:size(P(:),1)-1
                if P(k) == 0 && P(k+1)==1
                    A = A+1;
                end%if
            end%for
            if (A==1)
                im_org_del(i,j)=1;
            end%if
        end%if
    end%for
end%for

ImageToThining(find(im_org_del==1))=0;
for i=2:size(ImageToThining,1)-1
    for j = 2:size(ImageToThining,2)-1
        P = [ImageToThining(i,j) ImageToThining(i-1,j) ImageToThining(i-1,j+1) ImageToThining(i,j+1) ImageToThining(i+1,j+1) ImageToThining(i+1,j) ImageToThining(i+1,j-1) ImageToThining(i,j-1) ImageToThining(i-1,j-1) ImageToThining(i-1,j)];
        if P(2)*P(4)*P(8)==0 && P(2)*P(6)*P(8)==0 && sum(P(2:end-1))<=6 && sum(P(2:end-1)) >=2
            A = 0;
            for k = 2:size(P(:),1)-1
                if P(k) == 0 && P(k+1)==1
                    A = A+1;
                end%if
            end%for
            if (A==1)
                im_org_del(i,j)=1;
            end%if
        end%if
    end%for
end%for
ImageToThining(find(im_org_del==1))=0;
if isequal(im_org_old(:),ImageToThining(:))
   continue_it=0;
end%if
end%while
 
ImThin=ImageToThining;

end

