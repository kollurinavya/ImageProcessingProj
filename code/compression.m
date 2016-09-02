function varargout = compression(varargin)
%
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @compression_OpeningFcn, ...
                   'gui_OutputFcn',  @compression_OutputFcn, ...
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

% --- Executes just before compression is made visible.
function compression_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using compression.
if strcmp(get(hObject,'Visible'),'off')
   % plot(rand(5));
end

function varargout = compression_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% --- Executes on button press in comp_button.
function comp_button_Callback(hObject, eventdata, handles)

popup_sel_index = get(handles.comp_dropdown, 'Value');
switch popup_sel_index
    case 1
        filename = get(handles.img_path,'String');
        img1 = imread(filename);
        begrun=clock
        cpu=cputime
        
        ffic_var_comp(filename);
        % EZW(8,10,'db2',filename)
        cpu0=cputime-cpu
        stoprun=clock
        tim=etime(stoprun,begrun)
        img2 = imread('comp.tif');
        axes(handles.comp_img);        
        imshow('comp.tif');
        handles.time.String = strcat('Time Taken: ',num2str(tim));
        s = dir('gs_ffic.mat');
        %s = dir('lena.wtc');
        filesize = s.bytes;
        handles.size.String = strcat('Size of compressed image in bytes:',num2str(filesize));
        s = dir(filename);
        filesize = s.bytes;
        handles.org_size.String = strcat('Size of original image  in bytes: ',num2str(filesize));
        D = abs(double(img1)-double(img2)).^2;
        mse  = sum(D(:))/numel(img1);
        psnr = 10*log10(255*255/mse);
        handles.error.String = strcat('MSE Error: ',num2str(mse));

    case 2

        filename = get(handles.img_path,'String');
        img1 = imread(filename);
        begrun=clock
        cpu=cputime
        runs_index = get(handles.runs, 'Value');
        switch runs_index
            case 1
                runs = 6;
            case 2
                runs = 7
            case 3
                runs =8
            case 4
                runs =9
            case 5
                runs = 10
            case 6
                runs = 11
            case 7
                runs =12
        end
        %ffic_var_comp(filename);
        EZW(runs,12,'db2',filename)
        cpu0=cputime-cpu
        stoprun=clock
        tim=etime(stoprun,begrun)
        img2 = imread('comp.tif');
        axes(handles.comp_img);        
        imshow('comp.tif');
        handles.time.String = strcat('Time Taken: ',num2str(tim));
        %s = dir('gs_ffic.mat');
        s = dir('lena.wtc');
        filesize = s.bytes;
        handles.size.String = strcat('Size of compressed image in bytes: ',num2str(filesize));
        s = dir(filename);
        filesize = s.bytes;
        handles.org_size.String = strcat('Size of original image  in bytes: ',num2str(filesize));
        D = abs(double(img1)-double(img2)).^2;
        mse  = sum(D(:))/numel(img1);
        psnr = 10*log10(255*255/mse);
        handles.error.String = strcat('MSE Error: ',num2str(mse));
       
end

% --- Executes on button press in Browse.
function Browse_Callback(hObject, eventdata, handles)

 [filename path] = uigetfile({'*.tif'},'File Selector')
 handles.img_path.String = strcat(path,filename)
 img = imread(strcat(path,filename))
 axes(handles.img)
 imshow(img)

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in comp_dropdown.
function comp_dropdown_Callback(hObject, eventdata, handles)
% hObject    handle to comp_dropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns comp_dropdown contents as cell array
%        contents{get(hObject,'Value')} returns selected item from comp_dropdown


% --- Executes during object creation, after setting all properties.
function comp_dropdown_CreateFcn(hObject, eventdata, handles)
% hObject    handle to comp_dropdown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'Fractal Compression', 'Wavelet compression'});


    


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in runs.
function runs_Callback(hObject, eventdata, handles)
% hObject    handle to runs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns runs contents as cell array
%        contents{get(hObject,'Value')} returns selected item from runs


% --- Executes during object creation, after setting all properties.
function runs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to runs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
