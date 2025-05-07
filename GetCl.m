function Close=GetCl(DirectVec, NewDirectVec,k,Problem)
Edis=zeros(length(DirectVec),1);
dis=NewDirectVec-DirectVec;
Edis=sum(dis.*dis,2);

[minE,Close]=mink(Edis,k);
end