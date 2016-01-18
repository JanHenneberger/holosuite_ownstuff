% Class intended to find, classify and characterize a particle in a 3-d
% voxel group.

%    Copyright (C) 2013 Matt Beals and Jacob Fugal and Oliver Schlenczek
%    and Jan Henneberger
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%    When using this program as part of research that results in
%    publication, acknowledgement is appreciated. The following citation is
%    appropriate to include:
%
%    Fugal, J. P., T. J. Schulz, and R. A. Shaw, 2009: Practical methods
%    for automated reconstruction and characterization of particles in
%    digital inline holograms, Meas. Sci. Technol., 20, 075501,
%    doi:10.1088/0957-0233/20/7/075501.
%
%    Funding for development of holoViewer at Michigan Tech (Houghton,
%    Michigan, USA) provided by the US National Science Foundation (US-NSF)
%    Graduate Research Fellowship Program, and NASA's Earth Science
%    Fellowship Program. Funding for development at the National Center for
%    Atmospheric Research (NCAR, Boulder, Colorado, USA) provided by the
%    US-NSF. Funding for development at the Max Planck Institute for
%    Chemistry (MPI-Chemistry, Mainz, Germany) and the Johannes Gutenberg
%    University of Mainz (Uni-Mainz, Mainz, Germany), provided by
%    MPI-Chemistry, the US-NSF, and the Deutsche Forschungsgesellschaft
%    (DFG, the German Science Foundation).
%
%    Please address questions or bug reports to Jacob Fugal at
%    fugalscientific (at) gmail (dot) com
classdef particleForRtStats < handle
   
   %Pixel Coordinates (Cor) and pixel positions (Pos) are prefixed with l
   %and g to represent local and global reference frames.
   
   % Last bugfix: 2012/05/15 by Oliver Schlenczek
   % Now phase thresholds are considered as well as amplitude thresholds
   % The threshOp OR is no more useless
   % Change was made by introducing the method validVoxels
   
   properties
      gNx;           % the size of the reconstructed space
      gNy;
      dx; dy; dz;    % The voxel dimensions
      
      ampHighThresh;  % The thresholds that defined this particle before it was dilated
      ampLowThresh;
      phaseHighThresh;
      phaseLowThresh;
      minZSlices;
      maxZSlices;
      
      centerHW = 3;    % The width of the center of the particle
      
      config_handle;   % handle back to the config object used to reconstruct this hologram
      
      idx;
      vals;                 %original list of pixel idxs and values
   end
   
   properties
      blockMaps;      % Definition of custom 'block' functions
      traceMaps;      % Description of the traces for this particle
      valueMaps;      % Description of the search for peaks in these traces
      
      
      % How to select peaks in the traces
      pkpct = 90;     % Above which percentile to consider peaks
      minPkD = 1;     % How close can peaks be to each other
      maxNPks = 1;     % How many peaks are allowed to be returned
      
      zPosSelFcn;     % How should the object decide the z Position from the peaks (values) in the traces
      zPosValues;
   end
   
   properties %(SetAccess = private, GetAccess = private)
      traceCache;
      valueCache;
   end
   
   properties
      isCylinder = false;
      minZPos    = 0;
      maxZPos    = inf;
      minXPos    = -inf;
      maxXPos    = inf;
      minYPos    = -inf;
      maxYPos    = inf;
      xCenter    = 0;
      yCenter    = 0;
      maxXrad    = inf;
      maxYrad    = inf;
   end
   
   properties(SetAccess = private)
      xlCor; ylCor; zlCor;  %Voxel coordinates relative to the local particle space
      offset;               %offsets to convert back to global
      zLInd  = [];         % The local z index where we think we're in focus
      
      allZ;                %hologram relative z position (m);
      
      blocks = struct('pBlock',[], ...   % the rebuilt particle block with idxs and vals, and nans otherwise
         'ampBlock', [], ...% the same but the abs thereof
         'phBlock', []);    % the same but the phase thereof corrected for distance from the hologram.
      
   end
   
   properties(Dependent)
      gNz;                  %global number of z slices
      
      lNx; lNy; lNz;        %local pixel widths
      
      xgCor; ygCor; zgCor;  % voxel coordinates for all voxels in the whole reconstructed space
      xlPos; ylPos; zlPos;  % voxel coordinates for all voxels in local partical space
      xgPos; ygPos; zgPos;  %                 in the whole reconstructed space
      xlgrid; ylgrid; zlgrid; % voxel coordinates across the particle block in local space
      xggrid; yggrid; zggrid; %               in the whole reconstructed space
   end
   
   methods
      function this = particle(idx,vals, gNx, gNy, zs)
         this.idx    = idx;
         this.vals   = vals;
         this.gNx    = gNx;
         this.gNy    = gNy;
         this.allZ   = zs;
         this.updateCoords;
      end
   end
   
   methods (Static)
      % Return the absolute value of pBlock
      function outBlock = absBlock(pBlock)
         outBlock = abs(pBlock);
      end
      % Return the phase of pBlock corrected for phase delays as a
      % function of distance from the hologram
      function outBlock = angleBlock(pBlock)
         outBlock = angle(pBlock);
      end
      
      function block = getWhole(pBlock)
         block = pBlock;
      end
      
      function block = getSobel(pBlock)
         block = 10*fastAbsSobelGrad(pBlock);
      end
   end
   
   methods
      % Returns the complex value block (builds this.blocks.pBlock);
      function block = complexBlock(this)
         block = complex(nan([this.lNy, this.lNx, this.lNz]));
         idxs = sub2ind([this.lNy, this.lNx, this.lNz], this.ylCor, this.xlCor,this.zlCor);
         block(idxs) = this.vals;
      end
      
      % Consider both phase and amplitude information for all future
      % calculations. Added on May 15, 2012
      % Returns the valid voxels (logical array)
      function temp = validVoxels(this, zInds)
         if ~exist('zInds','var') || isempty(zInds)
            zInds = 1:this.lNz;
         end
         temp = img.thresholdImage( this.blocks.pBlock, this.ampLowThresh, this.ampHighThresh, ...
            this.phaseLowThresh, this.phaseHighThresh, this.config_handle.threshOp, ...
            zInds);
         %             zInds = zInds(zInds >= 1 & zInds <= this.lNz);
         %             temp1 = this.blocks.ampBlock(:,:,zInds) <= this.ampLowThresh | this.blocks.ampBlock(:,:,zInds) >= this.ampHighThresh;
         %             temp2 = this.blocks.phBlock(:,:,zInds) <= this.phaseLowThresh | this.blocks.phBlock(:,:,zInds) >= this.phaseHighThresh;
         %             temp = this.config_handle.threshOp(temp1,temp2);
      end
      
      % Returns the center portion of pBlock centered on the particle
      % as determined by the amplitude thresholds
      function block = getCenter(this, pBlock)
         % Applies the amplitude thresholds
         temp = sum(this.validVoxels,3);
         % find the center x and y values based on all the
         % thresholded voxels
         tempX    = round(sum(sum(temp,1).*double(1:this.lNx))/sum(temp(:)));
         tempIndX = (-this.centerHW:this.centerHW)+tempX;
         tempIndX = find(tempIndX >= 1 & tempIndX <= this.lNx)+tempX-this.centerHW-1;
         
         tempY    = round(sum(sum(temp,2).*double(1:this.lNy)')/sum(temp(:)));
         tempIndY = (-this.centerHW:this.centerHW)+tempY;
         tempIndY = find(tempIndY >= 1 & tempIndY <= this.lNy)+tempY-this.centerHW-1;
         
         block = pBlock(tempIndY,tempIndX,:);
      end
   end
   
   methods % Tell if the particle object is a valid particle. It is if
      % the particle has a z length lower than zLowTh or higher than
      % zHighTh, and so on for phase and amplitude. If the parameters are
      % the empty array or are not defined, then valid Particle skips
      % that condition.
      function isEligible = isValidParticle(this,varargin)
         
         %minZSlices, maxZSlices,...
         %    phLowTh, phHighTh, ampLowTh, ampHighTh)
         
         
         if nargin > 1 % If the variables were given this function in a cell array
            
            minZslices  = varargin{1};
            maxZslices  = varargin{2};
            phLowTh    = varargin{3};
            phHighTh   = varargin{4};
            ampLowTh   = varargin{5};
            ampHighTh  = varargin{6};
         else
            minZslices  = this.minZSlices;
            maxZslices  = this.maxZSlices;
            phLowTh    = this.phaseLowThresh;
            phHighTh   = this.phaseHighThresh;
            ampLowTh   = this.ampLowThresh;
            ampHighTh  = this.ampHighThresh;
         end
         % Check if the number of slices is sufficient. If not, return
         % this particle as not valid.
         if (exist('minZslices', 'var') && ~isempty(minZslices) && this.lNz <= minZslices) ||  ...
               (exist('maxZslices', 'var') && ~isempty(maxZslices) && this.lNz >= maxZslices)
            isEligible = false;
            return;
         end
         % Check phase
         temp = this.blocks.phBlock;
         if (exist('phLowTh', 'var') && ~isempty(phLowTh) && nanmin(temp(:)) >= phLowTh) && ...
               (exist('phHighTh', 'var') && ~isempty(phHighTh) && nanmax(temp(:)) <= phHighTh)
            isEligible1 = false;
         else
            isEligible1 = true;
         end
         % Check amplitude
         temp = this.blocks.ampBlock;
         if (exist('ampLowTh', 'var') && ~isempty(ampLowTh) && nanmin(temp(:)) >= ampLowTh) && ...
               (exist('ampHighTh', 'var') && ~isempty(ampHighTh) && nanmax(temp(:)) <= ampHighTh)
            isEligible2 = false;
         else
            isEligible2 = true;
         end
         % This correction was necessary to allow different operator
         % settings!
         isEligible = this.config_handle.threshOp(isEligible1,isEligible2);
      end
      
      % Estimate the zposition by taking the selFcn of value(whichVals),
      % for example by taking the mean([this.value(1) this.value(3)
      % this.value(5)]);
      function zLInd = estimateZLInd(this, selFcn, whichVals)
         if nargin == 1
            selFcn = this.zPosSelFcn;
            whichVals = this.zPosValues;
         end
         %             zLInds = cell(1);
         %             for cnt = 1:numel(whichVals)
         %                 temp = this.value(whichVals(cnt));
         %                 if ~isempty(temp)
         %                     zLInds(cnt) = temp(1);
         %                 end
         %             end
         zLInds = this.value(whichVals);
         zLInds = cellfun(@(X) X{1}, zLInds,'UniformOutput',false);
         zLInds = zLInds(:); % Make it a column vector
         mask  = cellfun(@(x) isempty(x), zLInds);
         zLInds = zLInds(~mask);
         zLInds = cell2mat(zLInds);
         if isempty(zLInds) || all(isnan(zLInds))
            zLInd = round(this.lNz/2);
         else
            zLInd = round(selFcn(zLInds));
         end
         this.zLInd = zLInd;
      end
      
      function zPos = estimateZPos(this, selFcn, whichVals)
         if isempty(this.zLInd)
            if nargin == 1
               this.estimateZLInd;
            else
               this.estimateZLInd(selFcn, whichVals)
            end
         end
         if isnan(this.zLInd),zPos = nan;else zPos = this.zggrid(this.zLInd); end
      end
      
      % Estimate the size of the particle at the zPos specified by zInd
      % or estimateZPos with this.zPosSelFcn and zPosValues
      function pDiam  = estPDiam(this, zInd)
         if nargin == 1
            if isempty(this.zLInd)
               zInd = this.estimateZLInd();
            else
               zInd = this.zLInd;
            end
         end
         
         if zInd < 2
            indices = zInd;
         else
            indices = zInd + (-1:1);
         end
         
         indices = indices(indices >= 1 & indices <= this.lNz);
         temp    = this.validVoxels(indices);
         temp    = any(temp,3);
         temp    = regionprops(temp,'EquivDiameter');
         pDiam   = max([temp.EquivDiameter]) * sqrt(this.dx*this.dy)';
      end
      
      % Estimate the x and y position of the particle at the zPos
      % specified by zInd or assumed a call to estimateZLInd
      function varargout = estXY(this, zInd)
         if nargin == 1
            if isempty(this.zLInd)
               zInd = this.estimateZLInd();
            else
               zInd = this.zLInd;
            end
         end
         
         if zInd < 2
            indices = zInd;
         else
            indices = zInd + (-1:1);
         end
         
         indices = indices(indices >= 1 & indices <= this.lNz);
         temp    = this.validVoxels(indices);
         temp    = any(temp,3);
         props   = regionprops(temp,'Centroid','EquivDiameter');
         [~,ind] = max([props.EquivDiameter]); %Choose the object with the biggest diameter
         cent    = props(ind).Centroid;
         diam    = props(ind).EquivDiameter;
         
         if numel(cent)
            xInd    = round(cent(1));
            yInd    = round(cent(2));
            xPos    = this.xggrid(xInd);
            yPos    = this.yggrid(yInd);
         else
            xPos = this.xggrid(round(this.lNx/2));
            yPos = this.yggrid(round(this.lNy/2));
         end
         
         if nargout < 2
            varargout = {xPos, yPos};
         else
            varargout{1} = xPos;
            varargout{2} = yPos;
            varargout{3} = diam;
         end
      end
      
      % Return the image of the particle as index zInd, or if not
      % specified then guess the center one
      function bildChen = pImage(this, zInd)
         if nargin == 1
            if isempty(this.zLInd)
               zInd = this.estimateZLInd();
            else
               zInd = this.zLInd;
            end
         end
         indices = zInd;
         indices = indices(indices >= 1 & indices <= this.lNz);
         bildChen = this.blocks.pBlock(:,:,indices);
      end
   end
   
   methods
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      function [t, name] = trace(this,idx)
         if nargin == 1, idx = 1:numel(this.traceMaps); end
         
         t = cell(1,numel(idx));
         if numel(idx) > 1, name = cell(1,numel(idx)); end
         
         for cnt=1:numel(idx)
            tinfo = this.traceMaps{idx(cnt)};
            if numel(tinfo) ~= 4
               error( ['Trace maps require 4 arguments, ''Name'', '...
                  '''getCenter'' or ''getWhole'', ''ampBlock'' or ''phBlock'' or ''pBlock'','...
                  ' and trace function such as ''max'', ''min'', ''mean'', or ''std''']);
            end
            
            if idx(cnt) <= size(this.traceCache,2) && ~isempty(this.traceCache{idx(cnt)})
               t{cnt} = this.traceCache{idx(cnt)};
            else
               
               %name = tinfo{1};  % The name of the trace
               segment = tinfo{2}; % getCenter or getWhole
               trans = tinfo{3}; % The ampBlock pBlock or phBlock
               fxn = tinfo{4};   % The function to process the trace
               
               if ischar(trans)   % Whichever amp or pBlock we want to use
                  pB = this.blocks.(trans);
               elseif isa(trans,'function_handle') % or user defined.
                  pB= trans(this);
               end
               
               if ischar(segment)
                  pB = this.(segment)(pB);
               elseif isa(segment,'function_handle')
                  pB= segment(this);
               end
               
               if isempty(pB)
                  t{cnt} = nan(this.lNz,1);
               end
               
               if ischar(fxn)
                  t{cnt} = this.(fxn)(pB);
               elseif isa(segment,'function_handle')
                  t{cnt} = fxn(pB);
               end
               
               this.traceCache{idx(cnt)} = t{cnt};
               
            end
            
            if numel(idx) > 1
               name{cnt} = tinfo{1};
            else
               name = tinfo{cnt};
            end
         end
         
         t = cellfun(@double,t,'UniformOutput',false);
         t = cell2mat(t);
      end
      
      function siz = Ntraces(this)
         siz = numel(this.traceMaps);
      end
      
      function [v, name] = value(this,idx)
         if nargin == 1, idx = 1:numel(this.valueMaps); end
         
         v = cell(1, numel(idx));
         if numel(idx) > 1, name = cell(1,numel(idx)); end
         
         for cnt = 1:numel(idx)
            vinfo = this.valueMaps{idx(cnt)};
            
            if idx(cnt) <= size(this.valueCache,2) && ~isempty(this.valueCache{idx(cnt)})
               v{cnt} = this.valueCache{idx(cnt)};
            else
               if numel(vinfo) ~= 3
                  error( ['Value maps require 3 arguments, ''Name'', '...
                     ' Trace index, and ''SelSigPks'' or ''SelSigTrs''']);
               end
               trace = this.trace(vinfo{2});
               
               fxn   = vinfo{3};
               
               if numel(vinfo) == 3
                  v{cnt} = this.(fxn)(trace);
               elseif numel(vinfo) == 4
                  params = vinfo{4};
                  v{cnt} = this.(fxn)(trace,params);
               end
               
            end
            
            name{idx(cnt)} = vinfo{1};
            this.valueCache{idx(cnt)} = v{cnt};
         end
         
         %             if numel(idx) == 1
         %                v = v{1};
         %                name = name{1};
         %             end
      end
      
      function siz = Nvalues(this)
         siz = numel(this.valueMaps);
      end
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      function idx = addBlock(this,name,tfxn,params)
         if nargin == 4
            this.blockMaps{end+1} = {name, tfxn, params};
         else
            this.blockMaps{end+1} = {name, tfxn};
         end
         if nargout, idx = numel(this.blockMaps); end
      end
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      function idx = addTrace(this,name,seg,trans,tfxn)
         idx = numel(this.traceMaps) + 1;
         if iscell(name) && (numel(name) == 4 || numel(name) == 3)
            this.traceMaps{idx} = name;
         elseif nargin == 5
            this.traceMaps{idx} = {name, seg, trans, tfxn};
         elseif nargin == 4
            this.traceMaps{idx} = {name, seg, trans};
         else
            error('particle:invalid trace', 'Invalid number of args in trace.'); %#ok<CTPCT>
         end
      end
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      function idx = addValue(this,name,trace,vfxn)
         idx = numel(this.valueMaps) + 1;
         if iscell(name) && numel(name) == 3
            this.valueMaps{idx} = name;
         elseif nargin == 4
            this.valueMaps{idx} = {name, trace, vfxn};
         else
            error('particle:invalid value', 'Invalid number of args in value map.'); %#ok<CTPCT>
         end
      end
      
      function set.traceMaps(this,value)
         oldMap = this.traceMaps;
         
         if ~isempty(oldMap)
            prehash = cellfun(@cell2mat,oldMap,'UniformOutput',false);
            posthash = cellfun(@cell2mat,value,'UniformOutput',false);
            
            %Delete unused cached data
            [~,remove] = setdiff(prehash,posthash);
            this.clearCache('traceCache',remove);
            prehash(remove) = [];
            
            this.growCache('traceCache',length(value));
            
            %Reorder the cache data to match if needed
            map = arrayfun(@(a)find(strcmp(a,posthash)),prehash);
            this.reorderCache('traceCache',map);
         end
         
         this.traceMaps = value;
      end
      
      function set.valueMaps(this,value)
         oldMap = this.valueMaps;
         if ~isempty(oldMap)
            prehash  = cellfun(@(f)cell2mat(cellfun(@num2str,f,'UniformOutput',false)),oldMap,'UniformOutput',false);
            posthash = cellfun(@(f)cell2mat(cellfun(@num2str,f,'UniformOutput',false)),value,'UniformOutput',false);
            
            %Delete unused cached data
            [~,remove] = setdiff(prehash,posthash);
            this.clearCache('valueCache',remove);
            prehash(remove) = [];
            
            this.growCache('valueCache',length(value));
            
            %Reorder the cache data to match if needed
            map = arrayfun(@(a)find(strcmp(a,posthash)),prehash);
            this.reorderCache('valueCache',map);
         end
         
         this.valueMaps = value;
      end
      
      function set.config_handle(this,hnd)
         if ischar(hnd)
            this.config_handle = config(hnd);
         elseif isa(hnd,'config')
            this.config_handle = hnd;
         end
      end
      function growCache(this,cache,count)
         extra = count - length(this.(cache));
         if extra > 0, this.(cache) = cat(2,this.(cache),cell(1,extra)); end
      end
      
      function clearCache(this,cache,idx)
         if nargin == 1
            this.traceCache = {};
            this.valueCache = {};
         elseif nargin == 2
            this.(cache) = {};
         else
            this.(cache)(idx) = [];
         end
      end
      
      function reorderCache(this,cache,map)
         newVals = this.(cache)(1:length(map));
         this.(cache)(1:length(map)) = cell(1,length(map));
         this.(cache)(map) = newVals;
      end
      
   end
   
   methods
      
      function refreshPB(this)
         this.zLInd = [];
         this.updateCoords;
         this.clearCache;
         this.clearPB;
         this.blocks.pBlock = this.complexBlock;
         this.blocks.ampBlock = this.absBlock(this.blocks.pBlock);
         this.blocks.phBlock = this.angleBlock(this.blocks.pBlock);
         
         %%%handle dynamic blocks%%%
         for i = 1:numel(this.blockMaps)
            map = this.blockMaps{i};
            if numel(map) == 3
               this.blocks.(genvarname(map{1})) = map{2}(this.complexBlock,map{3}{:});
            else
               this.blocks.(genvarname(map{1})) = map{2}(this.complexBlock);
            end
         end
         
      end
      
      function clearPB(this)
         this.blocks = struct('pBlock',[], ...
            'ampBlock', [], ...
            'phBlock', []);
      end
      
      function updateCoords(this)
         if isempty(this.idx)
            return;
         end
         [y, x, z] = ind2sub([this.gNy, this.gNx], this.idx);
         gxcor = double(x);
         gycor = double(y);
         gzcor = double(z);
         
         this.offset = [min(gxcor) min(gycor) min(gzcor)] - 1;
         this.xlCor = gxcor - this.offset(1);
         this.ylCor = gycor - this.offset(2);
         this.zlCor = gzcor - this.offset(3);
      end
   end
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %some default trace methods
   methods (Static)
      
      function out = mean(pBlock)
         out = squeeze(nanmean(nanmean(pBlock)));
      end
      
      function out = std(pBlock)
         [Ny, Nx, Nz] = size(pBlock);
         temp = reshape(pBlock,[Ny*Nx Nz]);
         out = nanstd(temp)';
      end
      
      function out = min(pBlock)
         out = squeeze(nanmin(nanmin(pBlock)));
      end
      
      function out = max(pBlock)
         out = squeeze(nanmax(nanmax(pBlock)));
      end
      
      function out = minTrace(pBlock)
         [~,ind] = nanmin(pBlock(:));
         [x,y,~] = ind2sub(size(pBlock),ind);
         out = squeeze(pBlock(x,y,:));
      end
      
      function out = maxTrace(pBlock)
         [~,ind] = nanmax(pBlock(:));
         [x,y,~] = ind2sub(size(pBlock),ind);
         out = squeeze(pBlock(x,y,:));
      end
      
   end
   
   %non-static trace methods
   methods
      function out = pxArea(this,~)
         out = this.validVoxels;
         out = squeeze(sum(sum(out)));
      end
      
      function out = area(this,~)
         out = this.pxArea;
         out = out.*this.dx.*this.dy;
      end
      
      function out = diameter(this,~)
         out = this.area;
         out = sqrt(4*out/pi);
      end
   end
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %Single value methods
   methods
      function varargout = selSigPks(this,trace)
         try
            pklvl = prctile(trace,this.pkpct);
            warning('off','signal:findpeaks:largeMinPeakHeight');
            [sigpks, siglocs] = findpeaks(trace,...
               'MINPEAKHEIGHT',pklvl,'MINPEAKDISTANCE',this.minPkD);
            if numel(sigpks) > this.maxNPks
               [sigpks, ind] = sort(sigpks);
               siglocs = siglocs(ind);
               sigpks = sigpks(end-this.maxNPks +1:end);
               siglocs= siglocs(end-this.maxNPks +1:end);
            end
            warning('on','signal:findpeaks:largeMinPeakHeight');
            
         catch exception %#ok<NASGU>
            %fprintf([exception.message '\n']);
            siglocs = nan;
            sigpks = nan;
         end
         if nargout < 2
            varargout{1} = {siglocs, sigpks};
         elseif nargout == 2
            varargout{1} = siglocs;
            varargout{2} = sigpks;
         end
         
      end
      
      % Find the significant troughs in a trace
      function varargout = selSigTrs(this,trace)
         [siglocs, sigtroughs] = this.selSigPks(-trace);
         sigtroughs = -sigtroughs;
         if nargout < 2
            varargout{1} = {siglocs, sigtroughs};
         elseif nargout == 2
            varargout{1} = siglocs;
            varargout{2} = sigtroughs;
         end
      end
   end
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %
   % Methods to search for a ring features around a particle center
   methods (Static)
      
      function radTraceStats = makeEmptyRadTraceStats
         radTraceStats.rtAveTr        = nan;
         radTraceStats.rtrs           = nan(1,3);
         radTraceStats.rtBestFit      = nan(1,4);
         radTraceStats.rtDp           = nan;
         radTraceStats.rtBSlope       = nan;
         radTraceStats.rtSignal       = nan;
         radTraceStats.rtGoodFit      = nan;
         radTraceStats.rtAsym         = nan;
         radTraceStats.rtCenterx      = nan;
         radTraceStats.rtCentery      = nan;
         radTraceStats.rtXPos         = nan;
         radTraceStats.rtYPos         = nan;
      end
      
      % Returns statistics from the radial traces in allRadTraces. The
      % statistics include (1) diameter (measured half way from the
      % particle level and the background level (threshold independent),
      % (2) steepness of the boundry (measure of goodness of resolution),
      % (3) perimRatio about theta (measure of particle asphericity and
      % centration), (4) goodness of average and (5) goodness of fit
      % (measure of residuals between the best fit and actual radial
      % traces.
      function [radTrStats, rs, thetas, allRadTraces] = getRadTrStats(partSlice, centerx, centery)
         radTrStats = particleForRtStats.makeEmptyRadTraceStats;
         if isnan(centerx) || isnan(centery)
            rs = nan; thetas = nan; allRadTraces = nan;
            return;
         end
         
         % Search for a symmetry center to specify centerx and centery
         [centerx, centery, rs, aveRadTr] = particleForRtStats.getBestCenteredRadTr(partSlice, ...
            centerx, centery);
         radTrStats.rtCenterx = centerx;
         radTrStats.rtCentery = centery;
         
         % Get the best fit for the abs of this average trace
         bestFit = particleForRtStats.zickZackFit(rs, abs(aveRadTr));
         radTrStats.rtBestFit = bestFit;
         
         % Calculate the signal which is just the integral of the volume
         % of the bestFit underneath the threshold.
         radTrStats.rtSignal = pi/2 * (mean(bestFit(1:2))-min(bestFit(1:2))) ...
            * (bestFit(4).^2 + bestFit(3).^2);
         radTrStats.rtrs     = [min(rs), max(rs), numel(rs)];
         
         % Now recalculate all the particle rad traces with the improved
         % Centroid.
         [rs, thetas, allRadTraces] = particleForRtStats.getRadTraces(partSlice, ...
            centerx, centery);
         
         % Estimate the asymmetry of using the RadTraces, mean of the
         % variance along the trace.
         radTrStats.rtAsym = nanmean(nanvar(abs(allRadTraces)));
         
         % Get the average radial trace
         radTrStats.rtAveTr = nanmean(allRadTraces);
         
         % Calculate the diameter from this best fit of the average trace
         radTrStats.rtDp = mean(bestFit(3:4))*2; % the average of the start
         % and stop of the boundary region
         
         % The steepness of the boundary is a slope
         radTrStats.rtBSlope = abs(diff(bestFit(1:2))/diff(bestFit(3:4)));
         
         % Evaluate a good fit from the RMS of the model fit for all
         % points along the radial traces alike. The model fit is only
         % designed for the magnitude (abs) of the traces.
         toCompareFit          = particle.zickZackModelFun(bestFit,rs);
         temp                  = bsxfun(@minus,toCompareFit, abs(allRadTraces));
         radTrStats.rtGoodFit  = nanstd(temp(:));
         
      end
      
      
      function imStats = makeEmptyImStats
         imStats.imCenterx        = nan;
         imStats.imCentery        = nan;
         imStats.imMeanRadii      = nan;
         imStats.imStdRadii       = nan;
         imStats.imStdmRadii      = nan;
         imStats.imStdAngles      = nan;
         imStats.imStdmAngles     = nan;
         imStats.imPerimRatio     = nan;
         imStats.imEccentricity   = nan;
         imStats.imSolidity       = nan;
         imStats.imEquivDia       = nan;
         imStats.imXPos           = nan;
         imStats.imYPos           = nan;
      end
      
      % This function takes the particle slice, finds (hopefully) the edge
      % of the particle, tries to close it, and make a perimeter out of
      % it, get rid of extraneous pixels also under the threshold, and
      % then calculates some statistics on them.
      function imStats = getImageStats(partSlice, threshold, isshadow, imclosefactor)
         imStats = particle.makeEmptyImStats;
         if ~isreal(partSlice) % We work on the amplitude if it ain't already real
            partSlice = abs(partSlice);
         end                   % If not given a threshold, find a likely one
         if ~exist('threshold','var') || isempty(threshold)
            partSlice = partSlice - min(partSlice(:));
            partSlice = partSlice/max(partSlice(:));
            threshold = graythresh(partSlice);
         end                   % if the particles are shadows or are bright
         if ~exist('isshadow','var') || isempty(isshadow)
            isshadow = true;
         end
         if ~exist('imclosefactor','var') || isempty(imclosefactor)
            imclosefactor = 0;
         end
         
         % Threshold the image
         if isshadow
            ImBW = partSlice < threshold;
         else
            ImBW = partSlice > threshold;
         end
         
         % Close edges if asked to
         if imclosefactor > 0
            ImBW = imclose(ImBW,strel('disk',imclosefactor));
         end
         
         % Fill in any holes
         ImBW = imfill(ImBW,'holes');
         % And segment the image
         cc    = bwconncomp(ImBW);
         
         % If there is more than one object, choose the biggest one, or
         % the one with the most pixels
         if cc.NumObjects > 1
            n = cellfun(@numel,cc.PixelIdxList);
            cc.PixelIdxList = cc.PixelIdxList(max(n)==n);
            cc.PixelIdxList = cc.PixelIdxList(1);
            cc.NumObjects = 1;
         end
         
         % Remake the binary image for the call to bwperim
         ImBW = false(size(ImBW));
         ImBW(cc.PixelIdxList{1}) = true;
         ImPerim = bwperim(ImBW); % Get the perimeter
         [ix, iy] = ind2sub(size(ImPerim),find(ImPerim));
         
         % Calculate the angles between the perimeter pixels
         % Get the order of the perimeter of indices, it returns the
         % indices of ix, and iy in the order that they connect around the
         % perimeter. Do it with the method of connecting one pixel to its
         % nearest neighbor (except to previously connected pixels, until
         % you complete the circle.
         function orderInd = getPerimOrder(ix,iy)
            orderInd      = zeros(numel(ix)+1,1);
            orderInd(1)   = 1;
            curInd        = 1;
            leftOverInd   = (2:numel(ix))';
            % As long as there are more indices to connect
            while ~isempty(leftOverInd)
               % Get the distances to all the leftover perimeter pixels
               distances        = sqrt( (ix(orderInd(curInd))-ix(leftOverInd)).^2 ...
                  + (iy(orderInd(curInd))-iy(leftOverInd)).^2);
               [~,minInd]       = min(distances);
               orderInd(curInd+1) = leftOverInd(minInd);
               leftOverInd      = leftOverInd([1:minInd-1 minInd+1:end]);
               curInd = curInd+1;
            end
            orderInd(end)=orderInd(1);
         end
         
         orderInd = getPerimOrder(ix,iy); % Get the order
         ix = ix(orderInd); % And put the perimeter pixels in order
         iy = iy(orderInd);
         
         % Calculate the center of the perimeter as in the point with the
         % minimum variance of the radii.
         function radii = calculateRadii(xcen, ycen)
            radii = sqrt((ix - xcen).^2+(iy - ycen).^2);
         end
         function varRadii = varInRadii(x)
            varRadii = var(calculateRadii(x(1), x(2)));
         end
         [Ny, Nx] = size(ImPerim);
%          function [c, ceq] = withinRadius(x)
%             c = (x(1) - Nx/2)^2 + (x(2) - Ny)^2 - min(Nx, Ny)^2;
%             ceq = [ ];
%          end
         opt     = optimoptions('fmincon','algorithm','interior-point',...
            'display','off','TolX',[0.1]);
         x0      = [mean(ix),mean(iy)];
         xbest   = fmincon(@varInRadii,x0,[],[],[],[],[1; 1] +1, [Nx; Ny] -1, [],opt);
         
         imStats.imCenterx  = xbest(1);
         imStats.imCentery  = xbest(2);
         % Calculate the distribution of radii
         filtn = 3;
         radii = calculateRadii(xbest(1),xbest(2));
         if numel(radii) > 2*filtn+1
            radii = filtfilt(ones(1,filtn)/filtn,1,radii);
            imStats.imMeanRadii = mean(radii);
            imStats.imStdRadii = std(radii);
            imStats.imStdmRadii = std(radii)/abs(mean(radii));
         end
         
         % Calculate the angles between perimeter points
         angles = unwrap(atan2(iy - xbest(2),ix - xbest(1)));
         if numel(angles) > 2*filtn+1
            angles = filtfilt(ones(filtn,1)/filtn,1,angles);
            diffangles = diff(angles);
            imStats.imStdAngles = std(diffangles);
            imStats.imStdmAngles = std(abs(diffangles))*numel(angles)/(2*pi);
         end
         
         props = regionprops(cc,'Eccentricity','Perimeter',...
            'Solidity','EquivDiameter','Centroid');
         imStats.imPerimRatio     = props.Perimeter/(pi*props.EquivDiameter);
         imStats.imEccentricity   = props.Eccentricity;
         imStats.imSolidity       = props.Solidity;
         imStats.imEquivDia       = props.EquivDiameter;
      end
      
      % Fit the radial trace of rs and radial trace with a zig zag fit, or
      % a 3-piecewise continuous linear function shaped like so:
      %                ________________________
      %               /
      %              /
      % ____________/
      % with a particle level (line level with intensity), a background
      % level (again level with intensity) and a boundary slope (a
      % straight line). Simple model, hopefully simple to understand and
      % characterize results.
      function bfit = zickZackFit(rs, trace)
         if ~numel(trace) || sum(~isnan(trace)) < 2
            bfit = nan(1,4);
            return
         end    % Prepare initial guess based on numeric values
         temp = trace(isfinite(trace));
         temprs = rs(isfinite(trace));
         beta0(1) = mean(temp(1:2));   % The particle level is at radius = 0
         beta0(2) = mean(temp(end-1:end)); % The background level should be at radius = max
         if beta0(2) > beta0(1) % If this is a negative profile
            beta0(3) = rs(find(temp > prctile(beta0(1:2),30),1));
            beta0(4) = rs(find(temp > prctile(beta0(1:2),70),1));
         else
            beta0(3) = rs(find(temp < prctile(beta0(1:2),70),1));
            beta0(4) = rs(find(temp < prctile(beta0(1:2),30),1));
         end
         warning('off','stats:nlinfit:ModelConstantWRTParam')
         warning('off','stats:nlinfit:IllConditionedJacobian')
         warning('off','MATLAB:rankDeficientMatrix')
         warning('off','stats:nlinfit:Overparameterized');
         bfit = nlinfit(temprs, temp, @particle.zickZackModelFun,beta0);
         warning('on','stats:nlinfit:Overparameterized');
         warning('on','stats:nlinfit:ModelConstantWRTParam')
         warning('on','stats:nlinfit:IllConditionedJacobian')
         warning('on','MATLAB:rankDeficientMatrix')
      end
      
      % The model function used in zickZackFit
      function ys = zickZackModelFun(beta, rs)
         partLevel     = beta(1);   % The particle intensity level
         bkgndLevel    = beta(2);  % The background intensity level
         firstBoundR   = max(0,beta(3)); % The first R of the boundary of the particle and is at least 0
         lastBoundR    = max(beta(3:4));  % The last R of the boundary of the particle and is at least beta(3)
         ys            = zeros(size(rs)); %Preallocate ys
         ys(rs >= lastBoundR)   = bkgndLevel;
         ys(rs <= firstBoundR)  = partLevel;
         transrs       = rs < lastBoundR & rs > firstBoundR;
         if any(transrs)
            ys(transrs)   = interp1([firstBoundR lastBoundR], [partLevel bkgndLevel], ...
               rs(transrs));
         end
      end
      
      % Returns the center and average Radial Trace based on the center
      % with the best symmetry. It should find the center of something
      % circularly symmetric. It's success is sensitive to the estimated centerx and
      % centery parameters.
      function [centerx, centery, rs, aveRadTr] = getBestCenteredRadTr(partSlice, ...
            centerx, centery, dx, dy, Nthetas)
         
         % We need double arguments to pass to fmincon:
         partSlice = double(partSlice);
         
         if ~exist('dx','var') || isempty(dx)
            dx = 1;
         end
         if ~exist('dy','var') || isempty(dy)
            dy = 1;
         end
         
         % Default Nthetas if not specified
         if ~exist('Nthetas','var'), Nthetas = []; end
         
         % Define the bounds within we are searching for the center,
         % within the radius of a circle that fits within the region partSlice
         [Ny, Nx] = size(partSlice);
         
         % Firstguess is [centerx, centery]
         x0 = [centerx, centery];
         
         % The fit function (as a nested function)
         function assymetryError = assymetryEstimate(x)
            % First call the getRadTraces which gives an estimate of
            % background level, particle intensity level, and particle edge.
            [~, ~, allRadTraces] = particle.getRadTraces(partSlice, x(1), x(2), dx, dy, Nthetas);
            % Get the average radial trace
            assymetryError = nanmean(nanvar(allRadTraces));
         end
         
%          function [c, ceq] = withinRadius(x)
%             c = (x(1) - Nx/2)^2 + (x(2) - Ny)^2 - min(Nx, Ny)^2;
%             ceq = [ ];
%          end
         %           xs = 1:0.5:Nx;
         %           ys = 1:0.5:Ny;
         %           [xx, yy] = meshgrid(xs,ys);
         %           est = arrayfun(@(x,y) assymetryEstimate([x y]),xx,yy);
         %           figure(1); clf; imagesc(est);
         opt = optimoptions('fmincon','algorithm','interior-point','TolX', 0.1,'display','off');
         xbest = fmincon(@assymetryEstimate,x0,[],[],[],[],[1;1] +1, [Nx;Ny] -1,[],opt);
         centerx = xbest(1);
         centery = xbest(2);
         [rs, ~, allRad] = particle.getRadTraces(partSlice, centerx, centery, dx, dy, Nthetas);
         aveRadTr = mean(allRad);
      end
      
      
      % Returns the radial traces from a hopefully round particle
      % appearing focused in partSlice at position centerx and centery. dx
      % and dy are used to calculate the scale of rs.
      function [rs, thetas, allRadTraces] = getRadTraces( partSlice, centerx, centery, dx, dy, Nthetas)
         if ~exist('dx','var') || isempty(dx)
            dx = 1;
         end
         if ~exist('dy','var') || isempty(dy)
            dy = 1;
         end
         % First define the neighborhood of the center at centerx and
         % centery without nans.
         [Ny, Nx] = size(partSlice);
         if isfinite(centerx) && centerx >= 1 && centerx <= Nx
            endearly = false;
         elseif isfinite(centery) && centery >= 1 && centery <= Ny
            endearly = false;
         else
            endearly = true;
         end
         xs = (1:Nx) - centerx;
         ys = (1:Ny) - centery;
         maxr = sqrt(max(abs(xs)).^2+max(abs(ys)).^2);
         % The maximum radius we will use to look for in our
         % average radial trace.
         
         % Choose the number of angles to take sample traces at.
         % Make the number of angle samples to be some fraction of the
         % circumference of the area divided by the pixel size.
         if ~exist('Nthetas','var') || isempty(Nthetas)
            Nthetas = 2*pi*maxr/3;
            Nthetas = Nthetas/2; % We interpolate a diameter and therefore
            % need half the thetas
         end
         
         thetas = linspace(0,pi,Nthetas);
         rs     = -maxr:1/2:maxr; % We want the rs at about half pixel resolution
         % More wouldn't bring much (right?)
         radtrace = nan(numel(thetas),numel(rs));
         if ~endearly
            pxs = rs'*cos(thetas);
            pys = rs'*sin(thetas);
            radtrace = interp2(xs, ys, partSlice, pxs', pys');
         end
         temp    = radtrace(:,round(end/2):-1:1);
         temp    = [temp; radtrace(:,round(end/2)+mod(end+1,2):end)];
         allRadTraces   = temp;
         rs = (0:1/2:maxr)*sqrt(dx*dy);
         thetas=thetas*2;
      end
   end
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Functions that convert the statistics offered from the static
   % methods getImStats and getRadTraceStats, and converts the pixel
   % coordinates to global coordinates
   methods
      function imst = getThisImStats(this, zInd)
         if ~exist('zInd','var')
            zInd = this.zLind;
         end
         imst = particle.getImageStats(this.pImage(zInd));
         imst.imXPos = interp1(1:this.lNx,this.xggrid,imst.imCenterx);
         imst.imYPos = interp1(1:this.lNy,this.yggrid,imst.imCentery);
         dr = sqrt(this.dx*this.dy);
         imst.imMeanRadii    = imst.imMeanRadii * dr;
         imst.imStdRadii     = imst.imStdRadii * dr;
         imst.imEquivDia     = imst.imEquivDia * dr;
      end
      
      function [radst, rs, thetas, allRadTraces] = getThisRadTrStats(this, xInd, yInd, zInd)
         if ~exist('zInd','var')
            zInd = this.zLind;
         end
         [radst, rs, thetas, allRadTraces] = particle.getRadTrStats(this.pImage(zInd), xInd, yInd);
         radst.rtXPos  = interp1(1:this.lNx,this.xggrid,radst.rtCenterx);
         radst.rtYPos  = interp1(1:this.lNy,this.yggrid,radst.rtCentery);
         dr = sqrt(this.dx*this.dy);
         radst.rtrs(2)        = radst.rtrs(2) * dr;
         radst.rtBestFit(3:4) = radst.rtBestFit(3:4) *dr;
         radst.rtDp           = radst.rtDp *dr;
         radst.rtBSlope       = radst.rtBSlope *dr;
         radst.rtSignal       = radst.rtSignal *dr^2;
      end
   end
   
   methods
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      % Functions that returns the characteristics of this particle in a
      % pStats structure. If the particle is considered valid, it puts
      % out the x, y, and z global position, an estimated equivalent
      % diameter, and a picture (complex valued) of the particle at the
      % focus position. If it ain't valid, then it puts out a structure
      % with nans and empty cells.
      function pStats = spitOutEssStats(this)
         pStats = this.makeEmptyPStats;
         if ~this.isValidParticle % If the particle is not "valid" then
            % return nans and empties
            return;
         end
         % Select a zPos given the parameters defined for this particle object already
         pStats.zPos     = this.estimateZPos;
         pStats.zLInd    = this.zLInd;
         % Now save the outline of the image in focus and find its x-y center
         %Save the image of the particle at its estimated focal plane
         pStats.pImage   = this.pImage(this.zLInd);
         % Get the x and y coordinates and diameter of the particle
         [pStats.xPos, pStats.yPos, pStats.pDiam] = this.estXY;
         % Get the min and max phase values from the center of the particle
         temp    = this.pImage(this.zLInd + (-1:1));
         temp2   = this.angleBlock(temp);
         pStats.minPh    = nanmin(temp2(:));
         pStats.maxPh    = nanmax(temp2(:));
         % Get the min and max amplitude values from the center of the
         % particle
         temp2   = this.absBlock(temp);
         pStats.minAmp   = nanmin(temp2(:));
         pStats.maxAmp   = nanmax(temp2(:));
         % Get the min and max Sobel values from the center of the
         % particle
%          temp2   = this.getSobel(temp);
%          pStats.minSob   = nanmin(temp2(:));
%          pStats.maxSob   = nanmax(temp2(:));
         
         pStats.isInVolume = this.isParticleInValidVolume(pStats.xPos, pStats.yPos, pStats.zPos);
      end
      
      function [pStats, rs, thetas, allRadTraces] = spitOutHoeherStats(this, zInd)
         
         pStats = this.makeEmptyHoeherStats;
         
         %% Do the stuff for Essential Stats
         if ~this.isValidParticle % If the particle is not "valid" then
            % return nans and empties
            return;
         end
         % Select a zPos given the parameters defined for this particle object already
         pStats.zPos     = this.estimateZPos;
         pStats.zLInd    = this.zLInd;
         % Find a particle size from this center plane
         pStats.pDiam    = this.estPDiam;
         % Now save the outline of the image in focus and find its x-y center
         %Save the image of the particle at its estimated focal plane
         pStats.pImage   = this.pImage(this.zLInd);
         % Get the x and y coordinates of the particle
         [pStats.xPos, pStats.yPos] = this.estXY;
         % Get the min and max phase values from the center of the particle
         temp    = this.pImage(this.zLInd + (-3:3));
         temp2   = this.angleBlock(temp);
         pStats.minPh    = nanmin(temp2(:));
         pStats.maxPh    = nanmax(temp2(:));
         % Get the min and max amplitude values from the center of the
         % particle
         temp2   = this.absBlock(temp);
         pStats.minAmp   = nanmin(temp2(:));
         pStats.maxAmp   = nanmax(temp2(:));
         % Get the min and max Sobel values from the center of the
%          % particle
%          temp2   = this.getSobel(temp);
%          pStats.minSob   = nanmin(temp2(:));
%          pStats.maxSob   = nanmax(temp2(:));
         
         pStats.isInVolume = this.isParticleInValidVolume(pStats.xPos, pStats.yPos, pStats.zPos);
            pStats.isBorder = this.isBorderParticle(pStats.xPos, pStats.yPos, pStats.zPos);
         %% Go get the Stats from ImStats and RadStats
         if ~exist('zInd','var') || isempty(zInd)
            zInd = this.zLInd;
         end         
         imst = this.getThisImStats(zInd);
         radst  = this.makeEmptyRadTraceStats;
         [radst, rs, thetas, allRadTraces] = this.getThisRadTrStats(imst.imCenterx, imst.imCentery, zInd);
         pStats = this.copyFields(pStats,imst);
         pStats = this.copyFields(pStats,radst);
      end
      
   end
   
   methods (Static)
      % Function to copy fields from two unlike structures.
      function newst = copyFields(oldst, addst)
         newst = oldst;
         fieldns = fieldnames(addst);
         for cnt=1:numel(fieldns)
            newst.(fieldns{cnt}) = addst.(fieldns{cnt});
         end
      end
      
      function pStats = makeEmptyPStats()
         pStats.zPos     = nan;
         pStats.zLInd    = nan;
         pStats.pDiam    = nan;
         pStats.pImage   = {[]};
         pStats.xPos     = nan;
         pStats.yPos     = nan;
         pStats.maxPh    = nan;
         pStats.minPh    = nan;
         pStats.maxAmp   = nan;
         pStats.minAmp   = nan;
%          pStats.maxSob   = nan;
%          pStats.minSob   = nan;
         pStats.isInVolume = nan;
            pStats.isBorder  = nan;
      end
      
      function hStats = makeEmptyHoeherStats
         hStats = particle.makeEmptyPStats;
         hStats = particle.copyFields(hStats,particle.makeEmptyRadTraceStats);
         hStats = particle.copyFields(hStats,particle.makeEmptyImStats);
      end
   end
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   methods
      
      function value = get.ampHighThresh(this)
         if isempty(this.ampHighThresh) && isa(this.config_handle,'config')
            value = this.config_handle.ampHighThresh;
         else
            value = this.ampHighThresh;
         end
      end
      
      function value = get.ampLowThresh(this)
         if isempty(this.ampLowThresh) && isa(this.config_handle,'config')
            value = this.config_handle.ampLowThresh;
         else
            value = this.ampLowThresh;
         end
      end
      
      function value = get.phaseHighThresh(this)
         if isempty(this.phaseHighThresh) && isa(this.config_handle,'config')
            value = this.config_handle.phaseHighThresh;
         else
            value = this.phaseHighThresh;
         end
      end
      
      function value = get.phaseLowThresh(this)
         if isempty(this.phaseLowThresh) && isa(this.config_handle,'config')
            value = this.config_handle.phaseLowThresh;
         else
            value = this.phaseLowThresh;
         end
      end
      
      % Returns the the size of the local particle block
      function value = get.lNx(this), value = max(this.xlCor) - min(this.xlCor) +1; end
      function value = get.lNy(this), value = max(this.ylCor) - min(this.ylCor) +1; end
      function value = get.lNz(this), value = max(this.zlCor) - min(this.zlCor) +1; end
      % Returns the number of slices in the reconstructed space
      function value = get.gNz(this), value = numel(this.allZ); end
      
      % Returns the indices (in pixel numbers) of the voxels in this
      % particle space in terms of the whole reconstructed space
      function value = get.xgCor(this),value=this.xlCor + this.offset(1); end
      function value = get.ygCor(this),value=this.ylCor + this.offset(2); end
      function value = get.zgCor(this),value=this.zlCor + this.offset(3); end
      
      % Returns the xs, ys or zs in microns relative to the hologram
      % reconstructed space, but z is relative to the hologram
      function value = get.xggrid(this)
         range = -this.gNx/2:this.gNx/2-1;
         range = range.*this.dx;
         value = min(this.xgCor):max(this.xgCor);
         value = range(value);
      end
      
      function value = get.yggrid(this)
         range = -this.gNy/2:this.gNy/2-1;
         range = range.*this.dy;
         value = min(this.ygCor):max(this.ygCor);
         value = range(value);
      end
      
      function value = get.zggrid(this)
         range = min(this.zgCor):max(this.zgCor);
         value = this.allZ(range);
      end
      
      % Returns the xs, ys or zs in microns relative to the particle
      % space
      function value = get.xlgrid(this)
         value = -this.lNx/2:this.lNx/2-1;
         value = value.*this.dx;
      end
      
      function value = get.ylgrid(this)
         value = -this.lNy/2:this.lNy/2-1;
         value = value.*this.dy;
      end
      
      function value = get.zlgrid(this)
         value = (1:this.lNz).*this.config_handle.dz;
      end
      
      % Returns the positions of the voxels for every voxel in the group
      % in microns in the whol reconstructed space
      function value = get.xgPos(this)
         value = -this.gNx/2:this.gNx/2-1;
         value = value.*this.dx;
         value = value(this.xgCor)';
      end
      
      function value = get.ygPos(this)
         value = -this.gNy/2:this.gNy/2-1;
         value = value.*this.dy;
         value = value(this.ygCor)';
      end
      
      function value = get.zgPos(this)
         value = 0:this.gNz-1;
         value = value.*this.dz;
         value = value(this.zgCor)';
         if isa(this.config_handle,'config')
            value = value + this.config_handle.zMin;
         end
      end
      
      % Returns the positions of the voxels for every voxel in the group
      % in microns in the local particle space
      function value = get.xlPos(this)
         value = -this.lNx/2:this.lNx/2-1;
         value = value.*this.dx;
         value = value(this.xlCor)';
      end
      
      function value = get.ylPos(this)
         value = -this.lNy/2:this.lNy/2-1;
         value = value.*this.dy;
         value = value(this.ylCor)';
      end
      
      function value = get.zlPos(this)
         value = -this.lNz/2:this.lNz/2-1;
         value = value.*this.dz;
         value = value(this.zlCor)';
      end
      
      % useful methods for retrieving important parameters
      function value = get.dx(this)
         if isa(this.config_handle,'config')
            value = this.config_handle.dx;
         else
            value = this.dx;
         end
      end
      
      function value = get.dy(this)
         if isa(this.config_handle,'config')
            value = this.config_handle.dy;
         else
            value = this.dy;
         end
      end
      
      function value = get.dz(this)
         if isa(this.config_handle,'config')
            value = this.config_handle.dz;
         else
            value = this.dz;
         end
      end
      
      function value = get.isCylinder(this)
         if isa(this.config_handle,'config') && isfield(this.config_handle.dynamic, 'isCylinder')
            value = this.config_handle.dynamic.isCylinder;
         else
            value = this.isCylinder;
         end
      end
      
      function value = get.minZPos(this)
         if isa(this.config_handle,'config') && isfield(this.config_handle.dynamic, 'minZPos')
            value = this.config_handle.dynamic.minZPos;
         else
            value = this.minZPos;
         end
      end
      
      function value = get.maxZPos(this)
         if isa(this.config_handle,'config') && isfield(this.config_handle.dynamic, 'maxZPos')
            value = this.config_handle.dynamic.maxZPos;
         else
            value = this.maxZPos;
         end
      end
      
      function value = get.minYPos(this)
         if isa(this.config_handle,'config') && isfield(this.config_handle.dynamic, 'minYPos')
            value = this.config_handle.dynamic.minYPos;
         else
            value = this.minYPos;
         end
      end
      
      function value = get.maxYPos(this)
         if isa(this.config_handle,'config') && isfield(this.config_handle.dynamic, 'maxYPos')
            value = this.config_handle.dynamic.maxYPos;
         else
            value = this.maxYPos;
         end
      end
      
      function value = get.minXPos(this)
         if isa(this.config_handle,'config') && isfield(this.config_handle.dynamic, 'minXPos')
            value = this.config_handle.dynamic.minXPos;
         else
            value = this.minXPos;
         end
      end
      
      function value = get.maxXPos(this)
         if isa(this.config_handle,'config') && isfield(this.config_handle.dynamic, 'maxXPos')
            value = this.config_handle.dynamic.maxXPos;
         else
            value = this.maxXPos;
         end
      end
      
      %%%%%%%%%%%
      % Returns if the particle with this xPos, yPos, zPos is within the
      % bounds set in config.
      
      function value = isParticleInValidVolume(this, xPos, yPos, zPos)
         value = false; % assume false and return when out of bounds
         % If we exceed the zPosition, then just return;
         if zPos < this.minZPos || zPos > this.maxZPos, return; end
         if this.isCylinder % If we are evaluating a cylindrical sample volume
            % Find the particles r coordinate relative to the sample
            % volume center
            result = ((xPos -this.xCenter)/this.maxXRad).^2 ...
               + ((yPos -this.yCenter)/this.maxYRad).^2;
            % If the particle lies farther out, then return false.
            if result > 1, return; end
            value = true; % Or return true
         else   % Or if we aren't evaluating a cylinder, but rather a rectangle
            if xPos < this.minXPos || xPos > this.maxXPos || ...
                  yPos < this.minYPos || yPos > this.maxYPos
               return;
            end
            value = true;
         end
      end
        
        %JanStart
        function isBorder = isBorderParticle(this , xPos, yPos, zPos)      
            
            lminZ         =  1/1000; %minimum z Postion [m]
            lmaxZ         =  20/1000; %minimum z Postion [m]            
            borderPixel   = 50;      %Border Pixel

            if zPos < this.allZ(2) || ...
                    zPos > this.allZ(end-1) || ...
                    zPos < lminZ || ...
                    zPos > lmaxZ;
                isBorder = true;
            elseif xPos < (borderPixel - this.gNx/2)*this.dx || ...
                    yPos < (borderPixel - this.gNy/2)*this.dy || ...
                    xPos > (this.gNx/2 - borderPixel)*this.dx || ...
                    yPos > (this.gNy/2 - borderPixel)*this.dy;
                isBorder = true;
            else
                isBorder = false;
            end
        end
        %JanEnd
   end
end