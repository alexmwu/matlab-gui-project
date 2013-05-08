function varargout = AudioEditTool(varargin)
%AUDIOEDITTOOL M-file for AudioEditTool.fig
%      AUDIOEDITTOOL, by itself, creates a new AUDIOEDITTOOL or raises the existing
%      singleton*.
%
%      H = AUDIOEDITTOOL returns the handle to a new AUDIOEDITTOOL or the handle to
%      the existing singleton*.
%
%      AUDIOEDITTOOL('Property','Value',...) creates a new AUDIOEDITTOOL using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to AudioEditTool_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      AUDIOEDITTOOL('CALLBACK') and AUDIOEDITTOOL('CALLBACK',hObject,...) call the
%      local function named CALLBACK in AUDIOEDITTOOL.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AudioEditTool

% Last Modified by GUIDE v2.5 22-Apr-2013 21:30:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AudioEditTool_OpeningFcn, ...
                   'gui_OutputFcn',  @AudioEditTool_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before AudioEditTool is made visible.
function AudioEditTool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for AudioEditTool
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AudioEditTool wait for user response (see UIRESUME)
% uiwait(handles.figure1);


        

% --- Outputs from this function are returned to the command line.
function varargout = AudioEditTool_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in uploadButton.
function uploadButton_Callback(hObject, eventdata, handles)
% hObject    handle to uploadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.loadingText, 'String', 'Loading...');
global song
global y
global fs
global fileName
[fileName, pathName] = uigetfile('*.wav', 'Select a .wav file');
addpath(pathName)
[y ,fs]=wavread(fileName);
song=audioplayer(y, fs);
set(handles.currentsongText, 'String', fileName(1:length(fileName)-8));
set(handles.loadingText, 'String', '');
set(handles.originaltempoText, 'String', num2str(fix(str2num(fileName(length(fileName)-7:length(fileName)-4)))));
set(handles.currenttempoText, 'String', num2str(fix(str2num(fileName(length(fileName)-7:length(fileName)-4)))));

set(handles.hopinText, 'String', '256');
set(handles.hopoutText, 'String', '256');
set(handles.strobeCheckbox, 'Value', 0);
set(handles.windowCheckbox, 'Value', 1);
set(handles.framesizeText, 'String', '1024');
set(handles.recommendationText, 'String', 'Press Apply to view recommendation...');
set(handles.timestretchSlider, 'Value', 1);

%plotwavtimef(y, fs, handles);


function framesizeText_Callback(hObject, eventdata, handles)
% hObject    handle to framesizeText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of framesizeText as text
%        str2double(get(hObject,'String')) returns contents of framesizeText as a double


% --- Executes during object creation, after setting all properties.
function framesizeText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to framesizeText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hopinText_Callback(hObject, eventdata, handles)
% hObject    handle to hopinText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hopinText as text
%        str2double(get(hObject,'String')) returns contents of hopinText as a double
hopinval=str2num(get(handles.hopinText, 'String'));
hopoutval=str2num(get(handles.hopoutText, 'String'));
if hopinval>512
    hopinval=256;
    set(handles.hopinText, 'String', '256');
elseif hopinval<128
    hopinval=256;
    set(handles.hopinText, 'String', '256');
end
hopratio=hopoutval/hopinval;
set(handles.timestretchSlider, 'Value', hopratio);

% --- Executes during object creation, after setting all properties.
function hopinText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hopinText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hopoutText_Callback(hObject, eventdata, handles)
% hObject    handle to hopoutText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hopoutText as text
%        str2double(get(hObject,'String')) returns contents of hopoutText as a double
hopinval=str2num(get(handles.hopinText, 'String'));
hopoutval=str2num(get(handles.hopoutText, 'String'));
if hopoutval>512
    hopoutval=256;
    set(handles.hopoutText, 'String', '256');
elseif hopoutval<128
    hopoutval=256;
    set(handles.hopoutText, 'String', '256');
end
hopratio=hopoutval/hopinval;
set(handles.timestretchSlider, 'Value', hopratio);

% --- Executes during object creation, after setting all properties.
function hopoutText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hopoutText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in windowCheckbox.
function windowCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to windowCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of windowCheckbox


