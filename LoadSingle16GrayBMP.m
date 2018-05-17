function my_UINT16_bmp = LoadSingle16GrayBMP( filename )
%LOADSINGLE16GRAYBMP �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
% �������ݻ�����Cognex16GrayReadm��ͬ��
    fID = fopen(filename);

    %% 1. ���ȣ���14�ֽڵ��ļ�ͷ���ṹ����
    % 1.1 WORD x 1 Ҳ�� byte x 2 �Ĺ̶����� 0x4d42
    fseek(fID, 2, 'bof'); % bof beginning of file
    % 1.2 DWORD x 1 Ҳ�� byte x 4 ���ļ���С
    file_size = fread(fID, 1, 'uint32');
    % 1.3 WORD x 2 ������������
    fseek(fID, 4, 'cof'); % cof - current position of file
    % 1.4 DWORD x 1 ʱ��λͼ���ݵ�ƫ���ֽ�����Ҳ������ļ���ͼ������֮ǰ���ж��ٶ����������ݶ�����Ϣ
    bfOffBits = fread(fID, 1, 'uint32');

    %% 2. BITMAPINFOHEADER
    % 2.1 DWORD biSize ռ�ݵڶ����ֵ�����ṹ��ĳ���
    biSize = fread(fID, 1, 'uint32');
    % 2.2 LONG biWidth λͼ��� LONG Ӧ�õ�ͬ�� DWORD
    biWidth = fread(fID, 1, 'uint32');
    % 2.3 LONG biHeight λͼ�߶�
    biHeight = fread(fID, 1, 'uint32');
    % 2.4 WORD biPlanes ƽ���� Ĭ��Ϊ1
    fseek(fID, 2, 'cof');
    % 2.5 WORD biBitCount ��ɫλ���������ӵ�Ӧ����16
    biBitCount = fread(fID, 1, 'uint16');
    % 2.6 DWORD biCompression ѹ����ʽ
    fseek(fID, 4, 'cof');
    % 2.7 DWORD biSizeImage ʵ��λͼ����ռ�õ��ֽ���
    biSizeImage = fread(fID, 1, 'uint32');
    % 2.8 LONG biXPelsPerMeter X����ֱ���
    biXPelsPerMeter = fread(fID, 1, 'uint32');
    % 2.9 LONG biYPelsPerMeter Y����ֱ���
    biYPelsPerMeter = fread(fID, 1, 'uint32');
    % 2.10 DWORD biClrUsed ʹ����ɫ�������Ϊ0��ʾĬ����ɫ����2^λ��
    % 2.11 DWORD biClrImportant ��Ҫ��ɫ����Ϊ0��������ɫ����Ҫ
    fseek(fID, 8, 'cof');

    %% 3. ͼ������-ǰ�汾�����и���ɫ�壬���ǿ����ӵ�û��
    % bmp�Ĵ洢˳���ǣ���ʼ���������½ǣ��ڶ�������Ϊ���һ�еڶ��У����д洢��
    % ��ͬʱ��bmpͼ���и����⣬�����е� byte�� �ᱻǿ�Ʋ���Ϊ4�ı���
    % 3.1 �ȼ���һ�µ�ǰÿһ���ж��ٸ� byte
    current_byte_num_per_row = biWidth * 2; % ��Ϊ��֪����ͼ����16λҲ��2byte��
    % 3.2 �������뵽4�ı���
    fit_byte_num_per_row = ceil(current_byte_num_per_row/4)*4;
    % 3.3 ���ж�����
    my_UINT16_bmp = uint16(zeros(biHeight, biWidth));

    for i = biHeight:(-1):1
        data_image_row = (fread(fID, fit_byte_num_per_row/2, 'uint16'))';
        my_UINT16_bmp(i,:) = data_image_row(1:current_byte_num_per_row/2);
    end

end

