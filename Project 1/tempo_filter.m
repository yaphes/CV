function [output] = tempo_filter(varargin)

%Filter the image sequence in temporal sequence

[input,type,p3] = ParseInputs(varargin{:});

output = zeros(size(input));
input = double(input);

switch type
    case 'diff'  %simple differential filter
        filter = 0.5*[-1,0,1];
        n = size(input,3);
        for p = 2:(n-1)
            output(:,:,p) = filter(1) * input(:,:,p-1) + filter(2) * ...
                            input(:,:,p) + filter(3) * input(:,:,p+1);
        end
        
        %padding the border
        output(:,:,1) = output(:,:,2);
        output(:,:,n) = output(:,:,n-1);
        
    case 'gaussian'   %1d derivative gaussian filter
        sig = p3;
        n = size(input,3);
        x = [-round(5*sig):round(5*sig)];
        arg = -(x.*x)/(2*sig*sig);
        h = -(x/(sig*sig)).*exp(arg);
        sumh = sum(abs(h(:)));
        if sumh ~= 0
            h = h/sumh;
        end
        filter = h;
        len = size(filter,2);
        len = (len - 1) / 2;
        for p = 1+len : n-len
            for q = p-len : p+len
                output(:,:,p) = output(:,:,p) + input(:,:,q)*filter(q-p+len+1);
            end
        end
        
        %padding the border
        %output(:,:,1:len) = output(:,:,len+1);
        %output(:,:,n-len+1:n) = output(:,:,n-len);    
end

end

%ParseInputs%
function [input,type,p3] = ParseInputs(varargin)
% default values
p3        = [];

% Check the number of input arguments.
narginchk(2,3);

% Parse the input image sequence
input = varargin{1};

% Determine filter type from the user supplied string.
type = varargin{2};
type = validatestring(type,{'gaussian','diff'},mfilename,'TYPE',2);

switch type
    case 'gaussian' 
        p3 = 0.5;
end

switch nargin
    case 2
        % TEMPO_FILTER(input,'diff')
        % TEMPO_FILTER(input,'gaussian')
    case 3
        % TEMPO_FILTER(input,'gaussian',sigma)
end
end