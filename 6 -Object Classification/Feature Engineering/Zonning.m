function [Z]=Zonning_16(image)

[r,c]=size(image);

add_r =0; % number of adding lines
add_c=0; % number of adding columns 

if r<16
    add_r = 16-r;
end

if c<16
    add_c = 16-c;
end

if mod(add_r,2)==0 % if the number of adding lines is peer
    image=[zeros(add_r/2,c);image;zeros(add_r/2,c)];
else % if the number of adding lines is odd
    image=[zeros((add_r-1)/2,c);image;zeros((add_r+1)/2,c)];
end

r=size(image,1); % number of lines updating

if mod(add_c,2)==0
    image=[zeros(r,(add_c)/2),image,zeros(r,(add_c)/2)];
else
    image=[zeros(r,(add_c-1)/2),image,zeros(r,(add_c+1)/2)];
end

c=size(image,2); % columns number updating

n_rows=ceil(r/4)*4-r; % zeros lines to add to obtain 4*K number
n_columns=ceil(c/4)*4-c; % number of columns of zeros to be added to achieve a number of multiple of 4 columns

if mod(n_rows,2)==0
    image=[zeros(n_rows/2,c);image;zeros(n_rows/2,c)];
else
    image=[zeros((n_rows-1)/2,c);image;zeros((n_rows+1)/2,c)];
end

r=size(image,1); % lines number updating

if mod(n_columns,2)==0
    image=[zeros(r,(n_columns)/2),image,zeros(r,(n_columns)/2)];
else
    image=[zeros(r,(n_columns-1)/2),image,zeros(r,(n_columns+1)/2)];
end

% image

c=size(image,2);

zone_height=r/4;
zone_width=c/4;

%Z1j
zone_11=image(1:zone_height,1:zone_width);
z_11= nnz(zone_11)/(size(zone_11,1)*size(zone_11,2)); % compute a number of '1' in each zone

zone_12=image(1:zone_height,(zone_width+1):2*zone_width);
z_12=nnz(zone_12)/(size(zone_12,1)*size(zone_12,2));

zone_13=image(1:zone_height,(2*zone_width+1):3*zone_width);
z_13=nnz(zone_13)/(size(zone_13,1)*size(zone_13,2));

zone_14=image(1:zone_height,(3*zone_width+1):end);
z_14=nnz(zone_14)/(size(zone_14,1)*size(zone_14,2));

%Z2j
zone_21=image((zone_height+1):2*zone_height,1:zone_width);
z_21=nnz(zone_21)/(size(zone_21,1)*size(zone_21,2));

zone_22=image((zone_height+1):2*zone_height,(zone_width+1):2*zone_width);
z_22=nnz(zone_22)/(size(zone_22,1)*size(zone_22,2));

zone_23=image((zone_height+1):2*zone_height,(2*zone_width+1):3*zone_width);
z_23=nnz(zone_23)/(size(zone_23,1)*size(zone_23,2));

zone_24=image((zone_height+1):2*zone_height,(3*zone_width+1):end);
z_24=nnz(zone_24)/(size(zone_24,1)*size(zone_24,2));

%Z3j
zone_31=image((2*zone_height+1):3*zone_height,1:zone_width);
z_31=nnz(zone_31)/(size(zone_31,1)*size(zone_31,2));

zone_32=image((2*zone_height+1):3*zone_height,(zone_width+1):2*zone_width);
z_32=nnz(zone_32)/(size(zone_32,1)*size(zone_32,2));

zone_33=image((2*zone_height+1):3*zone_height,(2*zone_width+1):3*zone_width);
z_33=nnz(zone_33)/(size(zone_33,1)*size(zone_33,2));

zone_34=image((2*zone_height+1):3*zone_height,(3*zone_width+1):end);
z_34=nnz(zone_34)/(size(zone_34,1)*size(zone_34,2));

%Z4j
zone_41=image((3*zone_height+1):end,1:zone_width);
z_41=nnz(zone_41)/(size(zone_41,1)*size(zone_41,2));

zone_42=image((3*zone_height+1):end,(zone_width+1):2*zone_width);
z_42=nnz(zone_42)/(size(zone_42,1)*size(zone_42,2));

zone_43=image((3*zone_height+1):end,(2*zone_width+1):3*zone_width);
z_43=nnz(zone_43)/(size(zone_43,1)*size(zone_43,2));

zone_44=image((3*zone_height+1):end,(3*zone_width+1):end);
z_44=nnz(zone_44)/(size(zone_44,1)*size(zone_44,2));

Profil_Ver1 = nnz(zone_11) +nnz(zone_21) +nnz(zone_31)+nnz(zone_41);
Profil_Ver2 = nnz(zone_12)+nnz(zone_22)+nnz(zone_32)+nnz(zone_42);
Profil_Ver3 = nnz(zone_13)+nnz(zone_23)+nnz(zone_33)+nnz(zone_43);
Profil_Ver4 = nnz(zone_14)+nnz(zone_24)+nnz(zone_34)+nnz(zone_44);

Profil_Hor1=nnz(zone_11)+nnz(zone_12)+nnz(zone_13)+nnz(zone_14);
Profil_Hor2=nnz(zone_21)+nnz(zone_22)+nnz(zone_23)+nnz(zone_24);
Profil_Hor3=nnz(zone_31)+nnz(zone_32)+nnz(zone_33)+nnz(zone_34);
Profil_Hor4=nnz(zone_41)+nnz(zone_42)+nnz(zone_43)+nnz(zone_44);

Profil_Diag=nnz(zone_11)+nnz(zone_22)+nnz(zone_33)+nnz(zone_44);
Profil_Diag_Inv=nnz(zone_14)+nnz(zone_23)+nnz(zone_32)+nnz(zone_41);


Profil_Ver= [Profil_Ver1 Profil_Ver2  Profil_Ver3  Profil_Ver4];
Profil_Hor=[Profil_Hor1  Profil_Hor2  Profil_Hor3  Profil_Hor4];


Z=[z_11  z_12  z_13  z_14       z_21  z_22  z_23  z_24      z_31  z_32  z_33  z_34      z_41  z_42  z_43  z_44  Profil_Ver  Profil_Hor  Profil_Diag  Profil_Diag_Inv ];

end

