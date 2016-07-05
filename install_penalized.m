% setup paths for the toolbox

uiwait(msgbox('This will add the necessary paths to your current session','Install'));

thedir = strrep(mfilename('fullpath'),[filesep,'install_penalized'],'');
addpath(thedir);
addpath([thedir,filesep,'models'])
addpath([thedir,filesep,'internals'])
addpath([thedir,filesep,'penalties'])
addpath([thedir,filesep,'helpfiles'])
addpath([thedir,filesep,'jss'])
addpath([thedir,filesep,'jss/jsstable'])

response = questdlg('Do you want to save paths permanently','Save Paths','Yes','No','No');
if strcmp(response,'Yes')
    savepath;
end

% copyright notice

fprintf('Copyright © 2014 William McIlhagga, william.mcilhagga@gmail.com\n')
fprintf('\n')
fprintf('The PENALIZED toolbox is free software: you can redistribute it and/or modify\n')
fprintf('it under the terms of the GNU General Public License as published by\n')
fprintf('the Free Software Foundation, either version 3 of the License, or\n')
fprintf('(at your option) any later version.\n')
fprintf('\n')
fprintf('The PENALIZED toolbox is distributed in the hope that it will be useful,\n')
fprintf('but WITHOUT ANY WARRANTY; without even the implied warranty of\n')
fprintf('MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n')
fprintf('GNU General Public License for more details.\n')
fprintf('\n')
fprintf('You should have received a copy of the GNU General Public License\n')
fprintf('along with the PENALIZED toolbox.  If not, see\n')
fprintf('<http://www.gnu.org/licenses/>.\n\n')