% --- Executes on button press in applyButton.
function applyButton_Callback(hObject, eventdata, handles)
% hObject    handle to applyButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global y
global song
global fs
set(handles.loadingText, 'String', 'Loading...');
framesize=str2double(get(handles.framesizeText, 'String'));
ihop=str2double(get(handles.hopinText, 'String'));
ohop=str2double(get(handles.hopoutText, 'String'));
applywindow=get(handles.windowCheckbox, 'Value');
a=get(handles.timestretchCheckbox, 'Value');
b=get(handles.pitchstretchCheckbox, 'Value');
c=get(handles.strobeCheckbox, 'Value');

if a==1 && b==1 || a==0 && b==0
    y=y;
    fs=fs*(get(handles.timestretchSlider, 'Value'));
elseif a==1 && b==0
    [y, hopratio]=phasevocoderf(y, framesize, ihop, ohop, applywindow, handles);
    fs=44100;
    BPM=str2num(get(handles.originaltempoText, 'String'));
    set(handles.currenttempoText, 'String', num2str(fix(BPM/hopratio)));
elseif a==0 && b==1
    [y, hopratio]=phasevocoderf(y, framesize, ihop, ohop, applywindow, handles);
    fs=44100*(get(handles.timestretchSlider, 'Value'));
else
end

if c==1
    y=strobeEffect(y);
end

song=audioplayer(y, fs);
set(handles.loadingText, 'String', '');

% For Recomendation Function
recoMatrix={'Billy Jean',117; ...
    'Call Me Maybe',123; ...
    'Victory March',148; ...
    'It Girl',91; ...
    'Lucky',130; ...
    'September',126; ...
    'Stacy''s Mom',118; ...
    'Titanium Remix',129; ...
    'Tonight',88; ...
    'Window Shopper',87};

BPM=str2num(get(handles.currenttempoText, 'String'));
compMatrix=zeros(10,2);
songplaying=get(handles.currentsongText, 'String');
for i=1:10
    compMatrix(i,1)=i;
end
isTrue=false;

while isTrue==false
for i=1:10
    compMatrix(i,2)=abs(BPM-cell2mat(recoMatrix(i,2)));
end
minDif=min(compMatrix(:,2));
for i=1:10
    if compMatrix(i,2)==minDif
        Val1=i;
    end
end
recsong=recoMatrix(Val1,1);
if strcmp(recsong, songplaying)
    recoMatrix(Val1,2)=num2cell(1000);
else
    isTrue=true;
end
end


set(handles.recommendationText, 'String',recsong);


% --- Executes on slider movement.
function timestretchSlider_Callback(hObject, eventdata, handles)
% hObject    handle to timestretchSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.hopinText, 'String', '256');
set(handles.hopoutText, 'String',num2str(fix(get(handles.timestretchSlider, 'Value')*256)));

% --- Executes during object creation, after setting all properties.
function timestretchSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timestretchSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in strobeCheckbox.
function strobeCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to strobeCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of strobeCheckbox


% --- Executes on button press in playButton.
function playButton_Callback(hObject, eventdata, handles)
% hObject    handle to playButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global song
global y
global fs


    lengthSong=length(song);
    
    if song.CurrentSample==1;
        wait=waitbar(0,'Loading Song...');
        steps=lengthSong/1.5;
        for step=1:steps
            plotMusic(song,songPlot,samplingFrequency,handles)
            waitbar(step / steps)
        end
        close(wait)
    end
    
    
    
    if isplaying(song)
        pause(song)
    else
        resume(song)
    end
    plotMusic(song,y,fs,handles)



% --- Executes on button press in stopButton.
function stopButton_Callback(hObject, eventdata, handles)
% hObject    handle to stopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global song

stop(song);


% --- Executes on button press in timestretchCheckbox.
function timestretchCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to timestretchCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of timestretchCheckbox


% --- Executes on button press in pitchstretchCheckbox.
function pitchstretchCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to pitchstretchCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pitchstretchCheckbox


% --- Executes on button press in exportButton.
function exportButton_Callback(hObject, eventdata, handles)
% hObject    handle to exportButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.loadingText, 'String', 'Loading...');
global y
global fileName
wavwrite(y,[fileName(1:length(fileName)-8) '_Modded'])
set(handles.loadingText, 'String', '');
