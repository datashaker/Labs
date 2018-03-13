function fd = Loop_detection_Final( im )
 

clearborderim= imclearborder(~im);

nb=size(find (clearborderim),1);

if nb~=0
   fd=true;
    
else
    fd=false;
    
end

end

