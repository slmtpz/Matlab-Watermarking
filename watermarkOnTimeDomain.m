%% 1.1) Preprocessing
immatrix = imread('wm.bmp');
M = size(immatrix,1);
N = size(immatrix,2);
imarray = reshape(immatrix.', 1, numel(immatrix));
immatrix8bit = de2bi(imarray,8);
imarray8bit = reshape(immatrix8bit.', 1, numel(immatrix8bit));
hoppingsequence = [2 3 3 4 5];
[audioBytes,Fs] = audioread('son.wav');
audiowrite('son.flac',audioBytes,Fs,'BitsPerSample',8);
audioBytes = audioread('son.flac','native');

SNR_ORIGINAL = audioBytes;
%% 1.2) Watermark Embedding
leng = numel(imarray8bit);
for E = 1:leng
   hs = mod(E,5);
   if hs == 0
       %if mod gives 0, should take 5th element of hopping sequence.
       hs = 5;
   end
   n=hoppingsequence(hs);
   if(imarray8bit(E) == 1)
      audioBytes(4*E)=bitor(audioBytes(4*E),2^(n-1));
   else
      audioBytes(4*E)=bitand(audioBytes(4*E),255-2^(n-1));
   end
end

%ab = audioplayer(audioBytes,Fs);
%play(ab);

SNR_WATERMARKED = audioBytes;

%% 1.3) Watermark Extraction
extractedarray8bit = zeros(1,leng);
for E = 1:leng
   hs = mod(E,5);
   if hs == 0
       %if mod gives 0, should take 5th element of hopping sequence.
       hs = 5;
   end
   n=hoppingsequence(hs);
   extractedarray8bit(E) = bitand(audioBytes(4*E),2^(n-1))/2^(n-1);
end
extractedmatrix8bit = reshape(extractedarray8bit, 8, numel(extractedarray8bit)/8).';
extractedarray = bi2de(extractedmatrix8bit);
extractedmatrix = reshape(extractedarray, M, N).';
%I = mat2gray(extractedmatrix);
%imshow(I);


%% Calculating SNR
SNR = 10*log(sum(SNR_ORIGINAL.^2)/sum((SNR_WATERMARKED-SNR_ORIGINAL).^2));
% 84.3236