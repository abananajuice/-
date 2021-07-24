function varargout = recognization(varargin)
% RECOGNIZATION MATLAB code for recognization.fig
%      RECOGNIZATION, by itself, creates a new RECOGNIZATION or raises the existing
%      singleton*.
%
%      H = RECOGNIZATION returns the handle to a new RECOGNIZATION or the handle to
%      the existing singleton*.
%
%      RECOGNIZATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RECOGNIZATION.M with the given input arguments.
%
%      RECOGNIZATION('Property','Value',...) creates a new RECOGNIZATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before recognization_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to recognization_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help recognization

% Last Modified by GUIDE v2.5 24-Apr-2021 22:55:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @recognization_OpeningFcn, ...
                   'gui_OutputFcn',  @recognization_OutputFcn, ...
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


% --- Executes just before recognization is made visible.
function recognization_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to recognization (see VARARGIN)

% Choose default command line output for recognization
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes recognization wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = recognization_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% 读取数据
disp('开始读取图片...');
I = getPicData();
% load I
disp('图片读取完毕')

%% 特征提取
x0 = zeros(14, 1000);
disp('开始特征提取...')

for i=1:1000
    % 先进行中值滤波
    tmp = medfilt2(I(:,:,i),[3,3]);
    % 得到特征向量
    t= getFeature(tmp);
    x0(:,i) = t(:);
end

% 标签 label 为长度为1000的列向量
label = 1:10;
label = repmat(label,100,1);
label = label(:);
disp('特征提取完毕')
%% 神经网络模型的建立
tic
spread = .1;
% 归一化
[x, se] = mapminmax(x0);
% 创建概率神经网络
net = newpnn(x, ind2vec(label'),spread);
ti = toc;
fprintf('建立网络模型共耗时 %f sec\n', ti);

%%  测试
h=getframe(handles.axes1);
im=h.cdata;
im = cut(im);
s =size(im) ; 
b = [];
for i = 1: s(2)
    re1 = im{i};  
    %滤波
    re1 = medfilt2(re1,[3,3]);
    re1 = kalman(re1);
    %提取特征
    [fea2,s2]  = getFeature(re1);
    %imshow(s2);
    % 归一化
    fea2 =mapminmax('apply',fea2,se);
    %测试
    tlab1 = net(fea2);
    tlab2 = vec2ind(tlab1);
    b(i)=tlab2-1;
   
end

set(handles.text3,'String',num2str(b));






% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla;

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.axes1,'XLim',[0,1],'YLim',[0,1]);
global draw_enable;
global x;
global y;
draw_enable=1;
if draw_enable
    position=get(gca,'currentpoint');
    x(1)=position(1);
    y(1)=position(3);
end

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global draw_enable
draw_enable=0;

% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global draw_enable;
global x;
global y;
if draw_enable
    position=get(gca,'currentpoint');
    x(2)=position(1);
    y(2)=position(3);
    line(x,y,'EraseMode','xor','LineWidth',5,'color','b');
    x(1)=x(2);
    y(1)=y(2);
end