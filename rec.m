function varargout = rec(varargin)
% REC MATLAB code for rec.fig
%      REC, by itself, creates a new REC or raises the existing
%      singleton*.
%
%      H = REC returns the handle to a new REC or the handle to
%      the existing singleton*.
%
%      REC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REC.M with the given input arguments.
%
%      REC('Property','Value',...) creates a new REC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before rec_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to rec_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help rec

% Last Modified by GUIDE v2.5 12-May-2021 17:05:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rec_OpeningFcn, ...
                   'gui_OutputFcn',  @rec_OutputFcn, ...
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


% --- Executes just before rec is made visible.
function rec_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rec (see VARARGIN)

% Choose default command line output for rec
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes rec wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = rec_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
global cam_flag cap_flag;
cam_flag=0;
cap_flag=0;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cam_flag cap_flag cap_im;
cam_flag=1;

axes(handles.axes1);
ip = '192.168.137.11:8080';
url=strcat('http://',ip,'/shot.jpg');
pic = imread(url);
while(cam_flag)
    pic  = imread(url);
    imshow(pic);
    drawnow();
   
end
axes(handles.axes1);
cla;
cap_im=pic;
if (cap_flag==1)
    imshow(pic);
    cap_flag=0;
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cam_flag;
cam_flag=0;


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cap_flag cam_flag;
cap_flag=1;
cam_flag=0;


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cap_im;
t1=cap_im;
im = cut(t1);
s =size(im) ;
b = [];
net=load('nn.mat');
se=load('se.mat');
for i = 1: s(2)
    re1 = im{i};  
    %滤波
    re1 = medfilt2(re1,[3,3]);
    re1 = kalman(re1);
    %提取特征
    [fea2]  = getFeature(re1);
    %imshow(s2);
    % 归一化
    fea2 =mapminmax('apply',fea2,se.se);
    %测试

    tlab1 = net.net(fea2);
    tlab2 = vec2ind(tlab1);
    b(i)=tlab2-1;
end

set(handles.text2,'String',num2str(b));
