function modifyF = ModifyObj(Problem,Population)
    PCon=Population.cons;
    infeasible=any(PCon>0,2);
    rf=sum(~infeasible)/(length(Population));


    PopObj=Population.objs;
    PopCon=Population.cons;
    Fmax  = max(PopObj,[],1);
    Fmin  = min(PopObj,[],1);

    Popnum=length(Population);
    normPopCon=zeros(Popnum,1);
    normPopObj=zeros(Popnum,Problem.M);
    Y=zeros(Popnum,Problem.M);
    dis=zeros(Popnum,Problem.M);
    pen=zeros(Popnum,Problem.M);
    modifyF=zeros(Popnum,Problem.M);

    lenCon=length(PopCon(1,:));
    for i=1:Popnum
        summ=0;
        for j=1:lenCon
            if(max(PopCon(:,j))>0)  
		summ=summ+max(PopCon(i,j),0)/max(PopCon(:,j));
            else
                summ=summ+0;
            end
        end
        normPopCon(i) = (1/lenCon) * summ;
    end

    for i=1:Problem.M
        infeasi=any(PopCon>0,2);
        Y(~infeasi,i)=0;
        Y(infeasi,i)=normPopObj(infeasi,i);
    end

    for i=1:Problem.M
        if(rf==0)
            dis(:,i)=normPopCon(:);
            xix=0;
        else
            if(Fmax(i)==Fmin(i))
                normPopObj(:,i)=ones(Popnum,1);
            else
                normPopObj(:,i)=(PopObj(:,i)-Fmin(i))./(Fmax(i)-Fmin(i));
            end
            dis(:,i)=sqrt(normPopObj(:,i).^2+normPopCon(:).^2);
            xix=normPopCon(:);
        end
        pen(:,i)=(1-rf)*xix+rf*Y(:,i);
         modifyF(:,i)=dis(:,i)+pen(:,i);
 
    end
    
end
