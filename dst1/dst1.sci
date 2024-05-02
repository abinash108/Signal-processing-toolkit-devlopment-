/*2024 
Author: Abinash Singh <abinashsinghlalotra@gmail.com>
*/
/*
    Computes the type I discrete sine transform of x
        Calling Sequence
            y= dst1(x)
            y= dst1(x,n)
        Parameters 
            x: real or complex valued vector
            n= Length to which x is trimmed before transform 
        Description
            Computes the type I discrete sine transform of x.If n is given,then x is padded or trimmed to length n before computing the transform. If x is a matrix,            compute the transform along the columns of the the matrix.
 */ 
function y = dst1(x, n)
    funcprot(0);
    lhs= argn(1);
    rhs= argn(2);
    if(rhs>2)
        error("Wrong number of input arguments");
    end
    transpose = (size(x,1) == 1);
    if transpose then
        x = x (:);
    end
    [nr, nc] = size (x);
    select(rhs)
    case 1 then
        break;
    case 2 then
        if n > nr
            x = [ x ; zeros(n-nr,nc) ];
        elseif n < nr
            x (nr-n+1 : n, :) = [];
        end
    end
    D=[ zeros(1,nc); x ; zeros(1,nc); -flipdim(x,1)]
    dimension = size(D);
    nsdim = 1;
    for i = 1:length(dimension)
        if dimension(i) ~= 1 then
            nsdim = i;
            break;
        end
    end
    y = fft (D,-1,nsdim)/2*%i;
    y = y(2:nr+1,:);
    if isreal(x) then
        y = real (y)
    end
    if transpose then
        y = y.'
    end
endfunction
    