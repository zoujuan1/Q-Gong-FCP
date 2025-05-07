classdef FCP< ALGORITHM
    % <multi> <real/integer/label/binary/permutation> <constrained/none> <dynamic>
    % Dynamic  constrained NSGA-II
    % type -1. Mutation based reinitialization 2. Random reinitialization
    % zeta - Ratio of reinitialized solutions

    %------------------------------- Reference --------------------------------
    % K. Deb, U. Bhaskara Rao N., and S. Karthik, Dynamic multi-objective
    % optimization and decision-making using modified NSGA-II: A case study on
    % hydro-thermal power scheduling, Proceedings of the International
    % Conference on Evolutionary Multi-Criterion Optimization, 2007, 803-817.
    %------------------------------- Copyright --------------------------------
    % Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
    % research purposes. All publications which use this platform or any code
    % in the platform should acknowledge the use of "PlatEMO" and reference "Ye
    % Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
    % for evolutionary multi-objective optimization [educational forum], IEEE
    % Computational Intelligence Magazine, 2017, 12(4): 73-87".
    %--------------------------------------------------------------------------


    methods
        function main(Algorithm,Problem)

            Population = Problem.Initialization();
     
            AllPop = [];
            A=[];
           TA=[];
            
            t=0;
            Pt1=Population; 
            Pt2=Population;  
            PT=[Pt1;Pt2];
            gen_count=0;
            flag=0;
            %% Optimization
            while Algorithm.NotTerminated(A)

                if(gen_count<=80)
                    
              Penalty=ModifyObj(Problem,Population);
            [Population,FrontNo,CrowdDis] = EnvironmentalSelectionByPenalty(Population,Problem.N,Penalty);

                    MatingPool = TournamentSelection(2,Problem.N,FrontNo,-CrowdDis);
                    Offspring  = OperatorGA(Problem,Population(MatingPool));
         
                    Penalty=ModifyObj(Problem,[Population Offspring]);
                    [Population,FrontNo,CrowdDis] = EnvironmentalSelectionByPenalty([Population Offspring],Problem.N,Penalty);
                    gen_count=gen_count+1;
                    Problem.FE=200;
                else
                    flag=1;
                end


                if(flag==1)

                       if Algorithm.Change(Problem)
                        t=t+1;
                        AllPop=[AllPop,A];
                        
                        PT(1,:)=PT(2,:);
                        PT(2,:)=Population;

                        if(t<2)
                        Decs=Population.decs;
                         OldP  =Problem.Evaluation(Decs);

                        Infeasible=any(OldP.cons>0,2);
                        FS=OldP(~Infeasible);
                        FSnum=sum(~Infeasible);
                        rp=FSnum/Problem.N;

                        Population= NewReinitialization(Problem,OldP,rp);
                        Population_mute=[OldP,Population];
                        Penalty2=ModifyObj(Problem,Population_mute);
                        [Population,FrontNo,CrowdDis]=EnvironmentalSelectionByPenalty(Population_mute,Problem.N,Penalty2);
                   
                        else
                         
                            
                            Ct1= mean(PT(1,:).decs);
                            Ct2= mean(PT(2,:).decs);
                            derta=Ct2-Ct1;
  
                        
                            k=10;
                            [idx,dec_centers,close]=ClassP(Problem,Population,k);
                           
                           dis=ClassDis2(k,dec_centers,close,Problem);
                           midset=dec_centers+derta;
                        
                             [~,Population,FrontNo,CrowdDis]=exDiversity(midset,dis,Problem,k,Problem.N / k);
 
                      end
                    end

                 MatingPool = TournamentSelection(2,Problem.N,FrontNo,-CrowdDis);
                 Offspring  = OperatorGA(Problem,Population(MatingPool)); 

             Penalty=ModifyObj(Problem,[Population Offspring]);
      [Population,FrontNo,CrowdDis] = EnvironmentalSelectionByPenalty([Population Offspring],Problem.N,Penalty);

                  TA=Population;
                    Infeasible=any(Population.cons>0,2);
                    A=Population(~Infeasible);
                    if Problem.FE >= Problem.maxFE
  
                        A = [AllPop,A];
                        [~,rank]   = sort(A.adds(zeros(length(A),1)));
                        A = A(rank);

                    end
                end 
            end
        end
    end
end
