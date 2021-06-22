function [X] = gui_conc(t,Co,k_vals,rxn_path,rxn_order);
% [X] = gui_conc(t,Co,k_vals,rxn_path,rxn_order);
% use reaction order and pathway matrices to fit conc curves
% R. Dyson 1998

ct = Co';
X = rxn_path * (k_vals' .* prod( ct(ones(size(k_vals)),:) .^ rxn_order , 2 ));
