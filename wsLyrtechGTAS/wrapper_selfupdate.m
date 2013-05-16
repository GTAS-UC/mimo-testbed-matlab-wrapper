function wrapper_selfupdate

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
wsLyrtechGTAS_grandfolder=fileparts(wsLyrtechGTAS_folder);

disp_msg(' ')
disp_msg('Wrapper autoupdate initialized')
disp_msg('==============================')
%% Retrieve current version number

if exist('wrapper_version')==2
    old_ver_str=wrapper_version;
    disp_msg(sprintf('Current version: %s',old_ver_str));
else
    old_ver_str='20000101T000000';
    disp_msg('No previous version found');
end
old_ver_num=datenum(old_ver_str,'yyyymmddTHHMMSS');


%% Retrieve last version number
disp_msg('Checking latest version...')
aux=urlread('http://code.google.com/p/gtas-testbed-matlab-wrapper/downloads/list?can=1&q=gtas-testbed-matlab-wrapper&colspec=Filename');
matches=regexp(aux,'name=gtas-testbed-matlab-wrapper-(\d{8}T\d{6}).zip','tokens');
if length(matches)>=1
    [mx ix]=max(cellfun(@(x)datenum(x,'yyyymmddTHHMMSS'),matches));
    new_ver_str=matches{ix}{1};
    new_ver_num=mx;
else
    disp_msg('   No versions found!');
    return;
end
disp_msg(sprintf('   Latest version: %s',new_ver_str));

%% Download and update
if new_ver_num > old_ver_num
    
    disp_msg('Backing up current version...')
    copyfile(wsLyrtechGTAS_folder,[wsLyrtechGTAS_folder '.bak']);
    
    disp_msg('Removing current version from path...')
    warning('off','MATLAB:rmpath:DirNotFound');
    p = genpath(wsLyrtechGTAS_folder);
    rmpath(p);
    warning('on','MATLAB:rmpath:DirNotFound');
    
    disp_msg('Deleting current version...')
    rmdir(wsLyrtechGTAS_folder,'s');
    
    disp_msg('Downloading & unzipping new version...')
    filenames=unzip(sprintf(['http://gtas-testbed-matlab-wrapper.googlecode.com/'...
        'files/gtas-testbed-matlab-wrapper-%s.zip'],new_ver_str),wsLyrtechGTAS_grandfolder);
    disp_msg(sprintf('   %d files extracted',length(filenames)))
    
    disp_msg('Adding new version to Matlab path...')
    p = genpath(fullfile(wsLyrtechGTAS_grandfolder,'wsLyrtechGTAS'));
    addpath(p);
    
    rehash;
    disp_msg('Done!')
else
    disp_msg('You already have the latest version. Nothing to update!')
end

end

function disp_msg(str)
global selfupdate_verbosity

if isempty(selfupdate_verbosity) || selfupdate_verbosity
    disp(str)
end
end