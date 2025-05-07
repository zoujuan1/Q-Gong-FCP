function [Population] = NewReinitialization(Problem,Population,zeta)
% Re-initialize solutions
%zeta 
%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

    fea = floor(length(Population)*zeta/2)*2;
   [p1,FrontNo,CrowdDis] = EnvironmentalSelection(Population ,fea);
p2=setdiff(Population,p1);
if( length(p1)==100 )
    Population=p1;
else
p2 = OperatorGA(Problem,p2);
 Population=[p1,p2];
end
  Problem.FE=Problem.FE-length(p2);

end