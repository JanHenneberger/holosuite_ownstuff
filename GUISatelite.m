function varargout = GUISatelite(varargin)
% GUISATELITE MATLAB code for GUISatelite.fig
%      GUISATELITE, by itself, creates a new GUISATELITE or raises the existing
%      singleton*.
%
%      H = GUISATELITE returns the handle to a new GUISATELITE or the handle to
%      the existing singleton*.
%
%      GUISATELITE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUISATELITE.M with the given input arguments.
%
%      GUISATELITE('Property','Value',...) creates a new GUISATELITE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUISatelite_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUISatelite_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUISatelite

% Last Modified by GUIDE v2.5 27-Jan-2016 14:38:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUISatelite_OpeningFcn, ...
                   'gui_OutputFcn',  @GUISatelite_OutputFcn, ...
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


% --- Executes just before GUISatelite is made visible.
function GUISatelite_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUISatelite (see VARARGIN)

% Choose default command line output for GUISatelite
handles.output = hObject;

if numel(varargin) > 0
    handles.meteoPrecip = varargin{1};
else
    handles.meteoPrecip = wolke.importMeteoData('Z:\3_Data\CLACE2013\MeteoSwissPrecip\order_40015_data.txt');
end

if numel(varargin) > 1
    handles.meteoJFJ = varargin{2};
else
    handles.meteoJFJ = wolke.importMeteoData('Z:\3_Data\CLACE2013\MeteoSwissJFJ\order_40175_data.txt');
end

handles.basepath = 'Z:\3_Data\CLACE2013\JFJ_Remote';
handles.DWDpath = 'DWD_charts';
handles.Radarpath = 'Radar';
handles.SatIRpath = 'Satellite\IR';
handles.SatVISpath = 'Satellite\VIS';

handles.year = 2013;
handles.month = 02;
handles.day = 01;
handles.hour = 12;
handles.min = 00;
handles.sec = 00;
handles.stepRadar = 30;

handles.SatNr = 24;
handles.stepSat = 1;

handles.stepAll = 2;

