function Cav=Concavity(im)

CE=0; % East concavity
CS=0; % South concavity
CO=0; % West concavity
CN=0; % North concavity
CSE=0;
[r c]=size(im);

diag(im);

for i=2:r-1
    for j=2:c-1

        if im(i,j)==0
            
            if (ismember(1,im(i,j-1:-1:1))&&ismember(1,im(i-1:-1:1,j))&&ismember(1,im(i+1:end,j))&&~ismember(1,im(i,j+1:end)))
                CE=1; break;
            end
            if (~ismember(1,im(i,j-1:-1:1))&&ismember(1,im(i-1:-1:1,j))&&ismember(1,im(i+1:end,j))&&ismember(1,im(i,j+1:end)))
                CO=1; break;
            end
            if (ismember(1,im(i,j-1:-1:1))&&ismember(1,im(i-1:-1:1,j))&&~ismember(1,im(i+1:end,j))&&ismember(1,im(i,j+1:end)))
                CS=1; break;
            end

            if (ismember(1,im(i,j-1:-1:1))&&~ismember(1,im(i-1:-1:1,j))&&ismember(1,im(i+1:end,j))&&ismember(1,im(i,j+1:end)))
                CN=1; 
                break;
            end

        end
    end
end
Cav=[CN CE CS CO];
end