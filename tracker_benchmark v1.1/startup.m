function startup
clear all; close all; clc; warning off all;

[pathstr, name, ext] = fileparts(mfilename('fullpath'));

addpath(fullfile(pathstr, 'util'));
% addpath(fullfile(pathstr, 'anno'));
addpath(fullfile(pathstr, 'evals'));
set_global_variable('toolkit_path', pathstr);

% reuse functions from old repository
addpath(fullfile(pathstr, 'tracker_benchmark_v1.1', 'util'));
addpath(fullfile(pathstr, 'tracker_benchmark_v1.1', 'rstEval'));

% mkdir
mkdir(fullfile(pathstr, 'cache'));
end

