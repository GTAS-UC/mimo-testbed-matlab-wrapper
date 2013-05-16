function obj = wsLyrtechGTAS(endpoint)
% wsLyrtechGTAS: GTAS MIMO testbed node constructor.
%
% USAGE:
%
% node = wsLyrtechGTAS(url)
%
%       url: Web service endpoint URL.
%
% Example:
%
% 1. Create an object corresponding to node 2:
%
%           node2 = wsLyrtechGTAS('http://gtas.unican.es/testbed/node2/wsLyrtech.asmx');
%
% 2. Now, you can use that object to send commands to the node:
%
%           file='DAC_Virtex4_8_channels_RFFE.bit';
%           fs=52;
%           dac_FPGAConf(node2,file); % Program FPGA using this .bit programming file
%           dac_SamplingFreq(node2,fs); % Adjust sampling frequency to 52 MHz
%
% MORE INFO & DEMOS:
% Documentation and demos can be found in the <a href="http://www.gtas.unican.es/testbed">GTAS testbed website</a>

% Óscar González Fernández
% GTAS - DICOM - UNICAN
%
% Created:
%   July 2008
% Modified:
%   August 17th 2008
%   May 19th 2010 (improve path updating and input arguments)
%   July 30th 2011 (added path detection and compatibility with parfor)
%   December 15th 2012 (added sellupdate capabilities)
%   January 2nd 2013 (complete rewrite)
%   May 17th 2013 (moved to GitHub repository, selfupdate mechanism updated)

% Find all versions of the wrapper in the Matlab search path
vlist=what('@wsLyrtechGTAS');
if length(vlist)>1
   err_str=sprintf('The following %d versions of the GTAS testbed Matlab wrapper have been found in your Matlab search path:\n',length(vlist));
   for kk=1:length(vlist)
       err_str=[err_str sprintf('\t%d.- %s\n',kk,vlist(kk).path)];
   end
   err_str=[err_str sprintf('Multiple copies are not allowed. Please remove all but one from your Matlab path and execute this again.\n')];
   error(err_str);
end

% What class is being executed?
wsLyrtechGTAS_class=vlist(1).path;

% What folder is it in?
wsLyrtechGTAS_folder=fileparts(wsLyrtechGTAS_class);

% Constructor starts here
wsLyrtech_class=fullfile(wsLyrtechGTAS_folder,'@wsLyrtech');
wsLyrtech_struct=dir([wsLyrtech_class filesep]);

%Download @wsLyrtech when wsLyrtech is not present
if isempty(wsLyrtech_struct)
    %% Update wrapped class methods
    disp(' ')
    disp('Class methods update initialized')
    disp('==============================')
    %Delete old class versions
    status=rmdir(wsLyrtech_class,'s');
    %Download new ones
    disp('Updating class methods...');
    parent_name=createClassFromWsdl([endpoint '?WSDL']);
    %Move wsLyrtech class to its proper location
    [status msg msgid]=movefile(['@wsLyrtech' filesep],wsLyrtechGTAS_folder);
    if status==0 & ~strcmp(msgid,'MATLAB:MOVEFILE:SourceAndDestinationSame')
        rmdir('@wsLyrtech','s'); %Delete when an error occurs
    end
    path(path);
end

parent=wsLyrtech;

if isempty(which('SetEndpoint(parent,endpoint)'))
    copyfile(fullfile(wsLyrtechGTAS_class,'SetEndpoint.m'),fullfile(wsLyrtech_class,'SetEndpoint.m')); %Problems with parfor??
    hack=which('SetEndpoint(parent,endpoint)');%Hack for Matlab ver < 2007a (refresh path??)
end

parent=SetEndpoint(parent,endpoint);
obj = class(struct([]),'wsLyrtechGTAS',parent);

return;
% Show class methods
% methods(obj,'-full')
% properties(obj)
% parent=obj.wsLyrtech
% fieldnames(obj,'-full')
