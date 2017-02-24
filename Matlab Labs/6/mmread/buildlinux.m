if isunix
    currentdir = pwd;
    try
        cd(fileparts(mfilename('fullpath'))); % FFGrab searches for AVbin in the current directory

        if strcmp(mexext,'mexglx')
            avbin = 'libavbin.so.32';
        else
            avbin = 'libavbin.so.64';
        end
        eval(['mex -v FFGrab.cpp -O -Iavbin/include -Iavbin/ffmpeg ' avbin ' LDFLAGS=''-pthread -shared -Wl,-R/usr/local/lib -Wl,-R.''']);
    catch
        err = lasterr;
        cd(currentdir);
        rethrow(err);
    end
end