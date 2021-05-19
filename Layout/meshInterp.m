function z0 = meshInterp(x,y,z,x0,y0) 
%Given meshes x,y, and values z, the function returns the value z0 associated to
%point (x0,y) by interpolation.

    %treat data
    x_max = x(1,end);
    x_min = x(1,1);
    Nx = length(x(1,:));
    y_max = y(end,1);
    y_min = y(1,1);
    Ny = length(y(:,1));

    %check boundary
    if x0 < x_min
        x0 = x_min;
    elseif x0>x_max
        x0 = x_max; 
    end

    if y0 < y_min
        y0 = y_min;
    elseif y0>y_max
        y0 = y_max; 
    end


    %determine x factor
    xFactor = (Nx-1)*(x0 - x_min) / (x_max - x_min) + 1;
    xIndex = floor(xFactor);
    xWeight = xFactor - xIndex;

    %determine y factor
    yFactor = (Ny - 1)*( y0 - y_min ) / (y_max - y_min) + 1;
    yIndex = floor(yFactor);
    yWeight = yFactor - yIndex;

    %eval charge with the lowest x and lowest y
    shiftLowX = z(:,xIndex);
    shift = shiftLowX(yIndex);

    if yWeight ~= 0
        %add contribution of yweight on the lowest x configuration
        shift = shift + yWeight*( shiftLowX(yIndex+1) - shift);
    end

    if xWeight ~= 0
        shiftHighX = z(:,xIndex+1);
        shiftH = shiftHighX(yIndex);

        if yWeight ~= 0
            shiftH = shiftH + yWeight*( shiftHighX(yIndex+1) - shiftH);
        end

        shift = shift + xWeight*(shiftH - shift);    
    end

    %return value
    z0 = shift;
end