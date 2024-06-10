
//
//Calling Sequence
//c = xcorr2 (a)
//c = xcorr2 (a, b)
//c = xcorr2 (a, b, biasflag)
//Parameters 
//a:
//b:
//biasflag:
//Description

//Examples
//xcorr2(5,0.8,'coeff')
//ans =  1

function c = xcorr2 (a, b, biasflag )
  funcprot(0);
  nargin=argn(2);
  if (nargin < 1 || nargin > 3)
    error("Wrong number of inputs")
  elseif (nargin == 2 && ischar (b))
    biasflag = b;
    b        = a;
  elseif (nargin == 1)
    // we have to set this case here instead of the function line, because if
    // someone calls the function with zero argument, since a is never set, we
    // will fail with "`a' undefined" error rather that print_usage
    b = a;
  end
  if (ndims (a) ~= 2 || ndims (b) ~= 2)
    error ("xcorr2: input matrices must must have only 2 dimensions");
  end

  // compute correlation
  [ma,na] = size(a);
  [mb,nb] = size(b);
  c = conv2 (a, conj (b (mb:-1:1, nb:-1:1)));

  // bias routines by Dave Cogdell (cogdelld@asme.org)
  // optimized by Paul Kienzle (pkienzle@users.sf.net)
  // coeff routine by Carnë Draug (carandraug+dev@gmail.com)
  switch lower (biasflag)
    case {"none"}
      // do nothing, it's all done
    case {"biased"}
      c = c / ( min ([ma, mb]) * min ([na, nb]) );
    case {"unbiased"}
      lo   = min ([na,nb]);
      hi   = max ([na, nb]);
      row  = [ 1:(lo-1), lo*ones(1,hi-lo+1), (lo-1):-1:1 ];

      lo   = min ([ma,mb]);
      hi   = max ([ma, mb]);
      col  = [ 1:(lo-1), lo*ones(1,hi-lo+1), (lo-1):-1:1 ]';

      bias = col*row;
      c    = c./bias;

    case {"coeff"}
      a = double (a);
      b = double (b);
      a = conv2 (a.^2, ones (size (b)));
      b = sum(b(:).* conj(b(:)));
      c(:,:) = c(:,:) ./ sqrt (a(:,:) * b);

    otherwise
      error ("xcorr2: invalid type of scale %s", biasflag);
  end

endfunction