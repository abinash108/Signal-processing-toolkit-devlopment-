/*2024 
Author: Abinash Singh <abinashsinghlalotra@gmail.com>
*/
/*
Complex Shannon Wavelet
    Calling Sequence
    	[psi,x]=shanwavf(lb,ub,n,fb,fc)
    Parameters
    	lb: Real or complex valued vector or matrix
    	ub: Real or complex valued vector or matrix
    	n: Real valued integer strictly positive
    	fb: strictly positive scalar 
    	fc: strictly positive scalar 
    Description
    	This function implements the complex Shannon wavelet function and returns the value obtained. The complex Shannon wavelet is defined by a bandwidth parameter FB, a wavelet center frequency FC on an N point regular grid in the interval [LB,UB].
    Examples
    1.	[a,b]=shanwavf (2,8,3,1,6)
    	a =   [-3.8982e-17 + 1.1457e-31i   3.8982e-17 - 8.4040e-31i  -3.8982e-17 + 4.5829e-31i]
    	b =   [2   5   8]
*/
function [psi,x]=shanwavf(lb,ub,n,fb,fc)
    funcprot(0);
    rhs=argn(2);
    if (rhs~=5) then
        error ("Wrong number of input arguments.")
    else 
        if (n <= 0 || floor(n) ~= n)
            error("n must be an integer strictly positive");
        elseif (fc <= 0 || fb <= 0)
            error("fc and fb must be strictly positive");
        end
        x = linspace(lb,ub,n);
        sincx=x;
        for i=1:n
            sincx(i)=sin(fb*x(i)*%pi)/(fb*x(i)*%pi);
        end    
        psi = (fb.^0.5).*(sincx.*exp(2.*%i.*%pi.*fc.*x));
    end
endfunction

