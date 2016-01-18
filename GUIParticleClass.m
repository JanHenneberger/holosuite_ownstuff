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

% Last Modified by GUIDE v2.5 01-Nov-2013 16:54:00

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
    if numel(varargin) == 2
        handles.tree = load(varargin{2});
        handles.tree = handles.tree.treeFile;
    else
        handles.tree = load('Z:\6_Auswertung\ALL\ClassificatonTreeNeu.mat');
        %handles.tree = load('F:\CLACE2013\All\AsFiles\ClassificatonTreeNeu.mat');
        handles.tree = handles.tree.treeFile;
    end
end
handles.dataAll = load(handles.ParInfoFiles);
handles.dataAll = handles.dataAll.outFile;

handles.pNumber = numel(handles.dataAll.pStats.pDiamOldThresh);
handles.cntParticle = 1;
handles.cntParticleAll = 1;
if ~isfield(handles.dataAll.pStats,'pDiamMean')
    handles.dataAll.pStats.pDiamMean = ...
        nanmean([handles.dataAll.pStats.pDiam; handles.dataAll.pStats.imEquivDiaOldSizes]);
end
if isfield(handles.dataAll.pStats,'parClass')
    handles.parClass = handles.dataAll.pStats.parClass;
else
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
    classNames = {'notSpez';'Ice';'Water';'Artefact';'Aggregation'; 'Unknown'};
    handles.parClass = nominal(classes, classNames, [0 1 2 3 5 4]);
    handles = rmfield(handles,{'isIce','isWater','isArtefact','isUnkown'});
end
handles.ArtefactStat.minAmpTh = 0.25;
handles.ArtefactStat.maxPhTh = 1.2;
handles = createArtefactStat(handles);

handles = createChoosenData(handles);
colormap('bone')
handles = createPStatsTable(handles);


handles = updateImage(handles);
handles = updateChoosenData(handles);
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

handles.parClass(handles.cntParticleAll) = 'Unknown';
handles = getNextParImage(handles);
handles = updatePStatsTableData(handles);

guidata(hObject,handles)


