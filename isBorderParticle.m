%JanStart
function isBorder = isBorderParticle(xPos, yPos, zPos, zs, Nx, Ny, dx, dy, dz ,parameterIsBorder)

borderPixel = parameterIsBorder.borderPixel;
lminZ = parameterIsBorder.minZPos;
lmaxZ = parameterIsBorder.maxZPos;


isBorder = zeros(1,numel(xPos));
for cnt = 1:numel(xPos)
    if zPos(cnt) < zs(2) || ...
            zPos(cnt) > zs(end-1) || ...
            zPos(cnt) < lminZ || ...
            zPos(cnt) > lmaxZ;
        isBorder(cnt) = true;
    elseif xPos(cnt) < (borderPixel - Nx/2)*dx || ...
            yPos(cnt) < (borderPixel - Ny/2)*dy || ...
            xPos(cnt) > (Nx/2 - borderPixel)*dx || ...
            yPos(cnt) > (Ny/2 - borderPixel)*dy;
        isBorder(cnt) = true;
    end
end

%JanEnd