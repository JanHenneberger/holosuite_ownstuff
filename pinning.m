function B = pinning(A,n)

%PINNING pins PinningxPinning pixel together  
%--> new resolution = old resolution / Pinning^2
%
%A original image
%B pinned image
%n number of pixel pinned together

i=1;
B=zeros(2*size(A));
while i < n
    s = size(B);
    B(1:2:s(1),1:2:s(2))=A;
    B(2:2:s(1),1:2:s(2))=A;
    B(1:2:s(1),2:2:s(2))=A;
    B(2:2:s(1),2:2:s(2))=A;
    i = i*2;
end

