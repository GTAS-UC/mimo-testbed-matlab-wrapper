function wrapper_selfupdate

% Find all versions of the wrapper in the Matlab search path
vlist=what('@wsLyrtechGTAS');
if length(vlist)>1
    err_str=sprintf('The following %d versions of the GTAS testbed Matlab wrapper have been found in your Matlab search path:\n',length(vlist));
    for kk=1:length(vlist)
        err_str=[err_str sprintf('\t%d.- %s\n',kk,vlist(kk).path)];
    end
    err_str=[err_str sprintf('Multiple copies are not allowed. Please remove all but one from your Matlab path and execute this selfupdater again.\n')];
    error(err_str);
end

% What class is being executed?
wsLyrtechGTAS_class=vlist(1).path;

% What folder is it in?
wsLyrtechGTAS_folder=fileparts(wsLyrtechGTAS_class);
wsLyrtechGTAS_grandfolder=fileparts(wsLyrtechGTAS_folder);

disp_msg(' ')
disp_msg('Wrapper selfupdate initialized')
disp_msg('==============================')

%% Download and update

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
filenames=unzip('https://api.github.com/repos/GTAS-UC/mimo-testbed-matlab-wrapper/zipball/master',wsLyrtechGTAS_grandfolder);
disp_msg(sprintf('   %d files extracted',length(filenames)))

disp_msg('Adding new version to Matlab path...')
p = genpath(fullfile(wsLyrtechGTAS_grandfolder,'wsLyrtechGTAS'));
addpath(p);

rehash;
disp_msg('Done!')

end

function disp_msg(str)
global selfupdate_verbosity

if isempty(selfupdate_verbosity) || selfupdate_verbosity
    disp(str)
end
end