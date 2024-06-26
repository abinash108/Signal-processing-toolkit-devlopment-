/*2024 
Author: Abinash Singh <abinashsinghlalotra@gmail.com>
*/
/*
Description:

        Compute the group delay of a filter.

        [g, w] = grpdelay(b) returns the group delay g of the FIR filter with coefficients b. The response is evaluated at 512 angular frequencies between 0 and pi. w is a vector containing the 512 frequencies. The group delay is in units of samples. It can be converted to seconds by multiplying by the sampling period (or dividing by the sampling rate fs).

        [g, w] = grpdelay(b,a) returns the group delay of the rational IIR filter whose numerator has coefficients b and denominator coefficients a.

        [g, w] = grpdelay(b,a,n) returns the group delay evaluated at n angular frequencies. For fastest computation n should factor into a small number of small primes.

        [g, w] = grpdelay(b,a,n,’whole’) evaluates the group delay at n frequencies between 0 and 2*pi.

        [g, f] = grpdelay(b,a,n,Fs) evaluates the group delay at n frequencies between 0 and Fs/2.

        [g, f] = grpdelay(b,a,n,’whole’,Fs) evaluates the group delay at n frequencies between 0 and Fs.

        [g, w] = grpdelay(b,a,w) evaluates the group delay at frequencies w (radians per sample).

        [g, f] = grpdelay(b,a,f,Fs) evaluates the group delay at frequencies f (in Hz).

        grpdelay(...) plots the group delay vs. frequency.

        If the denominator of the computation becomes too small, the group delay is set to zero. (The group delay approaches infinity when there are poles or zeros very close to the unit circle in the z plane.)

        Theory: group delay, g(w) = -d/dw [arg{H(e^jw)}], is the rate of change of phase with respect to frequency. It can be computed as:

                      d/dw H(e^-jw)
              g(w) = -------------
                        H(e^-jw)
        where

                H(z) = B(z)/A(z) = sum(b_k z^k)/sum(a_k z^k).
        By the quotient rule,

                          A(z) d/dw B(z) - B(z) d/dw A(z)
              d/dw H(z) = -------------------------------
                                      A(z) A(z)
        Substituting into the expression above yields:

                      A dB - B dA
              g(w) =  ----------- = dB/B - dA/A
                          A B
        Note that,

              d/dw B(e^-jw) = sum(k b_k e^-jwk)
              d/dw A(e^-jw) = sum(k a_k e^-jwk)
        which is just the FFT of the coefficients multiplied by a ramp.
*/
function [gd,w] = grpdelay (b, a, nfft, whole, Fs)
    lhs=argn(1);
    rhs= argn(2);
    if (rhs < 1 | rhs > 5) then
        error("Invalid number of inputs")
    end
    HzFlag= %F;
    
    select rhs
     case 1 then
         Fs=1; whole = "" ; nfft = 512 ; a = 1 ; 
     case 2 then
         Fs=1; whole = "" ; nfft = 512 ;  
     case 3 then
         Fs=1; whole = "" ;
     case 4 then
         Fs=1;
    end
   if (max(size(nfft)) > 1)
    if (rhs > 4)
      error("invalid inputs");
    elseif (rhs > 3)
      // grpdelay (B, A, F, Fs)
      Fs     = whole;
      HzFlag = %T;
    else
      // grpdelay (B, A, W)
      Fs = 1;
    end
    w     = 2*%pi*nfft/Fs;
    nfft  = max(size (w) ) * 2;
    whole = "";
  else
    if (rhs < 5)
      Fs = 1; // return w in radians per sample
      if (rhs < 4)
          whole = "" ;
      elseif (~type(whole)==10)
        Fs      = whole;
        HzFlag  = %T;
        whole   = "";
      end
      if (rhs < 3)
        nfft = 512;
      end
      if (rhs < 2)
        a = 1;
      end
    else
      HzFlag = %T;
    end

    if (isempty (nfft))
      nfft = 512;
    end
    if ( strcmp (whole, "whole"))
      nfft = 2*nfft;
    end
    
    w = Fs*[0:nfft-1]/nfft;
  end

  if (~ HzFlag)
    w = w * 2 * %pi;
  end
    a = a(:).';
    b = b(:).';
    oa = max(size(a)) -1;     // order of a(z)
    if (oa < 0)             // a can be []
      a  = 1;
      oa = 0;
    end
    ob = max(size(b)) -1;     // order of b(z)
    if (ob < 0)             // b can be [] as well
      b  = 1;
      ob = 0;
    end
    oc = oa + ob;           // order of c(z)
    c   = conv (b, flipdim(conj (a),2));  // c(z) = b(z)*conj(a)(1/z)*z^(-oa)
    cr  = c.*(0:oc);                    // cr(z) = derivative of c wrt 1/z
    num = fft1 (cr, nfft);
    den = fft1 (c, nfft);
    minmag    = 10*%eps;
    polebins  = find (abs (den) < minmag);
  for b = polebins
      warning ("signal:grpdelay-singularity", "grpdelay: setting group delay to 0 at singularity");
      num(b) = 0;
      den(b) = 1;
      //// try to preserve angle:
      //// db = den(b);
      //// den(b) = minmag*abs(num(b))*exp(j*atan2(imag(db),real(db)));
      //// warning(sprintf('grpdelay: den(b) changed from %f to %f',db,den(b)));
    end
    gd = real (num ./ den) - oa;
  
    if ( strcmp (whole, "whole"))
      ns = nfft/2; // Matlab convention ... should be nfft/2 + 1
      gd = gd(1:ns);
      w  = w(1:ns);
    else
      ns = nfft; // used in plot below
    end
  
    //// compatibility
    gd = gd(:);
    w  = w(:);
    if (lhs == 1)
      if (HzFlag)
        funits = "Hz";
      else
        funits = "radian/sample";
      end
      disp(" Plotting ")
      plot (w(1:ns), gd(1:ns));
      xlabel (["Frequency (" funits ")"]);
      ylabel ("Group delay (samples)");
    
  end
endfunction
