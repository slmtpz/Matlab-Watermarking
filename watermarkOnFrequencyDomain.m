%% 3.1) Preprocessing
immatrix = imread('wm.bmp');
M = size(immatrix,1);
N = size(immatrix,2);
imarray = reshape(immatrix.', 1, numel(immatrix));
[audioBytes,Fs] = audioread('son.wav');

bins=20000;
FD=fft(audioBytes,20000); %20K bins
F = ((0:1/bins:1-1/bins)*Fs).'; %(Fs*(-bins/2:bins/2-1)/bins).';


%% 3.2) Watermark Embedding
leng = numel(imarray);
for E = 1:leng
    if(E<100)
        index = E;
    elseif(E>=100 && E<1300)
        index = E+900;
    elseif(E>=1300)
        index = E+5900;
    end
    amp = abs(FD(index));
    newAmp = amp + imarray(E);
    theta = angle(FD((index)|(Fs-index)));
    FD((index)|(Fs-index)) = amp.*exp(1i*theta);
end

%% Calculating SNR
%SNR = 10*log(sum(SNR_ORIGINAL.^2)/sum((SNR_WATERMARKED-SNR_ORIGINAL).^2));
% 41.6420