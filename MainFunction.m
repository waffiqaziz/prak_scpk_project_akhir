% link dataset : https://www.kaggle.com/varpit94/latest-covid19-data-updated-till-22june2021
function hasil = MainFunction()
%% clear terminal
clc
clear


%% read table kolom ppertama
    dataNamaNegara = readtable('WHO COVID-19 global table data June 22nd 2021 at 10.52.14 PM.csv','Range','A3:A239');

    % ubah ke bentuk cell
    namaNegara = table2cell(dataNamaNegara);

    %read table kolom 3-7
    data = readtable('WHO COVID-19 global table data June 22nd 2021 at 10.52.14 PM.csv','Range','C3:G239');
    
    %ubah ke bentuk array/matrix
    data = table2array(data);


% batas maksimal
    %--
    
%% normalisasi data
    data(:,1) = data(:,1) / 30000000;
    data(:,2) = data(:,2) / 15000;
    data(:,3) = data(:,3) / 500000;
    data(:,4) = data(:,4) / 200;
    data(:,5) = data(:,5) / 40000;

%% Tentukan relasi antar kriteria
    %--

% Buat matriks dari relasi antar kriteria tersebut
    %--
   
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

%         disp(" ")
%         disp('Hasil Perhitungan dengan metode Fuzzy AHP')
%         disp("+----------------------------------------------------------+------------+-------------------+");
%         disp('| Nama Negara                                              | Skor Akhir | Kesimpulan        |')
%         disp("+----------------------------------------------------------+------------+-------------------+");
        

        for i = 1:size(ahp, 1)

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
            
            % save status into cell array
            hasilStatus{i} = status;
            
%             disp(['| ', char(namaNegara(i)), blanks(57 - cellfun('length',namaNegara(i))), '| ', ... 
%                  num2str(ahp(i)), blanks(11 - length(num2str(ahp(i)))), '| ', ...
%                  char(status),' |'])
        end
        disp("+----------------------------------------------------------+------------+-------------------+");
    end
    
    %% bentuk table hasil
        % sort ahp tertinggi
        [ahp,sortIdx] = sort(ahp,'descend');
        
        % ubah ke format yang diperlukan
        tempAHP = table(ahp); % simpan dan ubah ke betuk tabel
        tempAHP = table2cell(tempAHP); % ubah kebentuk cell
        
        % reshape cell arrays from 1 x 237 to 237 x 1
        hasilStatus = (reshape(hasilStatus,[237,1]));
        
        % ubah format ahp
        fun = @(x) sprintf('%0.9f', x);
        longAHP = cellfun(fun, tempAHP, 'UniformOutput',0);
        
        % sort nama dan status berdasarkan index dari AHP
        namaNegara = namaNegara(sortIdx); 
        hasilStatus = hasilStatus(sortIdx); 
        
        % merge array       
        hasilTemp = [namaNegara,longAHP,hasilStatus];   
%         hasilTemp = cell2table(hasilTemp);

        % hapus baris pertama cell array
        hasilTemp([1],:) = [];

        hasil = hasilTemp;
end

    
    