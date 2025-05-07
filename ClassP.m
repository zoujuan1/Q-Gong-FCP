
function [idx,dec_centers,close]=ClassP(Problem,Population,k)

 Penalty=ModifyObj(Problem,Population);
 data_points=Penalty;

[idx, obj_centers] = kmeans(data_points, k);



dec_centers=zeros(k,Problem.D);
for i=1:k
    i_list=(idx==i);
    PonDec=Population(i_list==1).decs;
    [m,n]=size(PonDec);
    dec_centers(i,:)=sum( PonDec ,1) ./ m;
end

x =(1:k)';
y=randperm(k)';
close = [x, y];  

end