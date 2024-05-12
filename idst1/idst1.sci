/*2024 
Author: Abinash Singh <abinashsinghlalotra@gmail.com>
*/
/*
This function computes the inverse type I discrete sine transform.
    Calling Sequence
        Y = idst1(X)
        Y = idst1(X, N)
    Parameters
        X: Matrix or integer
        N: If N is given, then X is padded or trimmed to length N before computing the transform.
    Description
        This function computes the inverse type I discrete sine transform of X If N is given, 
        then X is padded or trimmed to length N before computing the transform.
        If X is a matrix, compute the transform along the columns of the the matrix.
    Examples
        idst1([1,3,6])
    ans = 
         3.97487  -2.50000   0.97487 
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
function y = idst1(x,n)

funcprot(0);
rhs=argn(2);
if(rhs<1 | rhs>2) then
    error("Wrong number of input arguments.");
end
select(rhs)
case 1 then
    n=size(x,1);
case 2 then
    if n==1 then
        n=size(x,2)
    end
    
end
    y = dst1(x, n) * 2/(n+1);
endfunction
