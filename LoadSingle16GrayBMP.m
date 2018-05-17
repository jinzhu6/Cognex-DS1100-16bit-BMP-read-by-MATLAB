function my_UINT16_bmp = LoadSingle16GrayBMP( filename )
%LOADSINGLE16GRAYBMP 此处显示有关此函数的摘要
%   此处显示详细说明
% 函数内容基本与Cognex16GrayReadm相同！
    fID = fopen(filename);

    %% 1. 首先，有14字节的文件头，结构如下
    % 1.1 WORD x 1 也即 byte x 2 的固定数据 0x4d42
    fseek(fID, 2, 'bof'); % bof beginning of file
    % 1.2 DWORD x 1 也即 byte x 4 的文件大小
    file_size = fread(fID, 1, 'uint32');
    % 1.3 WORD x 2 的两个保留字
    fseek(fID, 4, 'cof'); % cof - current position of file
    % 1.4 DWORD x 1 时机位图数据的偏移字节数，也即这个文件的图像数据之前，有多少东西不是数据而是信息
    bfOffBits = fread(fID, 1, 'uint32');

    %% 2. BITMAPINFOHEADER
    % 2.1 DWORD biSize 占据第二部分的这个结构体的长度
    biSize = fread(fID, 1, 'uint32');
    % 2.2 LONG biWidth 位图宽度 LONG 应该等同于 DWORD
    biWidth = fread(fID, 1, 'uint32');
    % 2.3 LONG biHeight 位图高度
    biHeight = fread(fID, 1, 'uint32');
    % 2.4 WORD biPlanes 平面数 默认为1
    fseek(fID, 2, 'cof');
    % 2.5 WORD biBitCount 颜色位数，康耐视的应该是16
    biBitCount = fread(fID, 1, 'uint16');
    % 2.6 DWORD biCompression 压缩方式
    fseek(fID, 4, 'cof');
    % 2.7 DWORD biSizeImage 实际位图数据占用的字节数
    biSizeImage = fread(fID, 1, 'uint32');
    % 2.8 LONG biXPelsPerMeter X方向分辨率
    biXPelsPerMeter = fread(fID, 1, 'uint32');
    % 2.9 LONG biYPelsPerMeter Y方向分辨率
    biYPelsPerMeter = fread(fID, 1, 'uint32');
    % 2.10 DWORD biClrUsed 使用颜色数，如果为0表示默认颜色数：2^位数
    % 2.11 DWORD biClrImportant 重要颜色数，为0则所有颜色都重要
    fseek(fID, 8, 'cof');

    %% 3. 图像数据-前面本来还有个调色板，但是康耐视的没有
    % bmp的存储顺序是：起始数据是左下角，第二个数据为最后一行第二列（按行存储）
    % 但同时，bmp图像有个问题，所有行的 byte数 会被强制补充为4的倍数
    % 3.1 先计算一下当前每一行有多少个 byte
    current_byte_num_per_row = biWidth * 2; % 因为已知这种图像是16位也即2byte了
    % 3.2 把它补齐到4的倍数
    fit_byte_num_per_row = ceil(current_byte_num_per_row/4)*4;
    % 3.3 按行读数据
    my_UINT16_bmp = uint16(zeros(biHeight, biWidth));

    for i = biHeight:(-1):1
        data_image_row = (fread(fID, fit_byte_num_per_row/2, 'uint16'))';
        my_UINT16_bmp(i,:) = data_image_row(1:current_byte_num_per_row/2);
    end

end

