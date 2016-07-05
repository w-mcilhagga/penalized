% setup paths

uiwait(msgbox('This will remove the toolbox paths from your MATLAB pathfile','Install'));

thedir = strrep(mfilename('fullpath'),[filesep,'uninstall_penalized'],'');
rmpath(thedir);
rmpath([thedir,filesep,'models'])
rmpath([thedir,filesep,'internals'])
rmpath([thedir,filesep,'penalties'])
rmpath([thedir,filesep,'helpfiles'])
rmpath([thedir,filesep,'jss'])
rmpath([thedir,filesep,'jss/jsstable'])

savepath;

