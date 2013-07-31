function resp = callSoapService(endpoint,soapAction,message)
%callSoapService Send a SOAP message off to an endpoint.
%   callSoapService(ENDPOINT,SOAPACTION,MESSAGE) sends the MESSAGE, a Java DOM,
%   to the SOAPACTION service at the ENDPOINT.
%    
%   Example:
%
%   message = createSoapMessage( ...
%       'urn:xmethods-delayed-quotes', ...
%       'getQuote', ...
%       {'GOOG'}, ...
%       {'symbol'}, ...
%       {'{http://www.w3.org/2001/XMLSchema}string'}, ...
%       'rpc');
%   response = callSoapService( ...
%       'http://64.124.140.30:9090/soap', ...
%       'urn:xmethods-delayed-quotes#getQuote', ...
%       message);
%   price = parseSoapResponse(response)
%
%   See also createClassFromWsdl, createSoapMessage, parseSoapResponse.

% Matthew J. Simoneau, June 2003
% $Revision: 1.1.6.6 $  $Date: 2005/06/21 19:34:09 $
% Copyright 1984-2005 The MathWorks, Inc.

% Use inline Java to send the message.
import java.io.*;
import java.net.*;
import com.mathworks.mlwidgets.io.InterruptibleStreamCopier;

% Convert the dom to a byte stream.
toSend = serializeDOM(message);
toSend = java.lang.String(toSend);
b = toSend.getBytes('UTF8');

% Create the connection where we're going to send the file.
url = URL(endpoint);
httpConn = url.openConnection;

% Set the appropriate HTTP parameters.
httpConn.setRequestProperty('Content-Type','text/xml; charset=utf-8;');
httpConn.setRequestProperty('SOAPAction',soapAction);
httpConn.setRequestMethod('POST');

%% Set Session Cookies
global cookiesGTAS

%httpConn.setRequestProperty('User-Agent',['Matlab ' version]); 
%httpConn.setRequestProperty('Expect','100-continue');

for kk=length(cookiesGTAS):-1:1
    if strcmp(cookiesGTAS{kk}.url,endpoint)
        httpConn.setRequestProperty('Cookie',[cookiesGTAS{kk}.name '=' cookiesGTAS{kk}.value]);
        break;
    end      
end
%%

httpConn.setDoOutput(true);
httpConn.setDoInput(true);

try
    % Everything's set up; send the XML that was read in to b.
    outputStream = httpConn.getOutputStream;
    outputStream.write(b);
    outputStream.close;
catch
    exception = regexp(lasterr, ...
        'Java exception occurred: \n(.*?)\s*\n','tokens','once');
    if ~isempty(exception)
        exception = exception{1};
        if strcmp(exception, ...
                'java.net.ConnectException: Connection refused: connect')
            error('Connection refused.');
        end
        if strcmp(exception, ...
                'ice.net.URLNotFoundException: Document not found on server')
            error('The requested URL was not found on this server.')
        end
        host = regexp(exception,'java.net.UnknownHostException: (.*)','tokens','once');
        if ~isempty(host)
            error('Unknown host: %s',host{1})
        end
        error(exception)
    else
        rethrow(lasterror)
    end
end

    
try
    % Read the response.
    inputStream = httpConn.getInputStream;
    
%% Get Session Cookies
if (length(cookiesGTAS)>10) %Allow a maximum of 10 cookies
cookiesGTAS={};
end

cookie_str=httpConn.getHeaderField('Set-Cookie');
if cookie_str~=[]
    %Initialize cookie
    cookie.url='';  % TODO: separate into domain and path
    % TODO: cookie.expiration_timestamp=0;
    cookie.name='';
    cookie.value='';
    
    %Process response Set-Cookie header
    %%cookie_str = cookie_str.substring(0, cookie_str.indexOf(';'))
    cookie.url=endpoint;
    cookie.name = char(cookie_str.substring(0, cookie_str.indexOf('=')));
    cookie.value = char(cookie_str.substring(cookie_str.indexOf('=') + 1, cookie_str.length()));
    
    idx=length(cookiesGTAS)+1;
    for kk=1:length(cookiesGTAS)
        if(strcmp(cookiesGTAS{kk}.url,cookie.url) && strcmp(cookiesGTAS{kk}.name,cookie.name))
            idx=kk;
        end
    end
    %Save cookie
    cookiesGTAS{idx}=cookie;
    
end
%% 

    byteArrayOutputStream = java.io.ByteArrayOutputStream;
    % This StreamCopier is unsupported and may change at any time.
    isc = InterruptibleStreamCopier.getInterruptibleStreamCopier;
    isc.copyStream(inputStream,byteArrayOutputStream);
    inputStream.close;
    byteArrayOutputStream.close;
    
    % TODO: Handle attachments.
    % inputStream = httpConn.getInputStream
    % mimeHeaders = javax.xml.soap.MimeHeaders;
    % mimeHeaders.addHeader('Content-Type',httpConn.getHeaderField('Content-Type'));
    % messageFactory = javax.xml.soap.MessageFactory.newInstance;
    % message = messageFactory.createMessage(mimeHeaders,inputStream);

catch
    % Try to chop off the Java stack trace.
    message = lasterr;
    t = regexp(message,'java.io.IOException: (.*?)\n','tokens','once');
    if ~isempty(t)
        message = t{1};
    end
    
    % Try to get more info from a SOAP Fault.
    try
        isr = InputStreamReader(httpConn.getErrorStream,'UTF-8');
        in = BufferedReader(isr);
        stringBuffer = java.lang.StringBuffer;
        while true
            inputLine = in.readLine;
            if isempty(inputLine)
                break
            end
            stringBuffer.append(inputLine);
        end
        in.close;
        resp = stringBuffer.toString;
        try
            d = org.apache.xerces.parsers.DOMParser;
            d.parse(org.xml.sax.InputSource(java.io.StringReader(resp)));
            doc = d.getDocument;
            fault = char(doc.getElementsByTagName('faultstring').item(0).getTextContent);
        catch
            % Received some text, but couldn't extract the faultstring.
            % Use whatever text we've received.
            fault = char(resp);
        end
        message = ['SOAP Fault: ' fault];
    catch
        % Couldn't get the fault.  Stick with what we pulled from lasterr.
    end
    error(message)
end

% Leave the response as a java.lang.String so we don't squash Unicode.
resp = byteArrayOutputStream.toString('UTF-8');

%===============================================================================
function s = serializeDOM(x)
% Serialization through tranform.
domSource = javax.xml.transform.dom.DOMSource(x);
tf = javax.xml.transform.TransformerFactory.newInstance;
serializer = tf.newTransformer;
serializer.setOutputProperty(javax.xml.transform.OutputKeys.ENCODING,'utf-8');
serializer.setOutputProperty(javax.xml.transform.OutputKeys.INDENT,'yes');

stringWriter = java.io.StringWriter;
streamResult = javax.xml.transform.stream.StreamResult(stringWriter);

serializer.transform(domSource, streamResult);
s = char(stringWriter.toString);
