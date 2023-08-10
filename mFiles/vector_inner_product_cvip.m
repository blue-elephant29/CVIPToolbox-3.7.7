function s =  vector_inner_product_cvip( vector1, vector2,n)
% VECTOR_INNER_PRODUCT_CVIP - calculates the normalized vector inner
% product similarity metric between two feature vectors.
% 
% Syntax :
% ------ 
% d =  vector_inner_product_cvip( vector1, vector2,n)
%   
% Input Parameters include :
% ------------------------
%   'vector1'   	Feature vector 1.
%                   A numeric array of n elements.
%   'vector2'       Feature vector 2.
%                   A numeric array of n elements.
%   'n'             size of the feature vectors
%                   positive integer.
%                 
%
%
% Output Parameter include :  
%  -----------------------
%   'd'             The normalized vector inner product similarity metric between vector1 and vector2
%                    
%
%
% Example :
% -------
%                   vector1 = [1 3 4 2];
%                   vector2 = [-3 3.2 sqrt(2) pi];
%                   n = 2;
%                   d =  vector_inner_product_cvip( vector1, vector2,n)
%                  
%
% Reference
% ---------
% 1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Mehrdad Alvandipour
%           Initial coding date:    3/13/2017
%           Latest update date:     3/19/2017
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2016 Scott Umbaugh and SIUE
%
%==========================================================================

    if size(vector1) ~= size(vector2)
        error('Size of the input vectors do not match');
    end
    vector1 = vector1(:);
    vector2 = vector2(:);

    
    s = sum(vector1.*vector2)/(norm(vector1,2)*norm(vector2,2));
end

