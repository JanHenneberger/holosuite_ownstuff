function varargout = GUIParticleClass(varargin)
% GUIPARTICLECLASS MATLAB code for GUIParticleClass.fig
%      GUIPARTICLECLASS, by itself, creates a new GUIPARTICLECLASS or raises the existing
%      singleton*.
%
%      H = GUIPARTICLECLASS returns the handle to a new GUIPARTICLECLASS or the handle to
%      the existing singleton*.
%
%      GUIPARTICLECLASS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIPARTICLECLASS.M with the given input arguments.
%
%      GUIPARTICLECLASS('Property','Value',...) creates a new GUIPARTICLECLASS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUIParticleClass_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUIParticleClass_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUIParticleClass

% Last Modified by GUIDE v2.5 31-Mar-2013 14:50:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIParticleClass_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIParticleClass_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUIParticleClass is made visible.
function GUIParticleClass_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIParticleClass (see VARARGIN)

% Choose default command line output for GUIParticleClass
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUIParticleClass wait for user response (see UIRESUME)
% uiwait(handles.figure1);

if isempty(varargin)
    error('An ''_ms.mat'' argument is required.')
    
else    
    handles.ParInfoFiles = varargin{1};
end
handles.dataAll = load(handles.ParInfoFiles);
handles.dataAll = handles.dataAll.outFile;

handles.pNumber = numel(handles.dataAll.pStats.pDiamOldThresh);
handles.cntParticle = 1;
handles.cntParticleAll = 1;
if isfield(handles.dataAll.pStats,'isIce')
    handles.isIce = handles.dataAll.pStats.isIce;
    handles.isWater = handles.dataAll.pStats.isWater;
    handles.isArtefact = handles.dataAll.pStats.isArtefact;
    handles.isUnkown = handles.dataAll.pStats.isUnkown;
else
    handles.isIce = false(1,handles.pNumber);
    handles.isWater = false(1,handles.pNumber);
    handles.isArtefact = false(1,handles.pNumber);
    handles.isUnkown = false(1,handles.pNumber);
end

classes = handles.isIce + handles.isWater*2 + handles.isArtefact*3 + handles.isUnkown*4;
classNames = {'notSpez';'Ice';'Water';'Artefact';'Unknown'};
handles.parClass = nominal(classes, classNames, [0 1 2 3 4]);

handles.ArtefactStat.minAmpTh = 0.25;
handles.ArtefactStat.maxPhTh = 1.2;
handles = createArtefactStat(handles);

handles = createChoosenData(handles);
colormap('bone')
handles = createPStatsTable(handles);


handles = updateImage(handles);
guidata(hObject,handles)


