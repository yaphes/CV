function [output] = tempo_filter(varargin)

%Filter the image sequence in temporal sequence

[input,type,p1,p2] = ParseInputs(varargin{:});

output = zeros(size(input));
input = double(input);

switch type
    case 'diff'  %simple differential filter       
        filter = 0.5*[-1,0,1];
        if (numel(p2) ~= 0)
            p = p2;
            output = filter(1) * input(:,:,p-1) + filter(2) * ...
                            input(:,:,p) + filter(3) * input(:,:,p+1);
        else
            n = size(input,3);
            for p = 2:(n-1)
                output(:,:,p) = filter(1) * input(:,:,p-1) + filter(2) * ...
                                input(:,:,p) + filter(3) * input(:,:,p+1);
            end
            %padding the border
            output(:,:,1) = output(:,:,2);
            output(:,:,n) = output(:,:,n-1);
        end
        
    case 'gaussian'   %1d derivative gaussian filter
        sig = p1;
        n = size(input,3);
        x = round(5*sig);
        h = conv2(fspecial('gaussian',[1 x],p1),[1 0 -1]);
        sumh = sum(abs(h(:)));
        if sumh ~= 0
            h = h/sumh;
        end
        filter = h;
        len = size(filter,2);
        len = (len - 1) / 2;
        if (numel(p2) ~= 0)
            p = p2;
            output = output(:,:,1);
            for q = p-len : p+len
                output = output + input(:,:,q)*filter(q-p+len+1);
            end
        else
            for p = 1+len : n-len
                for q = p-len : p+len
                    output(:,:,p) = output(:,:,p) + input(:,:,q)*filter(q-p+len+1);
                end
            end
        end
        
        %padding the border
        %output(:,:,1:len) = output(:,:,len+1);
        %output(:,:,n-len+1:n) = output(:,:,n-len);    
end

end

%ParseInputs%
function [input,type,p1,p2] = ParseInputs(varargin)
% default values
p1        = [];
p2        = [];

% Check the number of input arguments.
narginchk(2,4);

% Parse the input image sequence
input = varargin{1};

% Determine filter type from the user supplied string.
type = varargin{2};
type = validatestring(type,{'gaussian','diff'},mfilename,'TYPE',2);

switch type
    case 'gaussian' 
        p1 = 0.5;
end

switch nargin
    case 2
        % TEMPO_FILTER(input,'diff')
        % TEMPO_FILTER(input,'gaussian')
        % Default value
    case 3
        % TEMPO_FILTER(input,'gaussian',sigma)
        % TEMPO_FILTER(input,'diff',p2)
        switch type
            case 'gaussian'
                p1 = varargin{3};
            case 'diff'
                p2 = varargin{3};
        end
    case 4
        % TEMPO_FILTER(input,'gaussian',sigma,p2)
        p1 = varargin{3};
        p2 = varargin{4};
end
end