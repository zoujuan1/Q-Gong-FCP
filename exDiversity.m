
function   [NewPopDec,endPopulation,FrontNo,CrowdDis]=exDiversity(midset,dis,Problem,k,offnums)
 count=0;
NewPopDec=zeros(Problem.N,Problem.D);
Alldec=[];


 for num=1:1
for i=1:k
    for j=1:offnums
        for l=1:Problem.D
         random=-1+2.*rand(1,1);
         count=(i-1)*offnums+j;   
            newdec= midset(i,l) +dis(i,l) .*random ;  

            if(newdec < 0)
                newdec = abs(newdec);
            end
         
         while( newdec <  Problem.lower(l) ||  newdec >  Problem.upper(l))
        if( newdec < Problem.lower(l) )
   
         newdec=newdec +(1+ rand)*(Problem.lower(l) - newdec );    
       
        elseif( newdec >Problem.upper(l) )
                   newdec=newdec + (1+rand)*(Problem.upper(l)- newdec);
 
        end

         end

        NewPopDec(count,l)=newdec;
        end
    end
end
 Alldec=[Alldec ; NewPopDec];
 end
 AllPopulation=Problem.Evaluation(Alldec);
Penalty=ModifyObj(Problem,AllPopulation);
 [Population,FrontNo,CrowdDis] = EnvironmentalSelectionByPenalty(AllPopulation,Problem.N,Penalty);
 endPopulation=Population;
end