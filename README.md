# Cognex-DS1100-16bit-BMP-read-by-MATLAB

本程序利用MATLAB读取康耐视三维传感器输出的16位bmp扩展名的深度图
因为MATLAB本身对读取非标准位数的bmp支持一直不好，而康耐视这个bmp恰好又不是标准的555或者565格式，故只能把bmp文件二进制打开进行解析。

## LoadSingle16GrayBMP.m

读取单个BMP图像的函数，将会输出一个uint16格式的矩阵，大小和输入图片相同

## BatchConvert2Mat16Gray.m

在这个脚本的开头填入需要处理的bmp文件的路径，结尾填入需要存储的文件名即可。保存的文件内是一个cell，这个cell的大小和转换文件的总数目有关
