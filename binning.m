function B = binning(A,n)

%PINNING pins PinningxPinning pixel together  
%--> new resolution = old resolution / Pinning^2
%
%A original image
%B pinned image
%n number of pixel pinned together

temp = filtfilt(ones(1,n), 1, A);
temp = filtfilt(ones(1,n), 1, temp(round(n/2):n:end,:)');
temp = temp/(n*n);
B = temp(round(n/2):n:end,:)';