% --- Executes on button press in ButtonIce.
function ButtonIce_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonIce (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.parClass(handles.cntParticleAll) = 'Ice';
handles = getNextParImage(handles);
handles = updatePStatsTableData(handles);

guidata(hObject,handles)

% --- Executes on button press in ButtonWater.
function ButtonWater_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonWater (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.parClass(handles.cntParticleAll) = 'Water';
handles = getNextParImage(handles);
handles = updatePStatsTableData(handles);

guidata(hObject,handles)

% --- Executes on button press in ButtonArtefact.
function ButtonArtefact_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonArtefact (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.parClass(handles.cntParticleAll) = 'Artefact';
handles = getNextParImage(handles);
handles = updatePStatsTableData(handles);

guidata(hObject,handles)

% --- Executes on button press in ButtonAggregation.
function ButtonAggregation_Callback(hObject, eventdata, handles)
% hObject    handle to ButtonAggregation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.parClass(handles.cntParticleAll) = 'Aggregation';
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
handles = getpImage(handles);
handles = updateBackgroundColor(handles);
handles = updatePStatsTableData(handles);
set(handles.textParNr,'String',['Particle Nr.: ' num2str(handles.cntParticleAll,'%06u')]);
set(gcf,'CurrentAxes', handles.ParticleImageAmp);
imagesc(handles.pImageAbs);
set(gcf,'CurrentAxes', handles.ParticleImagePh);
imagesc(handles.pImagePh);

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

function handles  = getpImage(handles)
handles.choosen.Ind;
handles.pImage = cell2mat(handles.dataAll.pStats.pImage(handles.cntParticleAll));
handles.pImageAbs = abs(handles.pImage);
handles.pImageAbs = handles.pImageAbs - min(min(handles.pImageAbs));
handles.pImageAbs = handles.pImageAbs / max(max(handles.pImageAbs));
handles.pImagePh = angle(handles.pImage);


function handles = updateBackgroundColor(handles)
if handles.parClass(handles.cntParticleAll)  ~= 'Unknown';
    set(handles.ButtonUnkown, 'BackgroundColor','w')
else
    set(handles.ButtonUnkown, 'BackgroundColor','r')
end
if handles.parClass(handles.cntParticleAll)  ~= 'Ice';
    set(handles.ButtonIce, 'BackgroundColor','w')
else
    set(handles.ButtonIce, 'BackgroundColor','g')
end
if handles.parClass(handles.cntParticleAll)  ~= 'Water';
    set(handles.ButtonWater, 'BackgroundColor','w')
else
    set(handles.ButtonWater, 'BackgroundColor','g')
end
if handles.parClass(handles.cntParticleAll)  ~= 'Artefact';
    set(handles.ButtonArtefact, 'BackgroundColor','w')
else
    set(handles.ButtonArtefact, 'BackgroundColor','r')
end

if isfield(handles.dataAll.pStats, 'predictedClass');
    set(handles.foundClassText, 'String', ...
        char(handles.dataAll.pStats.predictedClass(handles.cntParticleAll)));    
end
if isfield(handles.dataAll.pStats, 'predictedHClass');
    set(handles.foundHClassText, 'String', ...
        char(handles.dataAll.pStats.predictedHClass(handles.cntParticleAll)));    
end

function handles = createPStatsTable(handles)
columnname = {'Current','Mean All','Mean Water','Mean Ice','Mean Artefact','Mean Unkown','Min','Max'};
set(handles.pStatsTable, 'ColumnName', columnname);
rownname = {'Nr.','xPos','yPos','zPos','imXPos','imYPos',...
    'isBorder','isInVolume','inOnBlacklist','isReal',...
    'minPh','maxPh','minAmp','maxAmp',...
    'pDiam', 'pDiamTh','imEquivDia','imMeanRadii',...
    'imStdRadii','imStdAngles','imPerimRatio',...
    'imEccentricity','imSolidity',...
    'rtDp', 'rtBSlope', 'rtSignal', 'rtGoodFit', 'rtAsym',...
    'pStats.rtCenterx', 'pStats.rtCentery', 'rtXPos', 'rtYPos'    
    };    
set(handles.pStatsTable, 'RowName', rownname);
handles.pStatsTableData(1,7) = 1;
handles.pStatsTableData(2,7) = min(handles.dataAll.pStats.xPos(handles.choosen.Data))*1e6;
handles.pStatsTableData(3,7) = min(handles.dataAll.pStats.yPos(handles.choosen.Data))*1e6;
handles.pStatsTableData(4,7) = min(handles.dataAll.pStats.zPos(handles.choosen.Data))*1e3;
handles.pStatsTableData(5,7) = min(handles.dataAll.pStats.imXPos(handles.choosen.Data))*1e6;
handles.pStatsTableData(6,7) = min(handles.dataAll.pStats.imYPos(handles.choosen.Data))*1e6;

handles.pStatsTableData(7,7) = min(handles.dataAll.pStats.isBorder(handles.choosen.Data));
handles.pStatsTableData(8,7) = min(handles.dataAll.pStats.isInVolume(handles.choosen.Data));
handles.pStatsTableData(9,7) = min(handles.dataAll.pStats.partIsOnBlackList(handles.choosen.Data));
handles.pStatsTableData(10,7) = min(handles.dataAll.pStats.partIsReal(handles.choosen.Data));

handles.pStatsTableData(11,7) = min(handles.dataAll.pStats.minPh(handles.choosen.Data));
handles.pStatsTableData(12,7) = min(handles.dataAll.pStats.maxPh(handles.choosen.Data));
handles.pStatsTableData(13,7) = min(handles.dataAll.pStats.minAmp(handles.choosen.Data));
handles.pStatsTableData(14,7) = min(handles.dataAll.pStats.maxAmp(handles.choosen.Data));

handles.pStatsTableData(15,7) = min(handles.dataAll.pStats.pDiamMean(handles.choosen.Data))*1e6;
handles.pStatsTableData(16,7) = min(handles.dataAll.pStats.pDiamOldThresh(handles.choosen.Data))*1e6;
handles.pStatsTableData(17,7) = min(handles.dataAll.pStats.imEquivDiaOldSizes(handles.choosen.Data))*1e6;
handles.pStatsTableData(18,7) = min(handles.dataAll.pStats.imMeanRadii(handles.choosen.Data))*1e6;

handles.pStatsTableData(19,7) = min(handles.dataAll.pStats.imStdRadii(handles.choosen.Data))*1e6;
handles.pStatsTableData(20,7) = min(handles.dataAll.pStats.imStdAngles(handles.choosen.Data));
handles.pStatsTableData(21,7) = min(handles.dataAll.pStats.imPerimRatio(handles.choosen.Data));
handles.pStatsTableData(22,7) = min(handles.dataAll.pStats.imEccentricity(handles.choosen.Data));
handles.pStatsTableData(23,7) = min(handles.dataAll.pStats.imSolidity(handles.choosen.Data));

handles.pStatsTableData(24,7) = min(handles.dataAll.pStats.rtDp(handles.choosen.Data))*1e6;
handles.pStatsTableData(25,7) = min(handles.dataAll.pStats.rtBSlope(handles.choosen.Data))*1e6;
handles.pStatsTableData(26,7) = min(handles.dataAll.pStats.rtSignal(handles.choosen.Data))*1e12;
handles.pStatsTableData(27,7) = min(handles.dataAll.pStats.rtGoodFit(handles.choosen.Data));
handles.pStatsTableData(28,7) = min(handles.dataAll.pStats.rtAsym(handles.choosen.Data));
handles.pStatsTableData(29,7) = min(handles.dataAll.pStats.rtCenterx(handles.choosen.Data));
handles.pStatsTableData(30,7) = min(handles.dataAll.pStats.rtCentery(handles.choosen.Data));
handles.pStatsTableData(31,7) = min(handles.dataAll.pStats.rtXPos(handles.choosen.Data));
handles.pStatsTableData(32,7) = min(handles.dataAll.pStats.rtYPos(handles.choosen.Data));

handles.pStatsTableData(1,8) = handles.pNumber;
handles.pStatsTableData(2,8) = max(handles.dataAll.pStats.xPos(handles.choosen.Data))*1e6;
handles.pStatsTableData(3,8) = max(handles.dataAll.pStats.yPos(handles.choosen.Data))*1e6;
handles.pStatsTableData(4,8) = max(handles.dataAll.pStats.zPos(handles.choosen.Data))*1e3;
handles.pStatsTableData(5,8) = max(handles.dataAll.pStats.imXPos(handles.choosen.Data))*1e6;
handles.pStatsTableData(6,8) = max(handles.dataAll.pStats.imYPos(handles.choosen.Data))*1e6;

handles.pStatsTableData(7,8) = max(handles.dataAll.pStats.isBorder(handles.choosen.Data));
handles.pStatsTableData(8,8) = max(handles.dataAll.pStats.isInVolume(handles.choosen.Data));
handles.pStatsTableData(9,8) = max(handles.dataAll.pStats.partIsOnBlackList(handles.choosen.Data));
handles.pStatsTableData(10,8) = max(handles.dataAll.pStats.partIsReal(handles.choosen.Data));

handles.pStatsTableData(11,8) = max(handles.dataAll.pStats.minPh(handles.choosen.Data));
handles.pStatsTableData(12,8) = max(handles.dataAll.pStats.maxPh(handles.choosen.Data));
handles.pStatsTableData(13,8) = max(handles.dataAll.pStats.minAmp(handles.choosen.Data));
handles.pStatsTableData(14,8) = max(handles.dataAll.pStats.maxAmp(handles.choosen.Data));

handles.pStatsTableData(15,8) = max(handles.dataAll.pStats.pDiamMean(handles.choosen.Data))*1e6;
handles.pStatsTableData(16,8) = max(handles.dataAll.pStats.pDiamOldThresh(handles.choosen.Data))*1e6;
handles.pStatsTableData(17,8) = max(handles.dataAll.pStats.imEquivDiaOldSizes(handles.choosen.Data))*1e6;
handles.pStatsTableData(18,8) = max(handles.dataAll.pStats.imMeanRadii(handles.choosen.Data))*1e6;

handles.pStatsTableData(19,8) = max(handles.dataAll.pStats.imStdRadii(handles.choosen.Data))*1e6;
handles.pStatsTableData(20,8) = max(handles.dataAll.pStats.imStdAngles(handles.choosen.Data));
handles.pStatsTableData(21,8) = max(handles.dataAll.pStats.imPerimRatio(handles.choosen.Data));
handles.pStatsTableData(22,8) = max(handles.dataAll.pStats.imEccentricity(handles.choosen.Data));
handles.pStatsTableData(23,8) = max(handles.dataAll.pStats.imSolidity(handles.choosen.Data));

handles.pStatsTableData(24,8) = max(handles.dataAll.pStats.rtDp(handles.choosen.Data))*1e6;
handles.pStatsTableData(25,8) = max(handles.dataAll.pStats.rtBSlope(handles.choosen.Data))*1e6;
handles.pStatsTableData(26,8) = max(handles.dataAll.pStats.rtSignal(handles.choosen.Data))*1e12;
handles.pStatsTableData(27,8) = max(handles.dataAll.pStats.rtGoodFit(handles.choosen.Data));
handles.pStatsTableData(28,8) = max(handles.dataAll.pStats.rtAsym(handles.choosen.Data));
handles.pStatsTableData(29,8) = max(handles.dataAll.pStats.rtCenterx(handles.choosen.Data));
handles.pStatsTableData(30,8) = max(handles.dataAll.pStats.rtCentery(handles.choosen.Data));
handles.pStatsTableData(31,8) = max(handles.dataAll.pStats.rtXPos(handles.choosen.Data));
handles.pStatsTableData(32,8) = max(handles.dataAll.pStats.rtYPos(handles.choosen.Data));


handles.pStatsTableData(1,2) = nan;
handles.pStatsTableData(2,2) = nanmean(handles.dataAll.pStats.xPos(handles.choosen.Data))*1e6;
handles.pStatsTableData(3,2) = nanmean(handles.dataAll.pStats.yPos(handles.choosen.Data))*1e6;
handles.pStatsTableData(4,2) = nanmean(handles.dataAll.pStats.zPos(handles.choosen.Data))*1e3;
handles.pStatsTableData(5,2) = nanmean(handles.dataAll.pStats.imXPos(handles.choosen.Data))*1e6;
handles.pStatsTableData(6,2) = nanmean(handles.dataAll.pStats.imYPos(handles.choosen.Data))*1e6;

handles.pStatsTableData(7,2) = nanmean(handles.dataAll.pStats.isBorder(handles.choosen.Data));
handles.pStatsTableData(8,2) = nanmean(handles.dataAll.pStats.isInVolume(handles.choosen.Data));
handles.pStatsTableData(9,2) = nanmean(handles.dataAll.pStats.partIsOnBlackList(handles.choosen.Data));
handles.pStatsTableData(10,2) = nanmean(handles.dataAll.pStats.partIsReal(handles.choosen.Data));

handles.pStatsTableData(11,2) = nanmean(handles.dataAll.pStats.minPh(handles.choosen.Data));
handles.pStatsTableData(12,2) = nanmean(handles.dataAll.pStats.maxPh(handles.choosen.Data));
handles.pStatsTableData(13,2) = nanmean(handles.dataAll.pStats.minAmp(handles.choosen.Data));
handles.pStatsTableData(14,2) = nanmean(handles.dataAll.pStats.maxAmp(handles.choosen.Data));

handles.pStatsTableData(15,2) = nanmean(handles.dataAll.pStats.pDiamMean(handles.choosen.Data))*1e6;
handles.pStatsTableData(16,2) = nanmean(handles.dataAll.pStats.pDiamOldThresh(handles.choosen.Data))*1e6;
handles.pStatsTableData(17,2) = nanmean(handles.dataAll.pStats.imEquivDiaOldSizes(handles.choosen.Data))*1e6;
handles.pStatsTableData(18,2) = nanmean(handles.dataAll.pStats.imMeanRadii(handles.choosen.Data))*1e6;

handles.pStatsTableData(19,2) = nanmean(handles.dataAll.pStats.imStdRadii(handles.choosen.Data))*1e6;
handles.pStatsTableData(20,2) = nanmean(handles.dataAll.pStats.imStdAngles(handles.choosen.Data));
handles.pStatsTableData(21,2) = nanmean(handles.dataAll.pStats.imPerimRatio(handles.choosen.Data));
handles.pStatsTableData(22,2) = nanmean(handles.dataAll.pStats.imEccentricity(handles.choosen.Data));
handles.pStatsTableData(23,2) = nanmean(handles.dataAll.pStats.imSolidity(handles.choosen.Data));

handles.pStatsTableData(24,2) = nanmean(handles.dataAll.pStats.rtDp(handles.choosen.Data))*1e6;
handles.pStatsTableData(25,2) = nanmean(handles.dataAll.pStats.rtBSlope(handles.choosen.Data))*1e6;
handles.pStatsTableData(26,2) = nanmean(handles.dataAll.pStats.rtSignal(handles.choosen.Data))*1e12;
handles.pStatsTableData(27,2) = nanmean(handles.dataAll.pStats.rtGoodFit(handles.choosen.Data));
handles.pStatsTableData(28,2) = nanmean(handles.dataAll.pStats.rtAsym(handles.choosen.Data));
handles.pStatsTableData(29,2) = nanmean(handles.dataAll.pStats.rtCenterx(handles.choosen.Data));
handles.pStatsTableData(30,2) = nanmean(handles.dataAll.pStats.rtCentery(handles.choosen.Data));
handles.pStatsTableData(31,2) = nanmean(handles.dataAll.pStats.rtXPos(handles.choosen.Data));
handles.pStatsTableData(32,2) = nanmean(handles.dataAll.pStats.rtYPos(handles.choosen.Data));

handles = updatePStatsTableData(handles);




function handles = updatePStatsTableData(handles)
handles.pStatsTableData(1,1) = handles.cntParticle;
handles.pStatsTableData(2,1) = handles.dataAll.pStats.xPos(handles.cntParticleAll)*1e6;
handles.pStatsTableData(3,1) = handles.dataAll.pStats.yPos(handles.cntParticleAll)*1e6;
handles.pStatsTableData(4,1) = handles.dataAll.pStats.zPos(handles.cntParticleAll)*1e3;
handles.pStatsTableData(5,1) = handles.dataAll.pStats.imXPos(handles.cntParticleAll)*1e6;
handles.pStatsTableData(6,1) = handles.dataAll.pStats.imYPos(handles.cntParticleAll)*1e6;

handles.pStatsTableData(7,1) = handles.dataAll.pStats.isBorder(handles.cntParticleAll);
handles.pStatsTableData(8,1) = handles.dataAll.pStats.isInVolume(handles.cntParticleAll);
handles.pStatsTableData(9,1) = handles.dataAll.pStats.partIsOnBlackList(handles.cntParticleAll);
handles.pStatsTableData(10,1) = handles.dataAll.pStats.partIsReal(handles.cntParticleAll);

handles.pStatsTableData(11,1) = handles.dataAll.pStats.minPh(handles.cntParticleAll);
handles.pStatsTableData(12,1) = handles.dataAll.pStats.maxPh(handles.cntParticleAll);
handles.pStatsTableData(13,1) = handles.dataAll.pStats.minAmp(handles.cntParticleAll);
handles.pStatsTableData(14,1) = handles.dataAll.pStats.maxAmp(handles.cntParticleAll);

handles.pStatsTableData(15,1) = handles.dataAll.pStats.pDiamMean(handles.cntParticleAll)*1e6;
handles.pStatsTableData(16,1) = handles.dataAll.pStats.pDiamOldThresh(handles.cntParticleAll)*1e6;
handles.pStatsTableData(17,1) = handles.dataAll.pStats.imEquivDiaOldSizes(handles.cntParticleAll)*1e6;
handles.pStatsTableData(18,1) = handles.dataAll.pStats.imMeanRadii(handles.cntParticleAll)*1e6;

handles.pStatsTableData(19,1) = handles.dataAll.pStats.imStdRadii(handles.cntParticleAll)*1e6;
handles.pStatsTableData(20,1) = handles.dataAll.pStats.imStdAngles(handles.cntParticleAll);
handles.pStatsTableData(21,1) = handles.dataAll.pStats.imPerimRatio(handles.cntParticleAll);
handles.pStatsTableData(22,1) = handles.dataAll.pStats.imEccentricity(handles.cntParticleAll);
handles.pStatsTableData(23,1) = handles.dataAll.pStats.imSolidity(handles.cntParticleAll);

handles.pStatsTableData(24,1) = handles.dataAll.pStats.rtDp(handles.cntParticleAll)*1e6;
handles.pStatsTableData(25,1) = handles.dataAll.pStats.rtBSlope(handles.cntParticleAll)*1e6;
handles.pStatsTableData(26,1) = handles.dataAll.pStats.rtSignal(handles.cntParticleAll)*1e12;
handles.pStatsTableData(27,1) = handles.dataAll.pStats.rtGoodFit(handles.cntParticleAll);
handles.pStatsTableData(28,1) = handles.dataAll.pStats.rtAsym(handles.cntParticleAll);
handles.pStatsTableData(29,1) = handles.dataAll.pStats.rtCenterx(handles.cntParticleAll);
handles.pStatsTableData(30,1) = handles.dataAll.pStats.rtCentery(handles.cntParticleAll);
handles.pStatsTableData(31,1) = handles.dataAll.pStats.rtXPos(handles.cntParticleAll);
handles.pStatsTableData(32,1) = handles.dataAll.pStats.rtYPos(handles.cntParticleAll);

if any(handles.parClass=='Water');
    handles.pStatsTableData(1,3) = sum(handles.parClass=='Water' & handles.choosen.Data);
    
    handles.pStatsTableData(2,3) = nanmean(handles.dataAll.pStats.xPos(handles.parClass=='Water' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(3,3) = nanmean(handles.dataAll.pStats.yPos(handles.parClass=='Water' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(4,3) = nanmean(handles.dataAll.pStats.zPos(handles.parClass=='Water' & handles.choosen.Data))*1e3;
    handles.pStatsTableData(5,3) = nanmean(handles.dataAll.pStats.imXPos(handles.parClass=='Water' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(6,3) = nanmean(handles.dataAll.pStats.imYPos(handles.parClass=='Water' & handles.choosen.Data))*1e6;
    
    handles.pStatsTableData(7,3) = nanmean(handles.dataAll.pStats.isBorder(handles.parClass=='Water' & handles.choosen.Data));
    handles.pStatsTableData(8,3) = nanmean(handles.dataAll.pStats.isInVolume(handles.parClass=='Water' & handles.choosen.Data));
    handles.pStatsTableData(9,3) = nanmean(handles.dataAll.pStats.partIsOnBlackList(handles.parClass=='Water' & handles.choosen.Data));
    handles.pStatsTableData(10,3) = nanmean(handles.dataAll.pStats.partIsReal(handles.parClass=='Water' & handles.choosen.Data));
    
    handles.pStatsTableData(11,3) = nanmean(handles.dataAll.pStats.minPh(handles.parClass=='Water' & handles.choosen.Data));
    handles.pStatsTableData(12,3) = nanmean(handles.dataAll.pStats.maxPh(handles.parClass=='Water' & handles.choosen.Data));
    handles.pStatsTableData(13,3) = nanmean(handles.dataAll.pStats.minAmp(handles.parClass=='Water' & handles.choosen.Data));
    handles.pStatsTableData(14,3) = nanmean(handles.dataAll.pStats.maxAmp(handles.parClass=='Water' & handles.choosen.Data));
    
    handles.pStatsTableData(15,3) = nanmean(handles.dataAll.pStats.pDiamMean(handles.parClass=='Water' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(16,3) = nanmean(handles.dataAll.pStats.pDiamOldThresh(handles.parClass=='Water' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(17,3) = nanmean(handles.dataAll.pStats.imEquivDiaOldSizes(handles.parClass=='Water' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(18,3) = nanmean(handles.dataAll.pStats.imMeanRadii(handles.parClass=='Water' & handles.choosen.Data))*1e6;
    
    handles.pStatsTableData(19,3) = nanmean(handles.dataAll.pStats.imStdRadii(handles.parClass=='Water' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(20,3) = nanmean(handles.dataAll.pStats.imStdAngles(handles.parClass=='Water' & handles.choosen.Data));
    handles.pStatsTableData(21,3) = nanmean(handles.dataAll.pStats.imPerimRatio(handles.parClass=='Water' & handles.choosen.Data));
    handles.pStatsTableData(22,3) = nanmean(handles.dataAll.pStats.imEccentricity(handles.parClass=='Water' & handles.choosen.Data));
    handles.pStatsTableData(23,3) = nanmean(handles.dataAll.pStats.imSolidity(handles.parClass=='Water' & handles.choosen.Data));

    handles.pStatsTableData(24,3) = nanmean(handles.dataAll.pStats.rtDp(handles.parClass=='Water' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(25,3) = nanmean(handles.dataAll.pStats.rtBSlope(handles.parClass=='Water' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(26,3) = nanmean(handles.dataAll.pStats.rtSignal(handles.parClass=='Water' & handles.choosen.Data))*1e12;
    handles.pStatsTableData(27,3) = nanmean(handles.dataAll.pStats.rtGoodFit(handles.parClass=='Water' & handles.choosen.Data));
    handles.pStatsTableData(28,3) = nanmean(handles.dataAll.pStats.rtAsym(handles.parClass=='Water' & handles.choosen.Data));
    handles.pStatsTableData(29,3) = nanmean(handles.dataAll.pStats.rtCenterx(handles.parClass=='Water' & handles.choosen.Data));
    handles.pStatsTableData(30,3) = nanmean(handles.dataAll.pStats.rtCentery(handles.parClass=='Water' & handles.choosen.Data));
    handles.pStatsTableData(31,3) = nanmean(handles.dataAll.pStats.rtXPos(handles.parClass=='Water' & handles.choosen.Data));
    handles.pStatsTableData(32,3) = nanmean(handles.dataAll.pStats.rtYPos(handles.parClass=='Water' & handles.choosen.Data));
end

if any(handles.parClass=='Ice');
    handles.pStatsTableData(1,4) = sum(handles.parClass=='Ice' & handles.choosen.Data);
    
    handles.pStatsTableData(2,4) = nanmean(handles.dataAll.pStats.xPos(handles.parClass=='Ice' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(3,4) = nanmean(handles.dataAll.pStats.yPos(handles.parClass=='Ice' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(4,4) = nanmean(handles.dataAll.pStats.zPos(handles.parClass=='Ice' & handles.choosen.Data))*1e3;
    handles.pStatsTableData(5,4) = nanmean(handles.dataAll.pStats.imXPos(handles.parClass=='Ice' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(6,4) = nanmean(handles.dataAll.pStats.imYPos(handles.parClass=='Ice' & handles.choosen.Data))*1e6;
    
    handles.pStatsTableData(7,4) = nanmean(handles.dataAll.pStats.isBorder(handles.parClass=='Ice' & handles.choosen.Data));
    handles.pStatsTableData(8,4) = nanmean(handles.dataAll.pStats.isInVolume(handles.parClass=='Ice' & handles.choosen.Data));
    handles.pStatsTableData(9,4) = nanmean(handles.dataAll.pStats.partIsOnBlackList(handles.parClass=='Ice' & handles.choosen.Data));
    handles.pStatsTableData(10,4) = nanmean(handles.dataAll.pStats.partIsReal(handles.parClass=='Ice' & handles.choosen.Data));
    
    handles.pStatsTableData(11,4) = nanmean(handles.dataAll.pStats.minPh(handles.parClass=='Ice' & handles.choosen.Data));
    handles.pStatsTableData(12,4) = nanmean(handles.dataAll.pStats.maxPh(handles.parClass=='Ice' & handles.choosen.Data));
    handles.pStatsTableData(13,4) = nanmean(handles.dataAll.pStats.minAmp(handles.parClass=='Ice' & handles.choosen.Data));
    handles.pStatsTableData(14,4) = nanmean(handles.dataAll.pStats.maxAmp(handles.parClass=='Ice' & handles.choosen.Data));
    
    handles.pStatsTableData(15,4) = nanmean(handles.dataAll.pStats.pDiamMean(handles.parClass=='Ice' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(16,4) = nanmean(handles.dataAll.pStats.pDiamOldThresh(handles.parClass=='Ice' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(17,4) = nanmean(handles.dataAll.pStats.imEquivDiaOldSizes(handles.parClass=='Ice' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(18,4) = nanmean(handles.dataAll.pStats.imMeanRadii(handles.parClass=='Ice' & handles.choosen.Data))*1e6;
    
    handles.pStatsTableData(19,4) = nanmean(handles.dataAll.pStats.imStdRadii(handles.parClass=='Ice' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(20,4) = nanmean(handles.dataAll.pStats.imStdAngles(handles.parClass=='Ice' & handles.choosen.Data));
    handles.pStatsTableData(21,4) = nanmean(handles.dataAll.pStats.imPerimRatio(handles.parClass=='Ice' & handles.choosen.Data));
    handles.pStatsTableData(22,4) = nanmean(handles.dataAll.pStats.imEccentricity(handles.parClass=='Ice' & handles.choosen.Data));
    handles.pStatsTableData(23,4) = nanmean(handles.dataAll.pStats.imSolidity(handles.parClass=='Ice' & handles.choosen.Data));
    
    handles.pStatsTableData(24,4) = nanmean(handles.dataAll.pStats.rtDp(handles.parClass=='Ice' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(25,4) = nanmean(handles.dataAll.pStats.rtBSlope(handles.parClass=='Ice' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(26,4) = nanmean(handles.dataAll.pStats.rtSignal(handles.parClass=='Ice' & handles.choosen.Data))*1e12;
    handles.pStatsTableData(27,4) = nanmean(handles.dataAll.pStats.rtGoodFit(handles.parClass=='Ice' & handles.choosen.Data));
    handles.pStatsTableData(28,4) = nanmean(handles.dataAll.pStats.rtAsym(handles.parClass=='Ice' & handles.choosen.Data));
    handles.pStatsTableData(29,4) = nanmean(handles.dataAll.pStats.rtCenterx(handles.parClass=='Ice' & handles.choosen.Data));
    handles.pStatsTableData(30,4) = nanmean(handles.dataAll.pStats.rtCentery(handles.parClass=='Ice' & handles.choosen.Data));
    handles.pStatsTableData(31,4) = nanmean(handles.dataAll.pStats.rtXPos(handles.parClass=='Ice' & handles.choosen.Data));
    handles.pStatsTableData(32,4) = nanmean(handles.dataAll.pStats.rtYPos(handles.parClass=='Ice' & handles.choosen.Data));
end

if any(handles.parClass=='Artefact');
    handles.pStatsTableData(1,5) =  sum(handles.parClass=='Artefact' & handles.choosen.Data);
    
    handles.pStatsTableData(2,5) = nanmean(handles.dataAll.pStats.xPos(handles.parClass=='Artefact' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(3,5) = nanmean(handles.dataAll.pStats.yPos(handles.parClass=='Artefact' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(4,5) = nanmean(handles.dataAll.pStats.zPos(handles.parClass=='Artefact' & handles.choosen.Data))*1e3;
    handles.pStatsTableData(5,5) = nanmean(handles.dataAll.pStats.imXPos(handles.parClass=='Artefact' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(6,5) = nanmean(handles.dataAll.pStats.imYPos(handles.parClass=='Artefact' & handles.choosen.Data))*1e6;
    
    handles.pStatsTableData(7,5) = nanmean(handles.dataAll.pStats.isBorder(handles.parClass=='Artefact' & handles.choosen.Data));
    handles.pStatsTableData(8,5) = nanmean(handles.dataAll.pStats.isInVolume(handles.parClass=='Artefact' & handles.choosen.Data));
    handles.pStatsTableData(9,5) = nanmean(handles.dataAll.pStats.partIsOnBlackList(handles.parClass=='Artefact' & handles.choosen.Data));
    handles.pStatsTableData(10,5) = nanmean(handles.dataAll.pStats.partIsReal(handles.parClass=='Artefact' & handles.choosen.Data));
    
    handles.pStatsTableData(11,5) = nanmean(handles.dataAll.pStats.minPh(handles.parClass=='Artefact' & handles.choosen.Data));
    handles.pStatsTableData(12,5) = nanmean(handles.dataAll.pStats.maxPh(handles.parClass=='Artefact' & handles.choosen.Data));
    handles.pStatsTableData(13,5) = nanmean(handles.dataAll.pStats.minAmp(handles.parClass=='Artefact' & handles.choosen.Data));
    handles.pStatsTableData(14,5) = nanmean(handles.dataAll.pStats.maxAmp(handles.parClass=='Artefact' & handles.choosen.Data));
    
    handles.pStatsTableData(15,5) = nanmean(handles.dataAll.pStats.pDiamMean(handles.parClass=='Artefact' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(16,5) = nanmean(handles.dataAll.pStats.pDiamOldThresh(handles.parClass=='Artefact' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(17,5) = nanmean(handles.dataAll.pStats.imEquivDiaOldSizes(handles.parClass=='Artefact' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(18,5) = nanmean(handles.dataAll.pStats.imMeanRadii(handles.parClass=='Artefact' & handles.choosen.Data))*1e6;
    
    handles.pStatsTableData(19,5) = nanmean(handles.dataAll.pStats.imStdRadii(handles.parClass=='Artefact' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(20,5) = nanmean(handles.dataAll.pStats.imStdAngles(handles.parClass=='Artefact' & handles.choosen.Data));
    handles.pStatsTableData(21,5) = nanmean(handles.dataAll.pStats.imPerimRatio(handles.parClass=='Artefact' & handles.choosen.Data));
    handles.pStatsTableData(22,5) = nanmean(handles.dataAll.pStats.imEccentricity(handles.parClass=='Artefact' & handles.choosen.Data));
    handles.pStatsTableData(23,5) = nanmean(handles.dataAll.pStats.imSolidity(handles.parClass=='Artefact' & handles.choosen.Data));

    handles.pStatsTableData(24,5) = nanmean(handles.dataAll.pStats.rtDp(handles.parClass=='Artefact' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(25,5) = nanmean(handles.dataAll.pStats.rtBSlope(handles.parClass=='Artefact' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(26,5) = nanmean(handles.dataAll.pStats.rtSignal(handles.parClass=='Artefact' & handles.choosen.Data))*1e12;
    handles.pStatsTableData(27,5) = nanmean(handles.dataAll.pStats.rtGoodFit(handles.parClass=='Artefact' & handles.choosen.Data));
    handles.pStatsTableData(28,5) = nanmean(handles.dataAll.pStats.rtAsym(handles.parClass=='Artefact' & handles.choosen.Data));
    handles.pStatsTableData(29,5) = nanmean(handles.dataAll.pStats.rtCenterx(handles.parClass=='Artefact' & handles.choosen.Data));
    handles.pStatsTableData(30,5) = nanmean(handles.dataAll.pStats.rtCentery(handles.parClass=='Artefact' & handles.choosen.Data));
    handles.pStatsTableData(31,5) = nanmean(handles.dataAll.pStats.rtXPos(handles.parClass=='Artefact' & handles.choosen.Data));
    handles.pStatsTableData(32,5) = nanmean(handles.dataAll.pStats.rtYPos(handles.parClass=='Artefact' & handles.choosen.Data));
end

if any(handles.parClass=='Unknown');
    handles.pStatsTableData(1,6) = sum(handles.parClass=='Unknown' & handles.choosen.Data);
    
    handles.pStatsTableData(2,6) = nanmean(handles.dataAll.pStats.xPos(handles.parClass=='Unknown' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(3,6) = nanmean(handles.dataAll.pStats.yPos(handles.parClass=='Unknown' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(4,6) = nanmean(handles.dataAll.pStats.zPos(handles.parClass=='Unknown' & handles.choosen.Data))*1e3;
    handles.pStatsTableData(5,6) = nanmean(handles.dataAll.pStats.imXPos(handles.parClass=='Unknown' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(6,6) = nanmean(handles.dataAll.pStats.imYPos(handles.parClass=='Unknown' & handles.choosen.Data))*1e6;
    
    handles.pStatsTableData(7,6) = nanmean(handles.dataAll.pStats.isBorder(handles.parClass=='Unknown' & handles.choosen.Data));
    handles.pStatsTableData(8,6) = nanmean(handles.dataAll.pStats.isInVolume(handles.parClass=='Unknown' & handles.choosen.Data));
    handles.pStatsTableData(9,6) = nanmean(handles.dataAll.pStats.partIsOnBlackList(handles.parClass=='Unknown' & handles.choosen.Data));
    handles.pStatsTableData(10,6) = nanmean(handles.dataAll.pStats.partIsReal(handles.parClass=='Unknown' & handles.choosen.Data));
    
    handles.pStatsTableData(11,6) = nanmean(handles.dataAll.pStats.minPh(handles.parClass=='Unknown' & handles.choosen.Data));
    handles.pStatsTableData(12,6) = nanmean(handles.dataAll.pStats.maxPh(handles.parClass=='Unknown' & handles.choosen.Data));
    handles.pStatsTableData(13,6) = nanmean(handles.dataAll.pStats.minAmp(handles.parClass=='Unknown' & handles.choosen.Data));
    handles.pStatsTableData(14,6) = nanmean(handles.dataAll.pStats.maxAmp(handles.parClass=='Unknown' & handles.choosen.Data));
    
    handles.pStatsTableData(15,6) = nanmean(handles.dataAll.pStats.pDiamMean(handles.parClass=='Unknown' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(16,6) = nanmean(handles.dataAll.pStats.pDiamOldThresh(handles.parClass=='Unknown' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(17,6) = nanmean(handles.dataAll.pStats.imEquivDiaOldSizes(handles.parClass=='Unknown' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(18,6) = nanmean(handles.dataAll.pStats.imMeanRadii(handles.parClass=='Unknown' & handles.choosen.Data))*1e6;
    
    handles.pStatsTableData(19,6) = nanmean(handles.dataAll.pStats.imStdRadii(handles.parClass=='Unknown' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(20,6) = nanmean(handles.dataAll.pStats.imStdAngles(handles.parClass=='Unknown' & handles.choosen.Data));
    handles.pStatsTableData(21,6) = nanmean(handles.dataAll.pStats.imPerimRatio(handles.parClass=='Unknown' & handles.choosen.Data));
    handles.pStatsTableData(22,6) = nanmean(handles.dataAll.pStats.imEccentricity(handles.parClass=='Unknown' & handles.choosen.Data));
    handles.pStatsTableData(23,6) = nanmean(handles.dataAll.pStats.imSolidity(handles.parClass=='Unknown' & handles.choosen.Data));

    handles.pStatsTableData(24,6) = nanmean(handles.dataAll.pStats.rtDp(handles.parClass=='Unknown' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(25,6) = nanmean(handles.dataAll.pStats.rtBSlope(handles.parClass=='Unknown' & handles.choosen.Data))*1e6;
    handles.pStatsTableData(26,6) = nanmean(handles.dataAll.pStats.rtSignal(handles.parClass=='Unknown' & handles.choosen.Data))*1e12;
    handles.pStatsTableData(27,6) = nanmean(handles.dataAll.pStats.rtGoodFit(handles.parClass=='Unknown' & handles.choosen.Data));
    handles.pStatsTableData(28,6) = nanmean(handles.dataAll.pStats.rtAsym(handles.parClass=='Unknown' & handles.choosen.Data));
    handles.pStatsTableData(29,6) = nanmean(handles.dataAll.pStats.rtCenterx(handles.parClass=='Unknown' & handles.choosen.Data));
    handles.pStatsTableData(30,6) = nanmean(handles.dataAll.pStats.rtCentery(handles.parClass=='Unknown' & handles.choosen.Data));
    handles.pStatsTableData(31,6) = nanmean(handles.dataAll.pStats.rtXPos(handles.parClass=='Unknown' & handles.choosen.Data));
    handles.pStatsTableData(32,6) = nanmean(handles.dataAll.pStats.rtYPos(handles.parClass=='Unknown' & handles.choosen.Data));
end
set(handles.pStatsTable, 'Data', roundsd(handles.pStatsTableData,3))
handles = updateArtefactStat(handles);
handles = updatePlotArtefactThScatter(handles);
handles = updatePlotHistogram(handles);



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
handles.choosen.showAggregation = true;
handles.choosen.showUnknown = true;
handles.choosen.showNotClass = true;
handles.choosen.showPredictedWater = true;
handles.choosen.showPredictedIce = true;
handles.choosen.showPredictedArtefact = true;
handles.choosen.showPredictedAggregation = true;
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
set(handles.showArtefactButton,'Value',handles.choosen.showArtefact);
set(handles.showAggregationButton,'Value',handles.choosen.showAggregation);
set(handles.showUnknownButton,'Value',handles.choosen.showUnknown);
set(handles.showIceButton,'Value',handles.choosen.showIce);
set(handles.showWaterButton,'Value',handles.choosen.showWater);
set(handles.showNotClassButton,'Value',handles.choosen.showNotClass);
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
    handles.choosen.Data = handles.choosen.Data & isnan(handles.dataAll.pStats.pDiamMean);
end
if handles.choosen.isNotNANpDiam
    handles.choosen.Data = handles.choosen.Data & ~isnan(handles.dataAll.pStats.pDiamMean);
    handles.choosen.Data = handles.choosen.Data & handles.dataAll.pStats.pDiamMean >= handles.choosen.minPDiam*1e-6 & ...
    handles.dataAll.pStats.pDiamMean <= handles.choosen.maxPDiam*1e-6;
end 
if ~handles.choosen.showWater
    handles.choosen.Data = handles.choosen.Data & ~(handles.parClass=='Water');
end
if ~handles.choosen.showIce
    handles.choosen.Data = handles.choosen.Data & ~(handles.parClass=='Ice');
end
if ~handles.choosen.showArtefact
    handles.choosen.Data = handles.choosen.Data & ~(handles.parClass=='Artefact');
end
if ~handles.choosen.showAggregation
    handles.choosen.Data = handles.choosen.Data & ~(handles.parClass=='Aggregation');
end
if ~handles.choosen.showUnknown
    handles.choosen.Data = handles.choosen.Data & ~(handles.parClass=='Unknown');
end
if ~handles.choosen.showNotClass
    handles.choosen.Data = handles.choosen.Data & ~(handles.parClass=='notSpez');
end
if ~handles.choosen.showPredictedWater
    handles.choosen.Data = handles.choosen.Data &...
        ~(handles.dataAll.pStats.predictedClass=='Water')';
end
if ~handles.choosen.showPredictedIce
    handles.choosen.Data = handles.choosen.Data &...
        ~(handles.dataAll.pStats.predictedClass=='Ice')';
end
if ~handles.choosen.showPredictedArtefact
    handles.choosen.Data = handles.choosen.Data &...
        ~(handles.dataAll.pStats.predictedClass=='Artefact')';
end
if ~handles.choosen.showPredictedAggregation
    handles.choosen.Data = handles.choosen.Data &...
        ~(handles.dataAll.pStats.predictedClass=='Aggregation')';
end
if handles.choosen.isFoundArtefact
    handles.choosen.Data = handles.choosen.Data & handles.ArtefactStat.isArtefact; 
end
if handles.choosen.isNotFoundArtefact
    handles.choosen.Data = handles.choosen.Data & ~handles.ArtefactStat.isArtefact; 
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
if isfield(handles, 'tree')
    handles = predictData(handles, handles.tree);
end
handles = updateImage(handles);
handles = updatePStatsTableData(handles);
handles = updateArtefactStat(handles);
handles = updatePlotArtefactThScatter(handles);
handles = updatePlotHistogram(handles);

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
outFile.pStats.parClass = handles.parClass;
if handles.ParInfoFiles(1:5) == 'Class'
    save(handles.ParInfoFiles, 'outFile');
else
    save(['Class-' handles.ParInfoFiles], 'outFile');
end


function handles = goParNrText_Callback(hObject, eventdata, handles)
% hObject    handle to goParNrText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.cntParticle = str2double(get(hObject,'String'));
handles.cntParticleAll = handles.choosen.Ind(handles.cntParticle);
handles = updateImage(handles);
handles = updatePStatsTableData(handles);
guidata(hObject,handles);
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
handles = updateChoosenData(handles);
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
handles = updateChoosenData(handles);
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
handles.ArtefactStat.isArtefact = handles.ArtefactStat.isArtefactMinAmp & ...
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

% --- Executes on button press in showAggregationButton.
function showAggregationButton_Callback(hObject, eventdata, handles)
% hObject    handle to showAggregationButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choosen.showAggregation = get(hObject,'Value');
handles = updateChoosenData(handles);
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of showAggregationButton



% --- Executes on button press in showNotClassButton.
function showNotClassButton_Callback(hObject, eventdata, handles)
% hObject    handle to showNotClassButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choosen.showNotClass = get(hObject,'Value');
handles = updateChoosenData(handles);
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of showNotClassButton

% --- Executes on button press in showPredictedWaterButton.
function showPredictedWaterButton_Callback(hObject, eventdata, handles)
% hObject    handle to showPredictedWaterButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choosen.showPredictedWater = get(hObject,'Value');
handles = updateChoosenData(handles);
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of showPredictedWaterButton


% --- Executes on button press in showPredictedIcButton.
function showPredictedIcButton_Callback(hObject, eventdata, handles)
% hObject    handle to showPredictedIcButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choosen.showPredictedIce = get(hObject,'Value');
handles = updateChoosenData(handles);
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of showPredictedIcButton


% --- Executes on button press in showPredictedArtefactButton.
function showPredictedArtefactButton_Callback(hObject, eventdata, handles)
% hObject    handle to showPredictedArtefactButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choosen.showPredictedArtefact = get(hObject,'Value');
handles = updateChoosenData(handles);
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of showPredictedArtefactButton

% --- Executes on button press in showPredictedAggregationButton.
function showPredictedAggregationButton_Callback(hObject, eventdata, handles)
% hObject    handle to showPredictedAggregationButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choosen.showPredictedAggregation = get(hObject,'Value');
handles = updateChoosenData(handles);
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of showPredictedAggregationButton

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
set(gcf,'CurrentAxes', handles.axesArtefactThScatter);
cla
gscatter(handles.dataAll.pStats.pDiamMean(handles.choosen.Data),...
    handles.dataAll.pStats.maxPh(handles.choosen.Data),...
    handles.parClass(handles.choosen.Data));
xlim([4 250]*1e-6);
xlabel('diameter [\mum]')
ylabel('max Phase');
set(gca,'XScale','log');
%hold on;
%rectangle('Position',[handles.ArtefactStat.minAmpTh 0 1-handles.ArtefactStat.minAmpTh handles.ArtefactStat.maxPhTh]);
%set( gca, 'xlim',[0 1], 'ylim', [0 pi]);

function handles = updatePlotHistogram(handles)
set(gcf,'CurrentAxes', handles.axesHistogram);
cla
anParameter.lowSize = 6;
anParameter.maxSize = 250;
anParameter.divideSize = 34;
cfg.dx = handles.dataAll.dx;
cfg.dy = handles.dataAll.dy;
[anParameter.histBinBorder, anParameter.histBinSizes, anParameter.histBinMiddle] ...
    = getHistBorder(anParameter.divideSize, anParameter.maxSize, cfg, 1);
 hist(1,:) = histogram(handles.dataAll.pStats.pDiamMean(handles.choosen.Data)*1e6, ...
     1, anParameter.histBinBorder);
 if isfield(handles.dataAll.pStats, 'predictedClass')
     levels = getlevels(handles.dataAll.pStats.predictedClass(handles.choosen.Data));
     for cnt = 1:numel(levels)
         classData = ismember(handles.dataAll.pStats.predictedClass,levels(cnt))';
         hist(1+cnt,:) = histogram(handles.dataAll.pStats.pDiamMean(classData & handles.choosen.Data)*1e6, ...
             1, anParameter.histBinBorder);
     end
 end
 plotColor = jet(size(hist,1));
 legendString = ['legend('];
 for cnt = 1:size(hist,1)
     plot(anParameter.histBinMiddle, hist(cnt,:), ...
         'color',  plotColor(cnt,:), 'LineWidth',2);
     hold on
     if cnt == 1
         legendString = [legendString '''' ...
             'All' ''','];
     else
         legendString = [legendString '''' ...
             char(levels(cnt-1)) ''','];
     end
 end
 legendString = ['h_legend=' legendString(1:end-1) ');'];
 eval(legendString);
    set(h_legend,'FontSize',9);
    
    ylabel('number density d(N)/d(log d) [cm^{-3}\mum^{-1}]');
    xlabel('diameter [\mum]')
    xlim([4 anParameter.maxSize]);
    ylim([3e-9 1e0]);
    set(gca,'YScale','log');
    set(gca,'XScale','log');


% --- Executes on button press in practiceAlogrithmButton.
function practiceAlogrithmButton_Callback(hObject, eventdata, handles)
% hObject    handle to practiceAlogrithmButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rmfield(handles,'tree')
handles.tree.varNames = {'minPh';'maxPh';'minAmp';'maxAmp';'pDiam';'imStdAngles';...
    'imPerimRatio';'imEccentricity';'imSolidity';'imMeanRadii';...
    'imStdRadii';'imEquivDiaOldSizes';'pDiamOldThresh'};
handles.tree.varHNames = {'minPh';'maxPh';'minAmp';'maxAmp';...
    'pDiam';...
    'imStdAngles';...
    'imPerimRatio';'imEccentricity';'imSolidity';'imMeanRadii';...
    'imStdRadii';'imEquivDiaOldSizes';'pDiamOldThresh';'rtDp';...
    'rtBSlope';'rtSignal';'rtGoodFit';'rtAsym';'imStdmRadii';'imStdmAngles'};
choosenData = true(1,handles.pNumber);
handles.tree.X = getTreeX(handles, choosenData);
handles.tree.HX = getTreeHX(handles, choosenData);
handles.tree.Y = handles.parClass;
handles.tree.Y = droplevels(handles.tree.Y,{'notSpez','Unknown'});
handles.tree.Y = handles.tree.Y(choosenData);
handles.tree.classificationTree = ClassificationTree.fit(handles.tree.X,handles.tree.Y,'PredictorNames', handles.tree.varNames,'minleaf',10,...
'AlgorithmForCategorical','PCA');
handles.tree.classificationHTree = ClassificationTree.fit(handles.tree.HX,handles.tree.Y,'PredictorNames', handles.tree.varHNames,'minleaf',10,...
'AlgorithmForCategorical','PCA');
handles = predictData(handles, handles.tree);
guidata(hObject,handles)

function handles = predictData(handles, tree)
    choosenData = true(1,handles.pNumber);
Xdata = getTreeX(handles,true(1,numel(choosenData)));
if isfield(tree,'classificationTreeShort')
    handles.dataAll.pStats.predictedClass = predict(tree.classificationTreeShort, Xdata);
else
    handles.dataAll.pStats.predictedClass = predict(tree.classificationTree, Xdata);
end

if isfield(tree,'classificationHTree')
    HXdata = getTreeHX(handles,true(1,numel(choosenData)));
        handles.dataAll.pStats.predictedClassOld =  handles.dataAll.pStats.predictedClass;
    if isfield(tree,'classificationHTreeShort')
        handles.dataAll.pStats.predictedHClass = predict(tree.classificationHTreeShort, HXdata);
    else
        handles.dataAll.pStats.predictedHClass = predict(tree.classificationHTree, HXdata);
    end
       handles.dataAll.pStats.predictedClass =  handles.dataAll.pStats.predictedHClass;
end

function treeX = getTreeX(handles, choosenData)
treeX = [handles.dataAll.pStats.minPh(choosenData); handles.dataAll.pStats.maxPh(choosenData); ...
    handles.dataAll.pStats.minAmp(choosenData); handles.dataAll.pStats.maxAmp(choosenData); ...
    handles.dataAll.pStats.pDiamMean(choosenData); handles.dataAll.pStats.imStdAngles(choosenData);...
    handles.dataAll.pStats.imPerimRatio(choosenData); handles.dataAll.pStats.imEccentricity(choosenData);...
    handles.dataAll.pStats.imSolidity(choosenData); handles.dataAll.pStats.imMeanRadii(choosenData);...
    handles.dataAll.pStats.imStdRadii(choosenData); handles.dataAll.pStats.imEquivDiaOldSizes(choosenData);...
     handles.dataAll.pStats.pDiamOldThresh(choosenData)]';
 
  function treeHX = getTreeHX(handles, choosenData)
treeHX = [handles.dataAll.pStats.minPh(choosenData); handles.dataAll.pStats.maxPh(choosenData); ...
    handles.dataAll.pStats.minAmp(choosenData); handles.dataAll.pStats.maxAmp(choosenData); ...
    handles.dataAll.pStats.pDiamMean(choosenData); 
    handles.dataAll.pStats.imStdAngles(choosenData);...
    handles.dataAll.pStats.imPerimRatio(choosenData); handles.dataAll.pStats.imEccentricity(choosenData);...
    handles.dataAll.pStats.imSolidity(choosenData); handles.dataAll.pStats.imMeanRadii(choosenData);...
    handles.dataAll.pStats.imStdRadii(choosenData); handles.dataAll.pStats.imEquivDiaOldSizes(choosenData);...
     handles.dataAll.pStats.pDiamOldThresh(choosenData); handles.dataAll.pStats.rtDp(choosenData);...
     handles.dataAll.pStats.rtBSlope(choosenData); handles.dataAll.pStats.rtSignal(choosenData);...
     handles.dataAll.pStats.rtGoodFit(choosenData); handles.dataAll.pStats.rtAsym(choosenData);...
     handles.dataAll.pStats.imStdmRadii(choosenData); handles.dataAll.pStats.imStdmAngles(choosenData)...
     ]';

% --- Executes on button press in showTreeButton.
function showTreeButton_Callback(hObject, eventdata, handles)
% hObject    handle to showTreeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
view(handles.tree.classificationTree,'mode','graph')
if isfield(handles.tree, 'classificationHTree')
    view(handles.tree.classificationHTree,'mode','graph')
end

% --- Executes on button press in saveTreeButton.
function saveTreeButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveTreeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

treeFile = handles.tree;
if handles.ParInfoFiles(1:4) == 'Tree'
    save(handles.ParInfoFiles, 'treeFile');
elseif handles.ParInfoFiles(1:5) == 'Class'
   handles.ParInfoFiles(1:5) = []; 
    save(['Tree' handles.ParInfoFiles], 'treeFile');
else
    save(['Tree-' handles.ParInfoFiles], 'treeFile');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over maxMinAmpText.
function maxMinAmpText_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to maxMinAmpText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in calculateTrStatsButton.
function calculateTrStatsButton_Callback(hObject, eventdata, handles)
% hObject    handle to calculateTrStatsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
for cnt = 1:numel(handles.dataAll.pStats.rtDp)
    radst = particleForRtStats.getRadTrStats(handles.dataAll.pStats.pImage{cnt},....
        handles.dataAll.pStats.imCenterx(cnt),...
        handles.dataAll.pStats.imCenterx(cnt));
    dr = sqrt(handles.dataAll.dx*handles.dataAll.dy);
    radst.rtrs(2)        = radst.rtrs(2) * dr;
    radst.rtBestFit(3:4) = radst.rtBestFit(3:4) *dr;
    radst.rtDp           = radst.rtDp *dr;
    radst.rtBSlope       = radst.rtBSlope *dr;
    radst.rtSignal       = radst.rtSignal *dr^2;
    handles.dataAll.pStats.rtrs{cnt} = radst.rtrs;
    handles.dataAll.pStats.rtBestFit{cnt} = radst.rtBestFit;
    handles.dataAll.pStats.rtDp(cnt) = radst.rtDp;
    handles.dataAll.pStats.rtBSlope(cnt) = radst.rtBSlope;
    handles.dataAll.pStats.rtSignal(cnt) = radst.rtSignal;
    handles.dataAll.pStats.rtGoodFit(cnt) = radst.rtGoodFit;
    handles.dataAll.pStats.rtAsym(cnt) = radst.rtAsym;
    handles.dataAll.pStats.rtCenterx(cnt) = radst.rtCenterx;
    handles.dataAll.pStats.rtCentery(cnt) = radst.rtCentery;
    if rem(cnt,100)==0
        sprintf('Calculating rtStats from particle nr. %u / %u',...
            cnt,numel(handles.dataAll.pStats.rtDp))
    end
    guidata(hObject,handles)
end
