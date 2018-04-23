% invfit - inversion of the objective (fitness) function
%
%	Description:
%	The function calculates the complement function to the objective function
%	as follows:
%
%	Newobj=(max(Oldobj)-Oldobj)+min(Oldobj)
%
%	In this way it is possible to convert a maximization problem to a minimization
%	one for the need of the GA-toolbox.
%
%
%	Syntax:
%
%	Newobj=invfit(Oldobj)
%
%	Newobj - vector of the complementary objective function
%	Oldobj - vector of the old objective function
%

% I.Sekaj, 5/2000

function[Newfv]=invfit(Oldfv)

Newfv=(max(Oldfv)-Oldfv)+min(Oldfv);

