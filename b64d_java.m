function x=b64d(y)

%NO CHUNKING
%x1=javax.xml.bind.DatatypeConverter.parseBase64Binary(y);

%CHUNKING
import org.apache.commons.codec.binary.*
b64=org.apache.commons.codec.binary.Base64;
x1=b64.decodeBase64(uint8(y));


x=double(typecast(x1,'int16').');