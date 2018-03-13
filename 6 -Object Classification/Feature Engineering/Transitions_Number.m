function  TN=NumberOfTransitions(im)

HT=[]; % Horizontal Trasintions
VT=[]; % Vertical Trasintions

for i=1:size(im,1)
% % Measure lengths of stretches of 1's.

 measurementsH = regionprops(logical(im(i,:)), 'Area');
 
% % Convert from structure to simple array of lengths.
 allLengthsH =[measurementsH.Area];
 
%Horizontal Transitions Number HTN 
if isequal(im(i,1),im(i,end),0)
     HTN=2*(numel(allLengthsH));
else
    if isequal(im(i,1),im(i,end),1)
        HTN=2*(numel(allLengthsH))-2;
    else
           HTN=2*(numel(allLengthsH))-1;
    end
end

HT= [HT HTN];
end


for i=1:size(im,2)

% % Measure lengths of stretches of 1's.
 measurementsV = regionprops(logical(im(:,i)), 'Area');

% % Convert from structure to simple array of lengths.
 allLengthsV =[measurementsV.Area];
 %Vertical Transitions Number VTN 

if isequal(im(1,i),im(end,i),0)
     VTN=2*(numel(allLengthsV));
else
    if isequal(im(1,i),im(end,i),1)
        VTN=2*(numel(allLengthsV))-2;
    else
           VTN=2*(numel(allLengthsV))-1;
    end
end

VT= [VT VTN];
end

TN=[max(HT) max(VT)];
end

