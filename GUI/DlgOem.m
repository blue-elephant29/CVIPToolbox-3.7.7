function varargout = DlgOem(varargin)
% OEM MATLAB code for Oem.fig
%      OEM, by itself, creates a new OEM or raises the existing
%      singleton*.
%
%      H = OEM returns the handle to a new OEM or the handle to
%      the existing singleton*.
%
%      OEM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OEM.M with the given input arguments.
%
%      OEM('Property','Value',...) creates a new OEM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DlgOem_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DlgOem_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Oem

% Last Modified by GUIDE v2.5 24-Jan-2022 21:31:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DlgOem_OpeningFcn, ...
                   'gui_OutputFcn',  @DlgOem_OutputFcn, ...
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

% Reference 
% ---------
%  1. Scott E Umbaugh. DIGITAL IMAGE PROCESSING AND ANALYSIS: Applications 
%     with MATLAB and CVIPtools, 3rd Edition.

%==========================================================================
%
%           Author:                 Julian Rene Cuellar Buritica (GUIDE)
%           Initial coding date:    11/21/2017
%           Updated by:             Julian Rene Cuellar Buritica
%           Latest update date:     05/24/2019
%           Credit:                 Scott Umbaugh 
%                                   CVIP Lab, SIUE
%           Copyright (C) 2018 Scott Umbaugh and SIUE
%
%==========================================================================

% --- Executes just before Oem is made visible.
function DlgOem_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Oem (see VARARGIN)

% Choose default command line output for Oem
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Oem wait for user response (see UIRESUME)
% uiwait(handles.Oem);
%call menu creation function
menu_add_cvip(hObject);



function mVsaveHis_Callback(hObject, eventdata, handles)
% hObject    handle to mVsaveHis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
msgbox('Hola Magola, This is working!!!  :)');
hObject.Checked = 'On';



% --- Outputs from this function are returned to the command line.
function varargout = DlgOem_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% CODE CALLBACKS ORDER:
% - Buttons (bApply, bCancel, bReset, ...)
% - Radio Buttons (Options, choices)
% - Pop-up Men�s
% - Figure Callbacks (Resize, Click, ...)
% - Main Menus (fOpen, fSave)
% - Ui Main Menus (uiOpen, uiSave)
% - Menus (Others: View, Analysis, Compression...)


