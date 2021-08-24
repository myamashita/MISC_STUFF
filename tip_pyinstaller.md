PyInstaller create the big executable from the conda packages and the small executable from the pip packages. From this simple python code:

>from pandas import DataFrame as df  
>print('h')


I obtain the 203MB executable by the conda packages and the 30MB executable by the pip packages. But conda is the nice replacement of the pure virtualenv. I can develop with conda and Jupyter, create some mycode.py (I can download jupyter notebook as py-file in myfolder). But my final solution is next: If you do not have it, install Miniconda and from the Windows Start Menu open Anaconda Prompt;

    cd myfolder
    conda create -n exe python=3
    activate exe
    pip install pandas pyinstaller pypiwin32
    echo hiddenimports = ['pandas._libs.tslibs.timedeltas'] > %CONDA_PREFIX%\Lib\site-packages\PyInstaller\hooks\hook-pandas.py
    pyinstaller -F mycode.py
Where I create new environment 'exe', pypiwin32 need for pyinstaller but is not installed automaticaly, hook-pandas.py need for compile with pandas. Also, import submodules do not help me optimize the size of the executable file. So I do not need this thing:

    from pandas import DataFrame as df
but I can just use the usual code:

    import pandas as pd
Also, some errors are possible along using the national letters in paths, so it is nice the english user account for development tools.
___
I further download UPX from github.com/upx/upx/releases and supplied the folderpath as --upx-dir=C:\upx394w and it decreased things even further to 28MB. So, 600MB to 28MB. Not bad! 
