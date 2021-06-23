%% clear terminal
clc
clear

% read table kolom ppertama
dataNamaNegara = readtable('WHO COVID-19 global table data June 22nd 2021 at 10.52.14 PM.csv','Range','A3:A239');

% ubah ke bentuk cell
namaNegara = table2cell(dataNamaNegara);

%read table kolom 3-7
data = readtable('WHO COVID-19 global table data June 22nd 2021 at 10.52.14 PM.csv','Range','C3:G239')

data = table2array(data);


% batas maksimal

% normalisasi data
    data(:,1) = data(:,1) / 30000000;
    data(:,2) = data(:,2) / 15000;
    data(:,3) = data(:,3) / 500000;
    data(:,4) = data(:,4) / 200;
    data(:,5) = data(:,5) / 40000;

%% Tentukan relasi antar kriteria
    % design 0.5 kali lebih penting daripada camera
    % design 0.5 kali lebih penting daripada battery
    % battery 0.25 kali lebih penting daripada camera

% Buat matriks dari relasi antar kriteria tersebut

   
%     relasiAntarKriteria = [ 1     3     5     5     9     1/5    5
%                             0     1     5     5     7     1/3    7
%                             0     0     1     1/5   1     1/9    1
%                             0     0     0     1     5     1/3    3
%                             0     0     0     0     1     1/9    1
%                             0     0     0     0     0      1     9
%                             0     0     0     0     0      0     1 ];
          
%% relasi imbang
    relasiAntarKriteria = [ 1     1     1    1  1
                            0     1     1    1  1
                            0     0     1    1  1
                            0     0     0    1  1
                            0     0     0    0  1];

%% Tentukan TFN, yaitu Triangular Fuzzy Number
    TFN = { [1     1     1  ] 	[1      1    1  ]
            [1/2   3/4   1  ] 	[1      4/3  2  ]
            [2/3   1     3/2] 	[2/3    1    3/2]
            [1     3/2   2  ] 	[1/2    2/3  1  ]
            [3/2   2     5/2] 	[2/5    1/2  2/3]
            [2     5/2   3  ] 	[1/3    2/5  1/2]
            [5/2   3     7/2] 	[2/7    1/3  2/5]
            [3     7/2   4  ] 	[1/4    2/7  1/3]
            [7/2   4     9/2] 	[2/9    1/4  2/7]};
   
%% Lakukan perhitungan rasio konsistensi
    RasioKonsistensi = HitungKonsistensiAHP(relasiAntarKriteria);

% Jika rasio konsistensi < 0.10, maka lakukan perhitungan berikutnya
    if RasioKonsistensi < 0.10
        % perhitungan bobot menggunakan metode Fuzzy AHP
        [bobotAntarKriteria, relasiAntarKriteria] = FuzzyAHP(relasiAntarKriteria, TFN);

        % Hitung nilai skor akhir 
%         data
%         bobotAntarKriteria
        ahp = data * bobotAntarKriteria';

        disp(" ")
        disp('Hasil Perhitungan dengan metode Fuzzy AHP')
        disp("+----------------------------------------------------------+------------+-------------------+");
        disp('| Nama Negara                                              | Skor Akhir | Kesimpulan        |')
        disp("+----------------------------------------------------------+------------+-------------------+");
        for i = 1:size(ahp, 1)
            % rentang kesimpulan nilai yang digunakan dalam perhitungan
                %   < 0.75     -> Kurang Direkomendasikan
                % 0.74 – 0.84  -> Cukup Direkomendasikan
                % 0.85 – 0.94  -> Direkomendasikan
                %   >= 0.95    -> Sangat Direkomendasikan
            
            if ahp(i) == 0
                status = 'Tidak Berpotensi ';
            elseif ahp(i) < 0.25
                status = 'Potensi Sedikit  ';
            elseif ahp(i) < 0.45
                status = 'Cukup Berpotensi ';
            elseif ahp(i) < 0.75
                status = 'Bepotensi        ';
            else
                status = 'Danger           ';
            end

            disp(['| ', char(namaNegara(i)), blanks(57 - cellfun('length',namaNegara(i))), '| ', ... 
                 num2str(ahp(i)), blanks(11 - length(num2str(ahp(i)))), '| ', ...
                 char(status),' |'])
        end
        disp("+----------------------------------------------------------+------------+-------------------+");
    end
    
% referensi
% modul praktikum
% https://piptools.net/algoritma-fuzzy-ahp/


    
    