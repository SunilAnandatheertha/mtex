function plotIPDF(odf,r,varargin)
% plot inverse pole figures
%
% Input
%  odf - @ODF
%  r   - @vector3d specimen directions
%
% Options
%  RESOLUTION - resolution of the plots
%
% Flags
%  antipodal - include [[AxialDirectional.html,antipodal symmetry]]
%  complete  - plot entire (hemi)--sphere
%
% See also
% S2Grid/plot savefigure Plotting Annotations_demo ColorCoding_demo PlotTypes_demo
% SphericalProjection_demo

argin_check(r,'vector3d');

% get fundamental sector for the inverse pole figure
sR = fundamentalSector(odf.CS,varargin{:});

% plotting grid
h = plotS2Grid(sR,varargin{:});
if isa(odf.CS,'crystalSymmetry'), h = Miller(h,odf.CS); end

% create a new figure if needed
[mtexFig,isNew] = newMtexFigure('datacursormode',@tooltip,varargin{:});

for i = 1:length(r)
  
  mtexFig.nextAxis;

  % compute inverse pole figures
  p = ensureNonNeg(odf.calcPDF(h,r(i),varargin{:}));

  % plot
  mtexTitle(mtexFig.gca,char(r(i),'LaTeX'));
  [~,caxes] = h.plot(p,'doNotDraw','smooth',varargin{:});

  % plot annotations
  for cax = caxes(:).'
    setappdata(cax,'inversePoleFigureDirection',r(i));
    set(cax,'tag','ipdf');
    setappdata(cax,'CS',odf.CS);
    setappdata(cax,'SS',odf.SS);
  end
  
end

if isNew % finalize plot
  
  mtexFig.drawNow('figSize',getMTEXpref('figSize'),varargin{:});
  set(gcf,'Name',['Inverse Pole Figures of ',inputname(1)]);

end

% --------------- tooltip function ------------------------------
function txt = tooltip(varargin)

[h_local,value] = getDataCursorPos(mtexFig);

h_local = Miller(h_local,getappdata(mtexFig.parent,'CS'),'uvw');
h_local = round(h_local,'tolerance',3*degree);
txt = [xnum2str(value) ' at ' char(h_local)];

end

end

