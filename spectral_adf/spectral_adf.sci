function max_value = col_max (A)
    max_value = zeros ( 1, size(A,2))
    for i = 1:length(max_value)
        max_value(i) = max(A(:,i))
    end
endfunction
function c = rectangle_lw (n, b)

    c = zeros (n, 1);
    t = floor (1 / b);
  
    c(1:t) = 1;
  
endfunction
function c = triangle_lw (n, b)

    c = 1 - (0 : n-1)' * b;
    c = [c' ; zeros(1, n)]
    c = col_max (c)'

endfunction
function sde = spectral_adf (c, win, b)
    nargin = argn (2)
    if (nargin < 1)
      error("invalid inputs");
    end
  
    cr = max(size (c) );
  
    if (size (c , 2) > 1)
      c = c';
    end
  
    if (nargin < 3)
      b = 1 / ceil (sqrt (cr));
    end
  
    if (nargin == 1 ||  )
      w = triangle_lw (cr, b);
    elseif (~ ischar (win))
      error ("spectral_adf: WIN must be a string");
    elseif (~strcmp (win , "rectangle" ) )
      w = rectangle_lw(cr , b) ;
    elseif (~strcmp (win , "triangle" ) ) 
        w = rectangle_lw(cr , b) ;
    else 
        error("Invalid window or this window is not supported yet")
    end
  
    c .*= w;
  
    sde = 2 * real (fft1 (c)) - c(1);
    sde = [(zeros (cr, 1)), sde];
    sde(:, 1) = (0 : cr-1)' / cr;
  
  endfunction