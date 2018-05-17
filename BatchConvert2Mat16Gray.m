clearvars

bmp_path = 'chizuo\*.bmp';

file_names = dir(bmp_path);

n = length(file_names);

% ≥ı ºªØ
Mat16GrayBMPs = cell(n,1);


for i=1:n
    
    FileName = [file_names(i).folder, '\', file_names(i).name];
    Mat16GrayBMPs{i} = LoadSingle16GrayBMP(FileName);
    
end

save_name = 'TestRes.mat';
save(save_name, 'Mat16GrayBMPs');