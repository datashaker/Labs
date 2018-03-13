% Arff files generation
% As we use AIRS weka classifier, we have to construct the arff files 
function ArffFilesGeneration
clc;
clear all
tic
FV1=[]; FV2=[]; FV3=[]; FV4=[]; FV5=[]; FV6=[]; FV7=[];
pathname1 = 'LocalisedDataSet\';
pathname2 = 'SquelDataSet\';
directories1= dir(pathname1);
directories2 = dir(pathname2);
for i=3:length(directories1)
    path_im1=strcat(pathname1,directories1(i).name);      
    im1=imread(path_im1) ;                    
    path_im2=strcat(pathname2,directories2(i).name);
    im2=imread(path_im2) ;
    C1=Chaincode(im1); % Freeman Chain Code 
    C2=Concavity(im1); % Concavity detection
    C7=Loop_detection_Final(im1); % Closed loop detection 
    FV1=[FV1 ; C1 ];
    FV2=[FV2 ; C2 ];
    FV7=[FV7 ; C7 ];
    C3=Zonning_16(im2); % 16*16 Zonning features
    C4= ConnexeComponentsNumber(im2); % Number of Connex components
    C5=NumberOfTransitions(im2); % Number of 0-1 and 1-0 transitions
    C6=Area_Perimeter_Ratio(im2); % Area/Perimeter
    FV3=[FV3 ; C3 ];
    FV4=[FV4 ; C4 ];
    FV5=[FV5 ; C5 ];
    FV6=[FV6 ; C6 ];
   display (i / length(directories1)*100);
   
end % end for

VC=[1 2 3 4 5 6 7]; % 7 categories of features
q=1;
for p=2:7
V=combnk (VC,p);   % All combinations
for j=1:size(V)
    pass=0; 
    FV=[];
    % arff file construction 
    path=strcat('ArffFile',num2str(q),'.txt');
    fid = fopen(path, 'w+');
    fprintf(fid, '\n');  
       
    fprintf(fid,'@RELATION Arabicharacters');
    fprintf(fid, '\n\n');  
    
    Vj=V(j,:);
    
    for k=1:size(Vj,2)
        
        switch Vj(k)
           case 1      % Freeman Chain Code   1
                FV=[FV  FV1];
                for i=pass+1:pass+8
                    fprintf(fid,'@ATTRIBUTE C');
                    fprintf(fid,num2str(i));
                    fprintf(fid,' INTEGER');
                    fprintf(fid, '\n');                 
                end
                pass=i;
                fprintf(fid, '\n');  
            
            case 2        % Concavities   
                FV=[FV  FV2];
                for i=pass+1:pass+4
                    fprintf(fid,'@ATTRIBUTE C');
                    fprintf(fid,num2str(i));
                    fprintf(fid,' INTEGER');
                    fprintf(fid, '\n');                
                end
                pass=i;
                fprintf(fid, '\n');   
                
            case 3    % Zonning    
                FV=[FV  FV3];
                for i=pass+1:pass+16
                    fprintf(fid,'@ATTRIBUTE C');
                    fprintf(fid,num2str(i));
                    fprintf(fid,' REAL');
                    fprintf(fid, '\n');                 
                end
                pass=i;
                for i=pass+1:pass+10
                    fprintf(fid,'@ATTRIBUTE C');
                    fprintf(fid,num2str(i));
                    fprintf(fid,' INTEGER');
                    fprintf(fid, '\n');                             
                end
                pass=i;
                fprintf(fid, '\n');
            
            case 4    % Number of Connex Components
                FV=[FV  FV4];
                fprintf(fid,'@ATTRIBUTE C');
                fprintf(fid,num2str(pass+1));
                fprintf(fid,' INTEGER');
                fprintf(fid, '\n\n');  
                pass=pass+1;
            
            case 5      % Number of Transitions
                FV=[FV  FV5];
                for i=pass+1:pass+2
                    fprintf(fid,'@ATTRIBUTE C');
                    fprintf(fid,num2str(i));
                    fprintf(fid,' INTEGER');
                    fprintf(fid, '\n');                
                end
                fprintf(fid, '\n');
                pass=i;
            
            case 6        % Area/Peremeter
                FV=[FV  FV6];
                fprintf(fid,'@ATTRIBUTE C');
                fprintf(fid,num2str(pass+1));
                fprintf(fid,' REAL');
                fprintf(fid, '\n\n');  
                pass=pass+1;
            
            case 7       % Closed Loop
                FV=[FV  FV7];
                fprintf(fid,'@ATTRIBUTE C');
                fprintf(fid,num2str(pass+1));
                fprintf(fid,' INTEGER');
                fprintf(fid, '\n\n');  
                pass=pass+1;      
        end
    end
       
    fprintf(fid,'@ATTRIBUTE class {AiinI,AlifI,BaaI,CaafI,DadI,DalI,DhelI,DhaI,FaaI,GhiinI,HaaI,HaI,JiimI,KhaaI,KafI,LamI,MiimI,NounI,RaaI,SadI,ShiinI,SiinI,TaaI,ThaaI,ThaI,WawI,YaaI,ZadI}');
    fprintf(fid, '\n\n');  
    fprintf(fid,'@DATA');
    fprintf(fid, '\n');
    
    for j=1:size(FV)
        fprintf(fid, '%d,', FV(j,:));    
        [~,f]=fileparts(directories1(j+2).name);
        k= 1;
        categorie='';
        while isletter(f(k))
            categorie = strcat (categorie,f(k));
            k=k+1;
        end
        fprintf(fid, '%s',categorie );
        fprintf(fid, '\n');    
        display (j/ length(directories1)*100);
    end
    fclose(fid);
     q=q+1;   % to next file
end
end
toc;
end