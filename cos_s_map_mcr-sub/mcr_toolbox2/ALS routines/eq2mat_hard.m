function [model, species_list, errstr] = eq2mat_hard(r);
% eq2mat_hard;
%
% function [model, species_list, errstr] = eq2mat_hard(r);
% ASSUMPTIONS:
%	- '+' and '>' are reserved symbols for model building
%	  Equilibria should be written as two separate equations with forward arrows.
%	- flexibility in species naming allowed ie. various length names possible, including numbers eg H2M
%	- 1 forward arrow per equation: no more, no less
%	- each equation must begin on a new line. ie be a separate string in r
%	- typing errors in component names will just generate too many components
% Author:  R. Dyson  Dec-1998

errstr = [];
nr = length(r);

% remove all spaces in reaction strings
for i=1:nr
   r(i) = strrep(r(i),' ','');
end

% error checking:
for i=1:nr,
   SingleReactionStr = char(r{i});
   extent = length(SingleReactionStr);
	% ensure all equations have a forward arrow, and only one
   locar = findstr(SingleReactionStr,'>');
   if length(locar) > 1,
      errstr = [errstr, sprintf('Reaction %1g: too many ''>''.\n',i)];
   elseif length(locar) == 0,
      errstr = [errstr, sprintf('Reaction %1g: missing ''>''.\n',i)];
   end
   if ismember(locar,1) | ismember(locar,extent),
      errstr = [errstr, sprintf('Reaction %1g: incorrect ''>'' placement.\n',i)];
   end
   % handle plus signs
   locpl = findstr(SingleReactionStr,'+');
   diffs=locpl(2:end)-locpl(1:end-1);
   if ismember(1,diffs) | ismember(locpl,1) | ismember(locpl,extent)
      errstr = [errstr, sprintf('Reaction %1g: incorrect ''+'' placement.\n',i)];
   end %if
   % handle both
   locarpl = union(findstr(SingleReactionStr,'+>'),findstr(SingleReactionStr,'>+'));
   if ~isempty(locarpl)
      errstr = [errstr, sprintf('Reaction %1g: incorrect ''+'', ''>'' combination.\n',i)];
   end %if
end %for i

try
   % set off error if error string not empty
   if ~isempty(errstr)
      error(errstr);
   end

	% for each reaction, locate equation symbols in string (non-species/dividers between species)
	plusx = {}; farrowx = {}; %rarrowx = {}; frarrowx = {};
	for i=1:nr	% for each reaction
		plusx{i} = findstr(r{i},'+');
		farrowx{i} = findstr(r{i},'>');
		allsymb{i} = union(farrowx{i},plusx{i});
	end

	% for each reaction, extract species from reaction scheme
	spc = {};
	for j=1:nr
	   rj = r{j}; allsymb_j = allsymb{j}; spcj = {};
	   % process first
		spcj{1}=rj(1:allsymb_j(1)-1);
		% process middle
		if length(allsymb_j) > 1
	      for i=2:length(allsymb_j)
				spcj{i} = rj( allsymb_j(i-1)+1 : allsymb_j(i)-1 );
			end
		else
			i=1;
		end
	   % process last
      spcj{i+1} = rj(allsymb_j(i)+1:end);
	   spc{j} = spcj(:); 	
	end %j

	% for each reaction, remove any empty species
	for j=1:nr
	   spcj = spc{j};
	   keepmask = [1:1:length(spcj)]';
		for i=1:length(spcj)
			if isempty(spcj{i})
				keepmask = find(keepmask ~= i);
			end
		end
	   spc{j} = spcj(keepmask,:);
	end

	% for each reaction, remove coefficients
   coeff = {};
   % for each reaction
	for k=1:nr
	   spc_k = spc{k};
      coeff_k = ones(length(spc_k),1);
      % for each species
		for i=1:length(spc_k)
         si = char(spc_k{i});
         ci = [];
		   finished = 0; j=0;
			while ~finished
            j=j+1;
		      if j<=length(si),
			      if ~isletter(si(j)),
						ci = [ci si(j)];
                  si = si(j+1:end);
                  % dec j since si red by 1
                  j=j-1;
               else
		            % after 1st letter seen, coeff. finished
                  finished = 1;
               end
		      else
		         % if no coefficient
					finished = 1;
		      end
         end
         if ~isempty(ci),
				spc_k{i} = si;
				coeff_k(i) = str2num(ci);
		   end % while
      end % i
      spc{k} = spc_k;
	   coeff{k} = coeff_k;
	end % k
   
   % how many unique species, total
	k = 0;
	for i=1:nr
	   spci = spc{i};
	   for j=1:length(spci)
	      k = k+1;
	      sp_all(k) = spci(j);
	   end
	end
	sp_all = sp_all(:);
	[uniq_sp,ix,xinall] = unique(sp_all);	% xinall = order of uniq_sp in sp_all
	ns = length(uniq_sp);

	% coefficients to create stoichiometric matrix
	% reactant coefficients -ve
	for i=1:nr
	   % number of reactants (species before arrow)
	   ns_r =  sum( plusx{i} < farrowx{i} ) + 1;
	   coeffi = coeff{i};
	   coeffi(1:ns_r) = coeffi(1:ns_r) * -1;
	   coeff{i} = coeffi;
	end
	% stoichiometric matrix
	N = zeros(nr,ns); R = zeros(nr,ns); P = zeros(nr,ns);
	k=0;
	for i=1:nr
	   spci = spc{i};
	   coeffi = coeff{i};
	   for j=1:length(spci)
	      k = k+1;
         N(i,xinall(k)) = N(i,xinall(k)) + coeffi(j);
         if coeffi(j) < 0
            % build R - reactant coefficient matrix
            R(i,xinall(k)) = R(i,xinall(k)) + coeffi(j);
         elseif coeffi(j) > 0
            % build P - product coefficient matrix
            P(i,xinall(k)) = P(i,xinall(k)) + coeffi(j);
         end
	   end
	end
	% unsort (order of appearance, not alphabetical)
	% find first-reference to each species
	pos = zeros(ns,1);
	for i=1:ns,
	   for j=length(sp_all):-1:1,
	      pos(i) = min( strmatch(uniq_sp(i),sp_all,'exact') );
	   end
   end
   sortedpos = sort(pos);
	% reorder species list and stoichiometric matrix
   newN = zeros(nr,max(pos)); 
   newR = zeros(nr,max(pos));
   newP = zeros(nr,max(pos));
	species_list = {};
	for i=1:ns,
	   species_list{pos(i)} = char(uniq_sp(i));
	   newN(:,pos(i)) = N(:,i);
	   newR(:,pos(i)) = R(:,i);
	   newP(:,pos(i)) = P(:,i);
	end
	species_list = species_list(sortedpos);
	species_list = species_list(:);
	N = newN(:,sortedpos);
	R = newR(:,sortedpos); R = R*-1;
	P = newP(:,sortedpos);
	model.N = N;
	model.R = R;
	model.P = P;
   
   % ensure no empty species exist
   for i=1:length(species_list)
      if isempty(species_list{i})
	      errstr = [errstr, sprintf('Component labels cannot be numeric.\n')];
      end %if
   end %for i
      
catch
  % INTELLIGENT ERROR-TRAPPING - WHAT TRANSLATION PROBLEM 
   model.N = []; model.P = []; model.R = []; species_list = {};
end %try