% --- Executes on button press in bApply.
function bApply_Callback(hObject, eventdata, handles)
% hObject    handle to bApply (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc                             %clear screen

%changing pointer arrow to watch on cursor
figure_set = findall(groot,'Type','Figure');
set(figure_set,'pointer','watch');

hMain = findobj('Tag','Main');  %get the handle of Main form
hSHisto = findobj('Tag','mVsaveHis'); %get handle of Save history menu
hVfinfo = findobj('Tag','mVfi');    %get handle of menu view fun information
hNfig = hMain.UserData;         %get image handle
if hNfig == 0 || isempty(hNfig) || ~isfield(hNfig.UserData,'cvipIma')
    errordlg('Please select the image to Process', 'Filter Error', 'modal');
else
Ima=hNfig.UserData;             %Get image information
InIma = Ima.cvipIma;            %read image data
file = get(hNfig,'Name');       %get image name
histo = 0; OutIma = 0;          %initial vbles values


% Importing Image
Ima1 = handles.bIma1.UserData;       %get image handle
hNfig2 = handles.bIma2.UserData;    %get image handle
%check for Image to process
if isempty(Ima1) && ~isfield(Ima1,'cvipIma') 
    errordlg(['There is nothing to process. Please select an Image and '...
        'try again.'],'Arith/Logic Error','modal'); 

end

%IMAGE OPERATIONS

InIma1 = Ima.cvipIma;               %read image data
% file1=handles.txtIma1.String;       %get file name
InIma2=hNfig2.cvipIma;              %get 2nd image
% file2=handles.txtIma2.String;       %second image name

[row,col,band] = size(InIma1);      %get image 1 size
[row2,col2,band2] = size(InIma2);   %get image 2 size
OutIma = 0;  
if handles.bPeak.Value                  %perform Peak SNR
    %check the size of two images before perform operations
    if row ~= row2 || col ~= col2
        errordlg('Images must have the same size','Compare Error','modal');
    else
        Gray = str2double(handles.popGray.String(handles.popGray.Value));
        Peak = peak_snr_cvip(InIma1, InIma2, Gray); %call peak SNR function
        histo = [112 Gray];                	%update image history
        if band == 3 || band2 == 3
            handles.txtresG.ForegroundColor = [0.2 0.5 0.2];
            handles.txtresR.String = Peak(1);
            handles.txtresG.String = Peak(2);
            handles.txtresB.String = Peak(3);
            handles.txtresR.Visible = 'On';
            handles.txtresB.Visible = 'On';
        else
            handles.txtresG.ForegroundColor = [0 0 0];
            handles.txtresR.Visible = 'Off';
            handles.txtresB.Visible = 'Off';
            handles.txtresG.String = Peak;
        end
    end
elseif handles.bSNR.Value                   %perform Multiplication
    %check the size of two images before perform operations
    if row ~= row2 || col ~= col2
        errordlg('Images must have the same size','Compare Error','modal');
    else
        SNR = snr_cvip(InIma1, InIma2); %call SNR function
        histo = 113;                        %update image history
        if band == 3 || band2 == 3
            handles.txtresG.ForegroundColor = [0.2 0.5 0.2];
            handles.txtresR.String = SNR(1);
            handles.txtresG.String = SNR(2);
            handles.txtresB.String = SNR(3);
            handles.txtresR.Visible = 'On';
            handles.txtresB.Visible = 'On';
        else
            handles.txtresG.ForegroundColor = [0 0 0];
            handles.txtresR.Visible = 'Off';
            handles.txtresB.Visible = 'Off';
            handles.txtresG.String = SNR;
        end
    end
elseif handles.bRMS.Value                   %perform NOT
    RMS = rms_error_cvip(InIma1, InIma2);   %call RMS function
    histo = 111;                            %update image history
    if band == 3 || band2 == 3
        handles.txtresG.ForegroundColor = [0.2 0.5 0.2];
        handles.txtresR.String = RMS(1);
        handles.txtresG.String = RMS(2);
        handles.txtresB.String = RMS(3);
        handles.txtresR.Visible = 'On';
        handles.txtresB.Visible = 'On';
    else
        handles.txtresG.ForegroundColor = [0 0 0];
        handles.txtresR.Visible = 'Off';
        handles.txtresB.Visible = 'Off';
        handles.txtresG.String = RMS;
    end
end
%END OF IMAGE OPERATIONS

if sum(histo) ~= 0
%check if need to save history
if strcmp(hSHisto(1).Checked,'on')              %save new image history
    Ima.fInfo.history_info = historyupdate_cvip(Ima.fInfo.history_info,histo);  
end
%check if need to show function information
if strcmp(hVfinfo(1).Checked,'on')
    hIlist = findobj('Tag','txtIlist');         %get handle of text element
    hIlist.String(end+1,1)=' ';                 %print an empty line
    txtInfo = historydeco_cvip(histo);     
    hIlist.String(end+1,1:size(file,2)+1)=[file ':']; 
    for i=1:size(txtInfo)
        sInfo = txtInfo{i};                     %extract row to print
        sInfo = sprintf(sInfo);
        [~,rr] = size(sInfo);
        hIlist.String(end+1,1:rr) = sInfo;
    end
    hIlist.Value = size(hIlist.String,1);       %goto last line
    figure(hMain);
end

end
if size(OutIma,1) > 3
    [row,col,band]=size(OutIma);                    %get new image size
    %update image information
    Ima.fInfo.no_of_bands=band;             
    Ima.fInfo.no_of_cols=col;              
    Ima.fInfo.no_of_rows=row;
    %update image structure
    Ima.cvipIma = OutIma;                           %read image data
    showgui_cvip(Ima, Name);                        %show image in viewer
end

end

%changing pointer watch back to arrow on cursor
set(figure_set,'pointer','arrow');


% --- Executes on button press in bCancel.
function bCancel_Callback(hObject, eventdata, handles)
% hObject    handle to bCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Prepare to close application window
 close(handles.Oem)


% --- Executes on button press in bReset.
function bReset_Callback(hObject, eventdata, handles)
% hObject    handle to bReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function fOpen_Callback(hObject, eventdata, handles)
% hObject    handle to fOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hMain = findobj('Tag','Main');              %get the handle of Main form
% get handles and other user-defined data associated to Gui1
g1data = guidata(hMain);
if ~isempty(hMain)
    CVIPToolbox('fOpen_Callback',g1data.fOpen,eventdata,guidata(g1data.fOpen))
end

% --------------------------------------------------------------------
function fSave_Callback(hObject, eventdata, handles)
% hObject    handle to fSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hMain = findobj('Tag','Main');              %get the handle of Main form
% get handles and other user-defined data associated to Gui1
g1data = guidata(hMain);
if ~isempty(hMain)
    CVIPToolbox('fSave_Callback',g1data.fSave,eventdata,guidata(g1data.fSave))
end

% --------------------------------------------------------------------
function uiOpenIma_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uiOpenIma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hMain = findobj('Tag','Main');              %get the handle of Main form
% get handles and other user-defined data associated to Gui1
g1data = guidata(hMain);
if ~isempty(hMain)
    CVIPToolbox('fOpen_Callback',g1data.fOpen,eventdata,guidata(g1data.fOpen))
end

% --------------------------------------------------------------------
function uiSaveIma_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uiSaveIma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hMain = findobj('Tag','Main');              %get the handle of Main form
% get handles and other user-defined data associated to Gui1
g1data = guidata(hMain);
if ~isempty(hMain)
    CVIPToolbox('fSave_Callback',g1data.fSave,eventdata,guidata(g1data.fSave))
end

% --------------------------------------------------------------------
function mFile_Callback(hObject, eventdata, handles)
% hObject    handle to mFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mAna_Callback(hObject, eventdata, handles)
% hObject    handle to mAna (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function mGeo_Callback(hObject, eventdata, handles)
% hObject    handle to mGeo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mGeo_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function mEdge_Callback(hObject, eventdata, handles)
% hObject    handle to mEdge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mEdge_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function mSeg_Callback(hObject, eventdata, handles)
% hObject    handle to mSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mSeg_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function mTrans_Callback(hObject, eventdata, handles)
% hObject    handle to mTrans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mTrans_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function mFeat_Callback(hObject, eventdata, handles)
% hObject    handle to mFeat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mFeat_Callback',hObject,eventdata,guidata(hObject))

% --------------------------------------------------------------------
function mPatt_Callback(hObject, eventdata, handles)
% hObject    handle to mPatt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CVIPToolbox('mPatt_Callback',hObject,eventdata,guidata(hObject))


% --- Executes during object creation, after setting all properties.
function Oem_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Oem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function selTestImage_Callback(hObject, eventdata, handles)
% hObject    handle to selTestImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of selTestImage as text
%        str2double(get(hObject,'String')) returns contents of selTestImage as a double


% --- Executes during object creation, after setting all properties.
function selTestImage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selTestImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function selIdealImage_Callback(hObject, eventdata, handles)
% hObject    handle to selIdealImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of selIdealImage as text
%        str2double(get(hObject,'String')) returns contents of selIdealImage as a double


% --- Executes during object creation, after setting all properties.
function selIdealImage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selIdealImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function bOem_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bOem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in bIma1.
function bIma1_Callback(hObject, eventdata, handles)
% hObject    handle to bIma1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc                             %clear screen
hMain = findobj('Tag','Main');  %get the handle of Main form
hNfig = hMain.UserData;         %get image handle
if hNfig ~= 0 && isfield(hNfig.UserData,'cvipIma')%check for Image to save
    file=get(hNfig,'Name');    	%get image name
    hObject.UserData = hNfig.UserData;%read image info
    handles.selIdealImage.String = file;  %show image name
end

% --- Executes on button press in bIma2.
function bIma2_Callback(hObject, eventdata, handles)
% hObject    handle to bIma2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc                             %clear screen
hMain = findobj('Tag','Main');  %get the handle of Main form
hNfig = hMain.UserData;         %get image handle
if hNfig ~= 0 && isfield(hNfig.UserData,'cvipIma')%check for Image to save
    file=get(hNfig,'Name');    	%get image name
    hObject.UserData = hNfig.UserData;%read image info
    handles.selTestImage.String = file;  %show image name
end



function txtresG_Callback(hObject, eventdata, handles)
% hObject    handle to txtresG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtresG as text
%        str2double(get(hObject,'String')) returns contents of txtresG as a double


% --- Executes during object creation, after setting all properties.
function txtresG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtresG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtresR_Callback(hObject, eventdata, handles)
% hObject    handle to txtresR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtresR as text
%        str2double(get(hObject,'String')) returns contents of txtresR as a double


% --- Executes during object creation, after setting all properties.
function txtresR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtresR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txtresB_Callback(hObject, eventdata, handles)
% hObject    handle to txtresB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtresB as text
%        str2double(get(hObject,'String')) returns contents of txtresB as a double


% --- Executes during object creation, after setting all properties.
function txtresB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtresB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popGray.
function popGray_Callback(hObject, eventdata, handles)
% hObject    handle to popGray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popGray contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popGray


% --- Executes during object creation, after setting all properties.
function popGray_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popGray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