handles = refreshAll(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUISatelite wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUISatelite_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function editTextYear_Callback(hObject, eventdata, handles)
% hObject    handle to editTextYear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTextYear as text
%        str2double(get(hObject,'String')) returns contents of editTextYear as a double

handles.year = str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function editTextYear_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTextYear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editTextHour_Callback(hObject, eventdata, handles)
% hObject    handle to editTextHour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTextHour as text
%        str2double(get(hObject,'String')) returns contents of editTextHour as a double

handles.hour = str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editTextHour_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTextHour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editTextMonth_Callback(hObject, eventdata, handles)
% hObject    handle to editTextMonth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTextMonth as text
%        str2double(get(hObject,'String')) returns contents of editTextMonth as a double
handles.month = str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editTextMonth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTextMonth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editTextDay_Callback(hObject, eventdata, handles)
% hObject    handle to editTextDay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editTextDay as text
%        str2double(get(hObject,'String')) returns contents of editTextDay as a double

handles.day = str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function editTextDay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTextDay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonPreviousRadar.
function pushbuttonPreviousRadar_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPreviousRadar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.min = handles.min - handles.stepRadar;
handles = refreshRadar(handles);
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in pushbuttonNextRadar.
function pushbuttonNextRadar_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonNextRadar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.min = handles.min + handles.stepRadar;
handles = refreshRadar(handles);
% Update handles structure
guidata(hObject, handles);



function editStepRadar_Callback(hObject, eventdata, handles)
% hObject    handle to editStepRadar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editStepRadar as text
%        str2double(get(hObject,'String')) returns contents of editStepRadar as a double

handles.stepRadar = str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editStepRadar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editStepRadar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbuttonPlot.
function pushbuttonPlot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = refreshAll(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in pushbuttonNextSat.
function pushbuttonNextSat_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonNextSat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.SatNr = handles.SatNr + handles.stepSat;
handles = refreshSat(handles);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in pushbuttonPrevSat.
function pushbuttonPrevSat_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPrevSat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.SatNr = handles.SatNr - handles.stepSat;
handles = refreshSat(handles);

% Update handles structure
guidata(hObject, handles);

function editStepSat_Callback(hObject, eventdata, handles)
% hObject    handle to editStepSat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editStepSat as text
%        str2double(get(hObject,'String')) returns contents of editStepSat as a double

handles.stepSat = str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editStepSat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editStepSat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushPreAll.
function pushPreAll_Callback(hObject, eventdata, handles)
% hObject    handle to pushPreAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handles.SatNr = handles.SatNr - handles.stepAll;
handles.min = handles.min - handles.stepAll*30;
handles = refreshSat(handles);
handles = refreshRadar(handles);
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushNextAll.
function pushNextAll_Callback(hObject, eventdata, handles)
% hObject    handle to pushNextAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.SatNr = handles.SatNr + handles.stepAll;
handles.min = handles.min + handles.stepAll*30;
handles = refreshSat(handles);
handles = refreshRadar(handles);

% Update handles structure
guidata(hObject, handles);

function editStepAll_Callback(hObject, eventdata, handles)
% hObject    handle to editStepAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editStepAll as text
%        str2double(get(hObject,'String')) returns contents of editStepAll as a double

handles.stepAll = str2double(get(hObject,'String'));

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editStepAll_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editStepAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function handles = refreshAll(handles)
handles = updatedate(handles);
plotRadar(handles);
plotSat(handles);
plotRest(handles);

function handles = refreshRadar(handles)
handles = updatedate(handles);
plotRadar(handles);

function handles = refreshSat(handles)
handles = updatedate(handles);
plotSat(handles);


function handles = updatedate(handles)

handles.datenum = datenum([handles.year handles.month handles.day ...
    handles.hour handles.min handles.sec]);

handles.editTextYear.String = datestr(handles.datenum,'yyyy');
handles.editTextMonth.String = datestr(handles.datenum,'mm');
handles.editTextDay.String = datestr(handles.datenum,'dd');
handles.editTextHour.String = datestr(handles.datenum,'HH');
handles.editStepRadar.String = num2str(handles.stepRadar);
handles.editStepSat.String = num2str(handles.stepSat);
handles.editStepAll.String = num2str(handles.stepAll);

dateVector = datevec(handles.datenum);
handles.year = dateVector(1);
handles.month = dateVector(2);
handles.day = dateVector(3);
handles.hour = dateVector(4);
handles.min = dateVector(5);
handles.sec = dateVector(6);

handles.datepath = datestr(handles.datenum,'yyyymmdd');
handles.textDateString.String = datestr(handles.datenum);





function plotRadar(handles)
try
    dateVector =datevec(handles.datenum);
    ax = handles.axesRadar;
    cla(ax)
    path = fullfile(handles.basepath, handles.Radarpath, handles.datepath);
    
    if dateVector(1) == 2013
        name = [datestr(handles.datenum, 'yyyymmddHHMM') '.gif'];
    else
        name = ['TGN' datestr(handles.datenum, 'yyyymmddHHMM') '.gif'];
    end
    [img map1] = imread(fullfile(path,name));
    colormap(ax, map1);
    imshow(img, map1,'Parent',ax)
    hold(ax,'on')
    if dateVector(1) == 2013
        plot(388,401,'rx','MarkerSize',20,'Parent',ax);
    else
        plot(170,162,'rx','MarkerSize',20,'Parent',ax);
    end
    hold(ax,'off')
catch
    text(0.5, 0.5, 'not available','Parent',ax)
    warning([path, 'does not exists'])
end

function plotSat(handles)
try
    ax = handles.axesSatVis;
    cla(ax)
    path = fullfile(handles.basepath, handles.SatVISpath, handles.datepath);
    files = dir(fullfile(path, '*.vis'));
    files = {files.name};
    
    [img map2] = imread(fullfile(path,files{handles.SatNr}));
    colormap(ax, map2);
    imshow(img,'Parent',ax)
    hold(ax,'on')
        plot(407,361,'rx','MarkerSize',20,'Parent',ax);
    hold(ax,'off')
catch
    text(0.5, 0.5, 'not available','Parent',ax)
    warning([path, 'does not exists'])
end

try
    ax = handles.axesSatIR;
    cla(ax)
    path = fullfile(handles.basepath, handles.SatIRpath, handles.datepath);
    files = dir(fullfile(path, '*.ir'));
    files = {files.name};
    [img map3] = imread(fullfile(path,files{handles.SatNr}));
    colormap(ax, map3);
    imshow(img,'Parent',ax)
    hold(ax,'on')    
%     if dateVector(1) == 2013
%         plot(407,361,'rx','MarkerSize',20,'Parent',ax);
%     else
%         plot(484,361,'rx','MarkerSize',20,'Parent',ax);
%     end
    plot(484,361,'rx','MarkerSize',20,'Parent',ax);
    hold(ax,'off')
catch
    text(0.5, 0.5, 'not available','Parent',ax)
    warning([path, 'does not exists'])
end


function plotRest(handles)
dateVector =datevec(handles.datenum);
try
    ax = handles.axesDWDchart;
    cla(ax)
    path = fullfile(handles.basepath, handles.DWDpath, handles.datepath, 'analysis');
    name = ['bwk_m_stat_' datestr(handles.datenum, 'yymmdd') '0600.tif'];
    [img map] = imread(fullfile(path,name));
    img = imrotate(img, 90);
    colormap(ax, [0 0 0 ; 1 1 1]);
    %img = imcomplement(img);
    imshow(img,'Parent',ax)
    hold(ax,'on')
    if dateVector(1) == 2013
        plot(1900,1400,'rx','MarkerSize',20,'Parent',ax);
    else
        plot(1900,1580,'rx','MarkerSize',20,'Parent',ax);
    end
    hold(ax,'off')
catch
    text(0.5, 0.5, 'not available','Parent', ax)
    warning([path, 'does not exists'])
end

try
    ax = handles.axesMeteoPrecip;
    cla(ax)
    station = fieldnames(handles.meteoPrecip);
    starttime = datenum([handles.year handles.month handles.day]);
    endtime = starttime + 1;
    
    hold(ax,'on')
    for cnt = 1:numel(station)
        datay = handles.meteoPrecip.(station{cnt}).Precipitation10min;
        datax = handles.meteoPrecip.(station{cnt}).datenum;
        idx = datax > starttime & datax < endtime;
        plot(datax(idx),datay(idx),'Parent',ax);
    end
    legend(ax,station)
    datetick(ax)
catch
    text(0.5, 0.5, 'not available','Parent',ax)
    warning([path, 'does not exists'])
end

try
    ax = handles.axesMeteoJFJ;
    cla(ax)
    starttime = datenum([handles.year handles.month handles.day]);
    endtime = starttime + 1;
    
    datax = handles.meteoJFJ.JUN.datenum;
    idx = datax > starttime & datax < endtime;
    
  
    
    datay1 = handles.meteoJFJ.JUN.Temperature;
    
    
    datay3 = handles.meteoJFJ.JUN.Wind_speed;
    
    
    [a, h1, h2] = plotyy(datax(idx),datay1(idx),...
           datax(idx), datay3(idx),...
           'Parent',ax);

    ylabel(a(1),'Temperature [°C]') % left y-axis
    ylabel(a(2),'Wind speed [m s^{-1}]') % right y-axis
    legend(ax,{'Temperature';'Wind speed'})
    datetick(ax)
catch
    text(0.5, 0.5, 'not available','Parent',ax)
    warning([path, 'does not exists'])
end

try
    ax = handles.axesMeteoJFJ2;
    cla(ax)
    starttime = datenum([handles.year handles.month handles.day]);
    endtime = starttime + 1;
    
    datax = handles.meteoJFJ.JUN.datenum;
    idx = datax > starttime & datax < endtime;
    

    
    datay1 = handles.meteoJFJ.JUN.Relative_humidity;  
    
    datay3 = handles.meteoJFJ.JUN.GlobalRadiation/nanmax(handles.meteoJFJ.JUN.GlobalRadiation);
    datay4 = handles.meteoJFJ.JUN.SunshineDuration/nanmax(handles.meteoJFJ.JUN.SunshineDuration);
    
    [a, h1, h2] = plotyy(datax(idx),datay1(idx),...
           [datax(idx)', datax(idx)'],[datay3(idx)',datay4(idx)'],...
           'Parent',ax);
    ylabel(a(1),'relative humidity [%]') % left y-axis
    ylabel(a(2),'radiation and sunshine [%]') % right y-axis
   
    legend(ax,{'rel. Humidity';'global Radiation';'Sunshine Duration'})
    datetick(ax)
catch
    text(0.5, 0.5, 'not available','Parent',ax)
    warning([path, 'does not exists'])
end
