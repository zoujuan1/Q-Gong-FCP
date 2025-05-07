function  dis=ClassDis2(k,dec_centers,close,Problem)
dis=zeros(k,Problem.D);

for i=1:k
    a=i;
    b=close(a,2);
  dis(i,:)=getdis(a,b,dec_centers);
end
end

function dis1=getdis(a,b,dec_centers)
  dis1=abs( dec_centers(a,:)-dec_centers(b,:) );
end