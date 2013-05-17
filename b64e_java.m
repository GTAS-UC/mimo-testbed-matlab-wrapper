function y=b64e(x)

x1=typecast(int16(x),'uint8');

%NO CHUNKING
%y=char(javax.xml.bind.DatatypeConverter.printBase64Binary(x1));

%CHUNKING
import org.apache.commons.codec.binary.*
b64=org.apache.commons.codec.binary.Base64;
y=char(b64.encodeBase64(x1,true).');
y(y==13)=[];