    try
        temp = load('2014-02-18-23-53-53-276553_ps.mat');
    catch exception
        warning(exception.message)
        temp = [];
        emptyPsFile(cnt) = 1;
    end