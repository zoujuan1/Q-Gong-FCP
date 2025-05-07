function mid=GetMid(Population,Problem)
PonDec=Population.decs;
mid=zeros(1,Problem.D);
for i=1:Problem.D
mid(i)=sum( PonDec(:,1) )/length(Population);
end
end