% --- Outputs from this function are returned to the command line.
function varargout = GUIParticleClass_OutputFcn(~, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ButtonUnkown.
function ButtonUnkown_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonUnkown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handles.isUnkown(handles.cntParticleAll) = 1;
handles.isIce(handles.cntParticleAll) = 0;
handles.isWater(handles.cntParticleAll) = 0;
handles.isArtefact(handles.cntParticleAll) = 0;

handles = getNextParImage(handles);
handles = updatePStatsTableData(handles);

guidata(hObject,handles)


% --- Executes on button press in ButtonIce.
function ButtonIce_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonIce (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.isUnkown(handles.cntParticleAll) = 0;
handles.isIce(handles.cntParticleAll) = 1;
handles.isWater(handles.cntParticleAll) = 0;
handles.isArtefact(handles.cntParticleAll) = 0;

handles = getNextParImage(handles);
handles = updatePStatsTableData(handles);

guidata(hObject,handles)

% --- Executes on button press in ButtonWater.
function ButtonWater_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonWater (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.isUnkown(handles.cntParticleAll) = 0;
handles.isIce(handles.cntParticleAll) = 0;
handles.isWater(handles.cntParticleAll) = 1;
handles.isArtefact(handles.cntParticleAll) = 0;

handles = getNextParImage(handles);
handles = updatePStatsTableData(handles);

guidata(hObject,handles)

% --- Executes on button press in ButtonArtefact.
function ButtonArtefact_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonArtefact (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.isUnkown(handles.cntParticleAll) = 0;
handles.isIce(handles.cntParticleAll) = 0;
handles.isWater(handles.cntParticleAll) = 0;
handles.isArtefact(handles.cntParticleAll) = 1;

handles = getNextParImage(handles);
handles = updatePStatsTableData(handles);

guidata(hObject,handles)

% --- Executes on button press in ButtonLastParticle.
function ButtonLastParticle_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonLastParticle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = getPrevParImage(handles);
guidata(hObject,handles)


% --- Executes on button press in ButtonNextParticle.
function ButtonNextParticle_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonNextParticle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = getNextParImage(handles);
guidata(hObject,handles)


function handles = getNextChoosenImage(handles)
handles.cntParticle = find(handles.choosen.Ind >= handles.cntParticleAll,1,'first');
if isempty(handles.cntParticle)
    handles.cntParticleAll = 1;
    handles.cntParticle = find(handles.choosen.Ind >= handles.cntParticleAll,1,'first');
end
handles.cntParticleAll = handles.choosen.Ind(handles.cntParticle);

function handles = updateImage(handles)
handles = getpImageAbs(handles);
handles = updateBackgroundColor(handles);
handles = updatePStatsTableData(handles);
set(handles.textParNr,'String',['Particle Nr.: ' num2str(handles.cntParticleAll,'%06u')]);
set(gcf,'CurrentAxes', handles.ParticleImage);
imagesc(handles.pImageAbs);


function handles = getNextParImage(handles)
if handles.cntParticle < numel(handles.choosen.Ind)
    handles.cntParticle = handles.cntParticle +1;
    handles.cntParticleAll = handles.choosen.Ind(handles.cntParticle);
    handles = updateImage(handles);
end

function handles = getPrevParImage(handles)
if handles.cntParticle > 1
    handles.cntParticle = handles.cntParticle-1;
    handles.cntParticleAll = handles.choosen.Ind(handles.cntParticle);
    handles = updateImage(handles);
end

function handles  = getpImageAbs(handles)
handles.choosen.Ind;
handles.pImage = cell2mat(handles.dataAll.pStats.pImage(handles.cntParticleAll));
handles.pImageAbs = abs(handles.pImage);
handles.pImageAbs = handles.pImageAbs - min(min(handles.pImageAbs));
handles.pImageAbs = handles.pImageAbs / max(max(handles.pImageAbs));

function handles = updateBackgroundColor(handles)
if handles.isUnkown(handles.cntParticleAll)  == 0;
    set(handles.ButtonUnkown, 'BackgroundColor','w')
else
    set(handles.ButtonUnkown, 'BackgroundColor','r')
end
if handles.isIce(handles.cntParticleAll)  == 0;
    set(handles.ButtonIce, 'BackgroundColor','w')
else
    set(handles.ButtonIce, 'BackgroundColor','g')
end
if handles.isWater(handles.cntParticleAll)  == 0;
    set(handles.ButtonWater, 'BackgroundColor','w')
else
    set(handles.ButtonWater, 'BackgroundColor','g')
end
if handles.isArtefact(handles.cntParticleAll)  == 0;
    set(handles.ButtonArtefact, 'BackgroundColor','w')
else
    set(handles.ButtonArtefact, 'BackgroundColor','r')
end



function handles = createPStatsTable(handles)
columnname = {'Current','Mean All','Mean Water','Mean Ice','Mean Artefact','Mean Unkown','Min','Max'};
set(handles.pStatsTable, 'ColumnName', columnname);
rownname = {'Nr.','xPos','yPos','zPos','imXPos','imYPos',...
    'isBorder','isInVolume','inOnBlacklist','isReal',...
    'minPh','maxPh','minAmp','maxAmp',...
    'pDiam', 'pDiamTh','imEquivDia','imMeanRadii',...
    'imStdRadii','imStdAngles','imPerimRatio',...
    'imEccentricity','imSolidity'};
set(handles.pStatsTable, 'RowName', rownname);
handles.pStatsTableData(1,7) = 1;
handles.pStatsTableData(2,7) = min(handles.dataAll.pStats.xPos(handles.choosen.Data));
handles.pStatsTableData(3,7) = min(handles.dataAll.pStats.yPos(handles.choosen.Data));
handles.pStatsTableData(4,7) = min(handles.dataAll.pStats.zPos(handles.choosen.Data));
handles.pStatsTableData(5,7) = min(handles.dataAll.pStats.imXPos(handles.choosen.Data));
handles.pStatsTableData(6,7) = min(handles.dataAll.pStats.imYPos(handles.choosen.Data));

handles.pStatsTableData(7,7) = min(handles.dataAll.pStats.isBorder(handles.choosen.Data));
handles.pStatsTableData(8,7) = min(handles.dataAll.pStats.isInVolume(handles.choosen.Data));
handles.pStatsTableData(9,7) = min(handles.dataAll.pStats.partIsOnBlackList(handles.choosen.Data));
handles.pStatsTableData(10,7) = min(handles.dataAll.pStats.partIsReal(handles.choosen.Data));

handles.pStatsTableData(11,7) = min(handles.dataAll.pStats.minPh(handles.choosen.Data));
handles.pStatsTableData(12,7) = min(handles.dataAll.pStats.maxPh(handles.choosen.Data));
handles.pStatsTableData(13,7) = min(handles.dataAll.pStats.minAmp(handles.choosen.Data));
handles.pStatsTableData(14,7) = min(handles.dataAll.pStats.maxAmp(handles.choosen.Data));

handles.pStatsTableData(15,7) = min(handles.dataAll.pStats.imDiamMean(handles.choosen.Data));
handles.pStatsTableData(16,7) = min(handles.dataAll.pStats.pDiamOldThresh(handles.choosen.Data));
handles.pStatsTableData(17,7) = min(handles.dataAll.pStats.imEquivDia(handles.choosen.Data));
handles.pStatsTableData(18,7) = min(handles.dataAll.pStats.imMeanRadii(handles.choosen.Data));

handles.pStatsTableData(19,7) = min(handles.dataAll.pStats.imStdRadii(handles.choosen.Data));
handles.pStatsTableData(20,7) = min(handles.dataAll.pStats.imStdAngles(handles.choosen.Data));
handles.pStatsTableData(21,7) = min(handles.dataAll.pStats.imPerimRatio(handles.choosen.Data));
handles.pStatsTableData(22,7) = min(handles.dataAll.pStats.imEccentricity(handles.choosen.Data));
handles.pStatsTableData(23,7) = min(handles.dataAll.pStats.imSolidity(handles.choosen.Data));

handles.pStatsTableData(1,8) = handles.pNumber;
handles.pStatsTableData(2,8) = max(handles.dataAll.pStats.xPos(handles.choosen.Data));
handles.pStatsTableData(3,8) = max(handles.dataAll.pStats.yPos(handles.choosen.Data));
handles.pStatsTableData(4,8) = max(handles.dataAll.pStats.zPos(handles.choosen.Data));
handles.pStatsTableData(5,8) = max(handles.dataAll.pStats.imXPos(handles.choosen.Data));
handles.pStatsTableData(6,8) = max(handles.dataAll.pStats.imYPos(handles.choosen.Data));

handles.pStatsTableData(7,8) = max(handles.dataAll.pStats.isBorder(handles.choosen.Data));
handles.pStatsTableData(8,8) = max(handles.dataAll.pStats.isInVolume(handles.choosen.Data));
handles.pStatsTableData(9,8) = max(handles.dataAll.pStats.partIsOnBlackList(handles.choosen.Data));
handles.pStatsTableData(10,8) = max(handles.dataAll.pStats.partIsReal(handles.choosen.Data));

handles.pStatsTableData(11,8) = max(handles.dataAll.pStats.minPh(handles.choosen.Data));
handles.pStatsTableData(12,8) = max(handles.dataAll.pStats.maxPh(handles.choosen.Data));
handles.pStatsTableData(13,8) = max(handles.dataAll.pStats.minAmp(handles.choosen.Data));
handles.pStatsTableData(14,8) = max(handles.dataAll.pStats.maxAmp(handles.choosen.Data));

handles.pStatsTableData(15,8) = max(handles.dataAll.pStats.imDiamMean(handles.choosen.Data));
handles.pStatsTableData(16,8) = max(handles.dataAll.pStats.pDiamOldThresh(handles.choosen.Data));
handles.pStatsTableData(17,8) = max(handles.dataAll.pStats.imEquivDia(handles.choosen.Data));
handles.pStatsTableData(18,8) = max(handles.dataAll.pStats.imMeanRadii(handles.choosen.Data));

handles.pStatsTableData(19,8) = max(handles.dataAll.pStats.imStdRadii(handles.choosen.Data));
handles.pStatsTableData(20,8) = max(handles.dataAll.pStats.imStdAngles(handles.choosen.Data));
handles.pStatsTableData(21,8) = max(handles.dataAll.pStats.imPerimRatio(handles.choosen.Data));
handles.pStatsTableData(22,8) = max(handles.dataAll.pStats.imEccentricity(handles.choosen.Data));
handles.pStatsTableData(23,8) = max(handles.dataAll.pStats.imSolidity(handles.choosen.Data));

handles.pStatsTableData(1,2) = nan;
handles.pStatsTableData(2,2) = nanmean(handles.dataAll.pStats.xPos(handles.choosen.Data));
handles.pStatsTableData(3,2) = nanmean(handles.dataAll.pStats.yPos(handles.choosen.Data));
handles.pStatsTableData(4,2) = nanmean(handles.dataAll.pStats.zPos(handles.choosen.Data));
handles.pStatsTableData(5,2) = nanmean(handles.dataAll.pStats.imXPos(handles.choosen.Data));
handles.pStatsTableData(6,2) = nanmean(handles.dataAll.pStats.imYPos(handles.choosen.Data));

handles.pStatsTableData(7,2) = nanmean(handles.dataAll.pStats.isBorder(handles.choosen.Data));
handles.pStatsTableData(8,2) = nanmean(handles.dataAll.pStats.isInVolume(handles.choosen.Data));
handles.pStatsTableData(9,2) = nanmean(handles.dataAll.pStats.partIsOnBlackList(handles.choosen.Data));
handles.pStatsTableData(10,2) = nanmean(handles.dataAll.pStats.partIsReal(handles.choosen.Data));

handles.pStatsTableData(11,2) = nanmean(handles.dataAll.pStats.minPh(handles.choosen.Data));
handles.pStatsTableData(12,2) = nanmean(handles.dataAll.pStats.maxPh(handles.choosen.Data));
handles.pStatsTableData(13,2) = nanmean(handles.dataAll.pStats.minAmp(handles.choosen.Data));
handles.pStatsTableData(14,2) = nanmean(handles.dataAll.pStats.maxAmp(handles.choosen.Data));

handles.pStatsTableData(15,2) = nanmean(handles.dataAll.pStats.imDiamMean(handles.choosen.Data));
handles.pStatsTableData(16,2) = nanmean(handles.dataAll.pStats.pDiamOldThresh(handles.choosen.Data));
handles.pStatsTableData(17,2) = nanmean(handles.dataAll.pStats.imEquivDia(handles.choosen.Data));
handles.pStatsTableData(18,2) = nanmean(handles.dataAll.pStats.imMeanRadii(handles.choosen.Data));

handles.pStatsTableData(19,2) = nanmean(handles.dataAll.pStats.imStdRadii(handles.choosen.Data));
handles.pStatsTableData(20,2) = nanmean(handles.dataAll.pStats.imStdAngles(handles.choosen.Data));
handles.pStatsTableData(21,2) = nanmean(handles.dataAll.pStats.imPerimRatio(handles.choosen.Data));
handles.pStatsTableData(22,2) = nanmean(handles.dataAll.pStats.imEccentricity(handles.choosen.Data));
handles.pStatsTableData(23,2) = nanmean(handles.dataAll.pStats.imSolidity(handles.choosen.Data));

handles = updatePStatsTableData(handles);




function handles = updatePStatsTableData(handles)
handles.pStatsTableData(1,1) = handles.cntParticle;
handles.pStatsTableData(2,1) = handles.dataAll.pStats.xPos(handles.cntParticleAll);
handles.pStatsTableData(3,1) = handles.dataAll.pStats.yPos(handles.cntParticleAll);
handles.pStatsTableData(4,1) = handles.dataAll.pStats.zPos(handles.cntParticleAll);
handles.pStatsTableData(5,1) = handles.dataAll.pStats.imXPos(handles.cntParticleAll);
handles.pStatsTableData(6,1) = handles.dataAll.pStats.imYPos(handles.cntParticleAll);

handles.pStatsTableData(7,1) = handles.dataAll.pStats.isBorder(handles.cntParticleAll);
handles.pStatsTableData(8,1) = handles.dataAll.pStats.isInVolume(handles.cntParticleAll);
handles.pStatsTableData(9,1) = handles.dataAll.pStats.partIsOnBlackList(handles.cntParticleAll);
handles.pStatsTableData(10,1) = handles.dataAll.pStats.partIsReal(handles.cntParticleAll);

handles.pStatsTableData(11,1) = handles.dataAll.pStats.minPh(handles.cntParticleAll);
handles.pStatsTableData(12,1) = handles.dataAll.pStats.maxPh(handles.cntParticleAll);
handles.pStatsTableData(13,1) = handles.dataAll.pStats.minAmp(handles.cntParticleAll);
handles.pStatsTableData(14,1) = handles.dataAll.pStats.maxAmp(handles.cntParticleAll);

handles.pStatsTableData(15,1) = handles.dataAll.pStats.imDiamMean(handles.cntParticleAll);
handles.pStatsTableData(16,1) = handles.dataAll.pStats.pDiamOldThresh(handles.cntParticleAll);
handles.pStatsTableData(17,1) = handles.dataAll.pStats.imEquivDia(handles.cntParticleAll);
handles.pStatsTableData(18,1) = handles.dataAll.pStats.imMeanRadii(handles.cntParticleAll);

handles.pStatsTableData(19,1) = handles.dataAll.pStats.imStdRadii(handles.cntParticleAll);
handles.pStatsTableData(20,1) = handles.dataAll.pStats.imStdAngles(handles.cntParticleAll);
handles.pStatsTableData(21,1) = handles.dataAll.pStats.imPerimRatio(handles.cntParticleAll);
handles.pStatsTableData(22,1) = handles.dataAll.pStats.imEccentricity(handles.cntParticleAll);
handles.pStatsTableData(23,1) = handles.dataAll.pStats.imSolidity(handles.cntParticleAll);

if sum(handles.isWater)~=0
    handles.pStatsTableData(1,3) = sum(handles.isWater & handles.choosen.Data);
    
    handles.pStatsTableData(2,3) = nanmean(handles.dataAll.pStats.xPos(handles.isWater & handles.choosen.Data));
    handles.pStatsTableData(3,3) = nanmean(handles.dataAll.pStats.yPos(handles.isWater & handles.choosen.Data));
    handles.pStatsTableData(4,3) = nanmean(handles.dataAll.pStats.zPos(handles.isWater & handles.choosen.Data));
    handles.pStatsTableData(5,3) = nanmean(handles.dataAll.pStats.imXPos(handles.isWater & handles.choosen.Data));
    handles.pStatsTableData(6,3) = nanmean(handles.dataAll.pStats.imYPos(handles.isWater & handles.choosen.Data));
    
    handles.pStatsTableData(7,3) = nanmean(handles.dataAll.pStats.isBorder(handles.isWater & handles.choosen.Data));
    handles.pStatsTableData(8,3) = nanmean(handles.dataAll.pStats.isInVolume(handles.isWater & handles.choosen.Data));
    handles.pStatsTableData(9,3) = nanmean(handles.dataAll.pStats.partIsOnBlackList(handles.isWater & handles.choosen.Data));
    handles.pStatsTableData(10,3) = nanmean(handles.dataAll.pStats.partIsReal(handles.isWater & handles.choosen.Data));
    
    handles.pStatsTableData(11,3) = nanmean(handles.dataAll.pStats.minPh(handles.isWater & handles.choosen.Data));
    handles.pStatsTableData(12,3) = nanmean(handles.dataAll.pStats.maxPh(handles.isWater & handles.choosen.Data));
    handles.pStatsTableData(13,3) = nanmean(handles.dataAll.pStats.minAmp(handles.isWater & handles.choosen.Data));
    handles.pStatsTableData(14,3) = nanmean(handles.dataAll.pStats.maxAmp(handles.isWater & handles.choosen.Data));
    
    handles.pStatsTableData(15,3) = nanmean(handles.dataAll.pStats.imDiamMean(handles.isWater & handles.choosen.Data));
    handles.pStatsTableData(16,3) = nanmean(handles.dataAll.pStats.pDiamOldThresh(handles.isWater & handles.choosen.Data));
    handles.pStatsTableData(17,3) = nanmean(handles.dataAll.pStats.imEquivDia(handles.isWater & handles.choosen.Data));
    handles.pStatsTableData(18,3) = nanmean(handles.dataAll.pStats.imMeanRadii(handles.isWater & handles.choosen.Data));
    
    handles.pStatsTableData(19,3) = nanmean(handles.dataAll.pStats.imStdRadii(handles.isWater & handles.choosen.Data));
    handles.pStatsTableData(20,3) = nanmean(handles.dataAll.pStats.imStdAngles(handles.isWater & handles.choosen.Data));
    handles.pStatsTableData(21,3) = nanmean(handles.dataAll.pStats.imPerimRatio(handles.isWater & handles.choosen.Data));
    handles.pStatsTableData(22,3) = nanmean(handles.dataAll.pStats.imEccentricity(handles.isWater & handles.choosen.Data));
    handles.pStatsTableData(23,3) = nanmean(handles.dataAll.pStats.imSolidity(handles.isWater & handles.choosen.Data));
end

if sum(handles.isIce)~=0
    handles.pStatsTableData(1,4) = sum(handles.isIce & handles.choosen.Data);
    
    handles.pStatsTableData(2,4) = nanmean(handles.dataAll.pStats.xPos(handles.isIce & handles.choosen.Data));
    handles.pStatsTableData(3,4) = nanmean(handles.dataAll.pStats.yPos(handles.isIce & handles.choosen.Data));
    handles.pStatsTableData(4,4) = nanmean(handles.dataAll.pStats.zPos(handles.isIce & handles.choosen.Data));
    handles.pStatsTableData(5,4) = nanmean(handles.dataAll.pStats.imXPos(handles.isIce & handles.choosen.Data));
    handles.pStatsTableData(6,4) = nanmean(handles.dataAll.pStats.imYPos(handles.isIce & handles.choosen.Data));
    
    handles.pStatsTableData(7,4) = nanmean(handles.dataAll.pStats.isBorder(handles.isIce & handles.choosen.Data));
    handles.pStatsTableData(8,4) = nanmean(handles.dataAll.pStats.isInVolume(handles.isIce & handles.choosen.Data));
    handles.pStatsTableData(9,4) = nanmean(handles.dataAll.pStats.partIsOnBlackList(handles.isIce & handles.choosen.Data));
    handles.pStatsTableData(10,4) = nanmean(handles.dataAll.pStats.partIsReal(handles.isIce & handles.choosen.Data));
    
    handles.pStatsTableData(11,4) = nanmean(handles.dataAll.pStats.minPh(handles.isIce & handles.choosen.Data));
    handles.pStatsTableData(12,4) = nanmean(handles.dataAll.pStats.maxPh(handles.isIce & handles.choosen.Data));
    handles.pStatsTableData(13,4) = nanmean(handles.dataAll.pStats.minAmp(handles.isIce & handles.choosen.Data));
    handles.pStatsTableData(14,4) = nanmean(handles.dataAll.pStats.maxAmp(handles.isIce & handles.choosen.Data));
    
    handles.pStatsTableData(15,4) = nanmean(handles.dataAll.pStats.imDiamMean(handles.isIce & handles.choosen.Data));
    handles.pStatsTableData(16,4) = nanmean(handles.dataAll.pStats.pDiamOldThresh(handles.isIce & handles.choosen.Data));
    handles.pStatsTableData(17,4) = nanmean(handles.dataAll.pStats.imEquivDia(handles.isIce & handles.choosen.Data));
    handles.pStatsTableData(18,4) = nanmean(handles.dataAll.pStats.imMeanRadii(handles.isIce & handles.choosen.Data));
    
    handles.pStatsTableData(19,4) = nanmean(handles.dataAll.pStats.imStdRadii(handles.isIce & handles.choosen.Data));
    handles.pStatsTableData(20,4) = nanmean(handles.dataAll.pStats.imStdAngles(handles.isIce & handles.choosen.Data));
    handles.pStatsTableData(21,4) = nanmean(handles.dataAll.pStats.imPerimRatio(handles.isIce & handles.choosen.Data));
    handles.pStatsTableData(22,4) = nanmean(handles.dataAll.pStats.imEccentricity(handles.isIce & handles.choosen.Data));
    handles.pStatsTableData(23,4) = nanmean(handles.dataAll.pStats.imSolidity(handles.isIce & handles.choosen.Data));
end

if sum(handles.isArtefact)~=0
    handles.pStatsTableData(1,5) =  sum(handles.isArtefact & handles.choosen.Data);
    
    handles.pStatsTableData(2,5) = nanmean(handles.dataAll.pStats.xPos(handles.isArtefact & handles.choosen.Data));
    handles.pStatsTableData(3,5) = nanmean(handles.dataAll.pStats.yPos(handles.isArtefact & handles.choosen.Data));
    handles.pStatsTableData(4,5) = nanmean(handles.dataAll.pStats.zPos(handles.isArtefact & handles.choosen.Data));
    handles.pStatsTableData(5,5) = nanmean(handles.dataAll.pStats.imXPos(handles.isArtefact & handles.choosen.Data));
    handles.pStatsTableData(6,5) = nanmean(handles.dataAll.pStats.imYPos(handles.isArtefact & handles.choosen.Data));
    
    handles.pStatsTableData(7,5) = nanmean(handles.dataAll.pStats.isBorder(handles.isArtefact & handles.choosen.Data));
    handles.pStatsTableData(8,5) = nanmean(handles.dataAll.pStats.isInVolume(handles.isArtefact & handles.choosen.Data));
    handles.pStatsTableData(9,5) = nanmean(handles.dataAll.pStats.partIsOnBlackList(handles.isArtefact & handles.choosen.Data));
    handles.pStatsTableData(10,5) = nanmean(handles.dataAll.pStats.partIsReal(handles.isArtefact & handles.choosen.Data));
    
    handles.pStatsTableData(11,5) = nanmean(handles.dataAll.pStats.minPh(handles.isArtefact & handles.choosen.Data));
    handles.pStatsTableData(12,5) = nanmean(handles.dataAll.pStats.maxPh(handles.isArtefact & handles.choosen.Data));
    handles.pStatsTableData(13,5) = nanmean(handles.dataAll.pStats.minAmp(handles.isArtefact & handles.choosen.Data));
    handles.pStatsTableData(14,5) = nanmean(handles.dataAll.pStats.maxAmp(handles.isArtefact & handles.choosen.Data));
    
    handles.pStatsTableData(15,5) = nanmean(handles.dataAll.pStats.imDiamMean(handles.isArtefact & handles.choosen.Data));
    handles.pStatsTableData(16,5) = nanmean(handles.dataAll.pStats.pDiamOldThresh(handles.isArtefact & handles.choosen.Data));
    handles.pStatsTableData(17,5) = nanmean(handles.dataAll.pStats.imEquivDia(handles.isArtefact & handles.choosen.Data));
    handles.pStatsTableData(18,5) = nanmean(handles.dataAll.pStats.imMeanRadii(handles.isArtefact & handles.choosen.Data));
    
    handles.pStatsTableData(19,5) = nanmean(handles.dataAll.pStats.imStdRadii(handles.isArtefact & handles.choosen.Data));
    handles.pStatsTableData(20,5) = nanmean(handles.dataAll.pStats.imStdAngles(handles.isArtefact & handles.choosen.Data));
    handles.pStatsTableData(21,5) = nanmean(handles.dataAll.pStats.imPerimRatio(handles.isArtefact & handles.choosen.Data));
    handles.pStatsTableData(22,5) = nanmean(handles.dataAll.pStats.imEccentricity(handles.isArtefact & handles.choosen.Data));
    handles.pStatsTableData(23,5) = nanmean(handles.dataAll.pStats.imSolidity(handles.isArtefact & handles.choosen.Data));
end

if sum(handles.isUnkown)~=0
    handles.pStatsTableData(1,6) = sum(handles.isUnkown & handles.choosen.Data);
    
    handles.pStatsTableData(2,6) = nanmean(handles.dataAll.pStats.xPos(handles.isUnkown & handles.choosen.Data));
    handles.pStatsTableData(3,6) = nanmean(handles.dataAll.pStats.yPos(handles.isUnkown & handles.choosen.Data));
    handles.pStatsTableData(4,6) = nanmean(handles.dataAll.pStats.zPos(handles.isUnkown & handles.choosen.Data));
    handles.pStatsTableData(5,6) = nanmean(handles.dataAll.pStats.imXPos(handles.isUnkown & handles.choosen.Data));
    handles.pStatsTableData(6,6) = nanmean(handles.dataAll.pStats.imYPos(handles.isUnkown & handles.choosen.Data));
    
    handles.pStatsTableData(7,6) = nanmean(handles.dataAll.pStats.isBorder(handles.isUnkown & handles.choosen.Data));
    handles.pStatsTableData(8,6) = nanmean(handles.dataAll.pStats.isInVolume(handles.isUnkown & handles.choosen.Data));
    handles.pStatsTableData(9,6) = nanmean(handles.dataAll.pStats.partIsOnBlackList(handles.isUnkown & handles.choosen.Data));
    handles.pStatsTableData(10,6) = nanmean(handles.dataAll.pStats.partIsReal(handles.isUnkown & handles.choosen.Data));
    
    handles.pStatsTableData(11,6) = nanmean(handles.dataAll.pStats.minPh(handles.isUnkown & handles.choosen.Data));
    handles.pStatsTableData(12,6) = nanmean(handles.dataAll.pStats.maxPh(handles.isUnkown & handles.choosen.Data));
    handles.pStatsTableData(13,6) = nanmean(handles.dataAll.pStats.minAmp(handles.isUnkown & handles.choosen.Data));
    handles.pStatsTableData(14,6) = nanmean(handles.dataAll.pStats.maxAmp(handles.isUnkown & handles.choosen.Data));
    
    handles.pStatsTableData(15,6) = nanmean(handles.dataAll.pStats.imDiamMean(handles.isUnkown & handles.choosen.Data));
    handles.pStatsTableData(16,6) = nanmean(handles.dataAll.pStats.pDiamOldThresh(handles.isUnkown & handles.choosen.Data));
    handles.pStatsTableData(17,6) = nanmean(handles.dataAll.pStats.imEquivDia(handles.isUnkown & handles.choosen.Data));
    handles.pStatsTableData(18,6) = nanmean(handles.dataAll.pStats.imMeanRadii(handles.isUnkown & handles.choosen.Data));
    
    handles.pStatsTableData(19,6) = nanmean(handles.dataAll.pStats.imStdRadii(handles.isUnkown & handles.choosen.Data));
    handles.pStatsTableData(20,6) = nanmean(handles.dataAll.pStats.imStdAngles(handles.isUnkown & handles.choosen.Data));
    handles.pStatsTableData(21,6) = nanmean(handles.dataAll.pStats.imPerimRatio(handles.isUnkown & handles.choosen.Data));
    handles.pStatsTableData(22,6) = nanmean(handles.dataAll.pStats.imEccentricity(handles.isUnkown & handles.choosen.Data));
    handles.pStatsTableData(23,6) = nanmean(handles.dataAll.pStats.imSolidity(handles.isUnkown & handles.choosen.Data));
end
set(handles.pStatsTable, 'Data', handles.pStatsTableData)
handles = updateArtefactStat(handles);
handles = updatePlotArtefactThScatter(handles);



function minPDiamText_Callback(hObject, eventdata, handles)
% hObject    handle to minPDiamText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.choosen.minPDiam = str2double(get(hObject,'String'));
handles = updateChoosenData(handles);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of minPDiamText as text
%        str2double(get(hObject,'String')) returns contents of minPDiamText as a double


% --- Executes during object creation, after setting all properties.
function minPDiamText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minPDiamText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxPDiamText_Callback(hObject, eventdata, handles)
% hObject    handle to maxPDiamText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.choosen.maxPDiam = str2double(get(hObject,'String'));
handles = updateChoosenData(handles);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of maxPDiamText as text
%        str2double(get(hObject,'String')) returns contents of maxPDiamText as a double


% --- Executes during object creation, after setting all properties.
function maxPDiamText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxPDiamText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in isInVolumeButton.
function isInVolumeButton_Callback(hObject, eventdata, handles)
% hObject    handle to isInVolumeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.choosen.isInVolume = get(hObject,'Value');
handles = updateChoosenData(handles);
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of isInVolumeButton


% --- Executes on button press in isBorderButton.
function isBorderButton_Callback(hObject, eventdata, handles)
% hObject    handle to isBorderButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choosen.isBorder = get(hObject,'Value');
handles = updateChoosenData(handles);
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of isBorderButton


% --- Executes on button press in isOnBlacklistButton.
function isOnBlacklistButton_Callback(hObject, eventdata, handles)
% hObject    handle to isOnBlacklistButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choosen.isOnBlacklist = get(hObject,'Value');
handles = updateChoosenData(handles);
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of isOnBlacklistButton


% --- Executes on button press in isNANpDiamButton.
function isNANpDiamButton_Callback(hObject, eventdata, handles)
% hObject    handle to isNANpDiamButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choosen.isNANpDiam = get(hObject,'Value');
handles = updateChoosenData(handles);
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of isNANpDiamButton


% --- Executes on button press in isNotInVolumeButton.
function isNotInVolumeButton_Callback(hObject, eventdata, handles)
% hObject    handle to isNotInVolumeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choosen.isNotInVolume = get(hObject,'Value');
handles = updateChoosenData(handles);
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of isNotInVolumeButton


% --- Executes on button press in isNotBorderButton.
function isNotBorderButton_Callback(hObject, eventdata, handles)
% hObject    handle to isNotBorderButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choosen.isNotBorder = get(hObject,'Value');
handles = updateChoosenData(handles);
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of isNotBorderButton


% --- Executes on button press in isNotOnBlacklistButton.
function isNotOnBlacklistButton_Callback(hObject, eventdata, handles)
% hObject    handle to isNotOnBlacklistButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choosen.isNotOnBlacklist = get(hObject,'Value');
handles = updateChoosenData(handles);
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of isNotOnBlacklistButton


% --- Executes on button press in isNotNANpDiamButton.
function isNotNANpDiamButton_Callback(hObject, eventdata, handles)
% hObject    handle to isNotNANpDiamButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choosen.isNotNANpDiam = get(hObject,'Value');
handles = updateChoosenData(handles);
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of isNotNANpDiamButton

function handles = createChoosenData(handles)
handles.choosen.minPDiam = 6;
handles.choosen.maxPDiam = 250;
handles.choosen.isInVolume = true;
handles.choosen.isNotInVolume = false;
handles.choosen.isBorder = false;
handles.choosen.isNotBorder = true;
handles.choosen.isOnBlacklist = false;
handles.choosen.isNotOnBlacklist = true;
handles.choosen.isNANpDiam = false;
handles.choosen.isNotNANpDiam = true;
handles.choosen.showWater = true;
handles.choosen.showIce = true;
handles.choosen.showArtefact = true;
handles.choosen.showUnknown = true;
handles.choosen.isFoundArtefact = false;
handles.choosen.isNotFoundArtefact = false;
handles.choosen.minMinAmp = 0;
handles.choosen.maxMinAmp = inf;
handles.choosen.minMaxPh = -pi;
handles.choosen.maxMaxPh = pi;
set(handles.minPDiamText,'String', num2str(handles.choosen.minPDiam,'%u'));
set(handles.maxPDiamText,'String', num2str(handles.choosen.maxPDiam,'%u'));
set(handles.isInVolumeButton,'Value', handles.choosen.isInVolume);
set(handles.isNotInVolumeButton,'Value', handles.choosen.isNotInVolume);
set(handles.isBorderButton,'Value', handles.choosen.isBorder);
set(handles.isNotBorderButton,'Value', handles.choosen.isNotBorder);
set(handles.isOnBlacklistButton,'Value', handles.choosen.isOnBlacklist);
set(handles.isNotOnBlacklistButton,'Value', handles.choosen.isNotOnBlacklist);
set(handles.isNANpDiamButton,'Value', handles.choosen.isNANpDiam);
set(handles.isNotNANpDiamButton,'Value', handles.choosen.isNotNANpDiam);
handles = updateChoosenData(handles);

function handles = updateChoosenData(handles)
handles.choosen.Data = true(1,handles.pNumber);
if handles.choosen.isInVolume
    handles.choosen.Data = handles.choosen.Data & handles.dataAll.pStats.isInVolume;
end
if handles.choosen.isNotInVolume
    handles.choosen.Data = handles.choosen.Data & ~handles.dataAll.pStats.isInVolume;
end
if handles.choosen.isBorder
    handles.choosen.Data = handles.choosen.Data & handles.dataAll.pStats.isBorder;
end
if handles.choosen.isNotBorder
    handles.choosen.Data = handles.choosen.Data & ~handles.dataAll.pStats.isBorder;
end
if handles.choosen.isOnBlacklist
    handles.choosen.Data = handles.choosen.Data & handles.dataAll.pStats.partIsOnBlackList;
end
if handles.choosen.isNotOnBlacklist
    handles.choosen.Data = handles.choosen.Data & ~handles.dataAll.pStats.partIsOnBlackList;
end
if handles.choosen.isNANpDiam
    handles.choosen.Data = handles.choosen.Data & isnan(handles.dataAll.pStats.imDiamMean);
end
if handles.choosen.isNotNANpDiam
    handles.choosen.Data = handles.choosen.Data & ~isnan(handles.dataAll.pStats.imDiamMean);
    handles.choosen.Data = handles.choosen.Data & handles.dataAll.pStats.imDiamMean >= handles.choosen.minPDiam*1e-6 & ...
    handles.dataAll.pStats.imDiamMean <= handles.choosen.maxPDiam*1e-6;
end 
if ~handles.choosen.showWater
    handles.choosen.Data = handles.choosen.Data & ~handles.isWater;
end
if ~handles.choosen.showIce
    handles.choosen.Data = handles.choosen.Data & ~handles.isIce;
end
if ~handles.choosen.showArtefact
    handles.choosen.Data = handles.choosen.Data & ~handles.isArtefact;
end
if ~handles.choosen.showUnknown
    handles.choosen.Data = handles.choosen.Data & ~handles.isUnkown;
end
if handles.choosen.isFoundArtefact
    handles.choosen.Data = handles.choosen.Data & handles.ArtefactStat.isArtefactMaxPh; 
end
if handles.choosen.isNotFoundArtefact
    handles.choosen.Data = handles.choosen.Data & ~handles.ArtefactStat.isArtefactMaxPh; 
end
handles.choosen.Data = handles.choosen.Data & ...
    handles.dataAll.pStats.minAmp >= handles.choosen.minMinAmp;
handles.choosen.Data = handles.choosen.Data & ...
    handles.dataAll.pStats.minAmp <= handles.choosen.maxMinAmp;
handles.choosen.Data = handles.choosen.Data & ...
    handles.dataAll.pStats.maxPh >= handles.choosen.minMaxPh;
handles.choosen.Data = handles.choosen.Data & ...
    handles.dataAll.pStats.maxPh <= handles.choosen.maxMaxPh;

handles.choosen.Ind = find(handles.choosen.Data);
handles.choosen.pNumber = sum(handles.choosen.Data);
if ~handles.choosen.Data(handles.cntParticleAll)
    handles = getNextChoosenImage(handles);
end
handles = updateImage(handles);
handles = updatePStatsTableData(handles);
handles = updateArtefactStat(handles);
handles = updatePlotArtefactThScatter(handles);


% --- Executes during object creation, after setting all properties.
function isNotNANpDiamButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to isNotNANpDiamButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in saveDataButton.
function saveDataButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
outFile = handles.dataAll;
outFile.pStats.isIce = handles.isIce;
outFile.pStats.isWater = handles.isWater;
outFile.pStats.isArtefact = handles.isArtefact;
outFile.pStats.isUnkown = handles.isUnkown;
save(['Class-' handles.ParInfoFiles], 'outFile');



function handles = goParNrText_Callback(hObject, eventdata, handles)
% hObject    handle to goParNrText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.cntParticle = str2double(get(hObject,'String'));
handles.cntParticleAll = handles.choosen.Ind(handles.cntParticle);
handles = updateImage(handles);
handles = updatePStatsTableData(handles);
% Hints: get(hObject,'String') returns contents of goParNrText as text
%        str2double(get(hObject,'String')) returns contents of goParNrText as a double


% --- Executes during object creation, after setting all properties.
function goParNrText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to goParNrText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function handles = minAmpThText_Callback(hObject, eventdata, handles)
% hObject    handle to minAmpThText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ArtefactStat.minAmpTh = str2double(get(hObject,'String'));
handles = updateArtefactStat(handles);
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of minAmpThText as text
%        str2double(get(hObject,'String')) returns contents of minAmpThText as a double


% --- Executes during object creation, after setting all properties.
function minAmpThText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minAmpThText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function handles = maxPhaseThText_Callback(hObject, eventdata, handles)
% hObject    handle to maxPhaseThText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ArtefactStat.maxPhTh = str2double(get(hObject,'String'));
handles = updateArtefactStat(handles);
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of maxPhaseThText as text
%        str2double(get(hObject,'String')) returns contents of maxPhaseThText as a double


% --- Executes during object creation, after setting all properties.
function maxPhaseThText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxPhaseThText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function handles = createArtefactStat(handles)
set(handles.minAmpThText,'String', num2str(handles.ArtefactStat.minAmpTh,'%4.2f'));
set(handles.maxPhaseThText,'String', num2str(handles.ArtefactStat.maxPhTh,'%4.2f'));


function handles = updateArtefactStat(handles)
handles.ArtefactStat.isArtefactMinAmp = handles.dataAll.pStats.minAmp ...
    > handles.ArtefactStat.minAmpTh;
handles.ArtefactStat.isArtefactMaxPh = handles.dataAll.pStats.maxPh ...
    < handles.ArtefactStat.maxPhTh;
handles.ArtefactStat.isArtefact = handles.ArtefactStat.isArtefactMinAmp | ...
    handles.ArtefactStat.isArtefactMaxPh;

if handles.ArtefactStat.isArtefactMinAmp(handles.cntParticleAll)
    set(handles.ArtefactMinAmpText,'BackgroundColor','r');
    set(handles.parMinAmpText,'BackgroundColor','r');
else
    set(handles.ArtefactMinAmpText,'BackgroundColor','g');
    set(handles.parMinAmpText,'BackgroundColor','g');
end
if handles.ArtefactStat.isArtefactMaxPh(handles.cntParticleAll)
    set(handles.ArtefactMaxPhaseText,'BackgroundColor','r');
    set(handles.parMaxPhText,'BackgroundColor','r');
else
    set(handles.ArtefactMaxPhaseText,'BackgroundColor','g');
    set(handles.parMaxPhText,'BackgroundColor','g');
end
if handles.ArtefactStat.isArtefact(handles.cntParticleAll)
    set(handles.ArtefactText,'BackgroundColor','r');
else
   set(handles.ArtefactText,'BackgroundColor','g');
end
set(handles.parMinAmpText,'String',...
    num2str(handles.dataAll.pStats.minAmp(handles.cntParticleAll),'%4.2f'));
set(handles.parMaxPhText,'String',...
    num2str(handles.dataAll.pStats.maxPh(handles.cntParticleAll),'%4.2f'))


% --- Executes on button press in showWaterButton.
function showWaterButton_Callback(hObject, eventdata, handles)
% hObject    handle to showWaterButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choosen.showWater = get(hObject,'Value');
handles = updateChoosenData(handles);
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of showWaterButton


% --- Executes on button press in showIceButton.
function showIceButton_Callback(hObject, eventdata, handles)
% hObject    handle to showIceButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choosen.showIce = get(hObject,'Value');
handles = updateChoosenData(handles);
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of showIceButton


% --- Executes on button press in showUnknownButton.
function showUnknownButton_Callback(hObject, eventdata, handles)
% hObject    handle to showUnknownButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choosen.showUnknown = get(hObject,'Value');
handles = updateChoosenData(handles);
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of showUnknownButton


% --- Executes on button press in showArtefactButton.
function showArtefactButton_Callback(hObject, eventdata, handles)
% hObject    handle to showArtefactButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choosen.showArtefact = get(hObject,'Value');
handles = updateChoosenData(handles);
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of showArtefactButton


% --- Executes on button press in foundArtefactButton.
function foundArtefactButton_Callback(hObject, eventdata, handles)
% hObject    handle to foundArtefactButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choosen.isFoundArtefact = get(hObject,'Value');
handles = updateChoosenData(handles);
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of foundArtefactButton


% --- Executes on button press in foundNotArtefactButton.
function foundNotArtefactButton_Callback(hObject, eventdata, handles)
% hObject    handle to foundNotArtefactButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choosen.isNotFoundArtefact = get(hObject,'Value');
handles = updateChoosenData(handles);
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of foundNotArtefactButton



function minMinAmpText_Callback(hObject, eventdata, handles)
% hObject    handle to minMinAmpText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choosen.minMinAmp = str2double(get(hObject,'String'));
handles = updateChoosenData(handles);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of minMinAmpText as text
%        str2double(get(hObject,'String')) returns contents of minMinAmpText as a double


% --- Executes during object creation, after setting all properties.
function minMinAmpText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minMinAmpText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxMinAmpText_Callback(hObject, eventdata, handles)
% hObject    handle to maxMinAmpText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choosen.maxMinAmp = str2double(get(hObject,'String'));
handles = updateChoosenData(handles);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of maxMinAmpText as text
%        str2double(get(hObject,'String')) returns contents of maxMinAmpText as a double


% --- Executes during object creation, after setting all properties.
function maxMinAmpText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxMinAmpText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function minMaxPhText_Callback(hObject, eventdata, handles)
% hObject    handle to minMaxPhText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choosen.minMaxPh = str2double(get(hObject,'String'));
handles = updateChoosenData(handles);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of minMaxPhText as text
%        str2double(get(hObject,'String')) returns contents of minMaxPhText as a double


% --- Executes during object creation, after setting all properties.
function minMaxPhText_CreateFcn(hObject, ~, handles)
% hObject    handle to minMaxPhText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxMaxPhText_Callback(hObject, eventdata, handles)
% hObject    handle to maxMaxPhText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choosen.maxMaxPh = str2double(get(hObject,'String'));
handles = updateChoosenData(handles);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of maxMaxPhText as text
%        str2double(get(hObject,'String')) returns contents of maxMaxPhText as a double


% --- Executes during object creation, after setting all properties.
function maxMaxPhText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxMaxPhText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function handles = updatePlotArtefactThScatter(handles)
classes = handles.isIce + handles.isWater*2 + handles.isArtefact*3 + handles.isUnkown*4;
classNames = {'notSpez';'Ice';'Water';'Artefact';'Unknown'};
classesNew = nominal(classes, classNames, [0 1 2 3 4]);
varNames = {'minPh';'maxPh';'minAmp';'maxAmp';'pDiam'};
set(gcf,'CurrentAxes', handles.axesArtefactThScatter);
gca
gscatter(handles.dataAll.pStats.minAmp(handles.choosen.Data),...
    handles.dataAll.pStats.maxPh(handles.choosen.Data),...
    classesNew(handles.choosen.Data));
hold on;
rectangle('Position',[handles.ArtefactStat.minAmpTh 0 1-handles.ArtefactStat.minAmpTh handles.ArtefactStat.maxPhTh]);
set( gca, 'xlim',[0 1], 'ylim', [0 pi]);