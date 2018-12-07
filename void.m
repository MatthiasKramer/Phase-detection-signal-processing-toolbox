function [C] = void(Signal)
% Thanks god we submoduled this function...
C=sum(Signal<0.5)/length(Signal); 
end
