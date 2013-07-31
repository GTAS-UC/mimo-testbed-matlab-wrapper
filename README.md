mimo-testbed-matlab-wrapper
===========================

How to use it
-------------


Performance issues
------------------
Small packets suffer from unnecesary 200 ms delays imposed by the Windows TCP stack.

The tweak below allows for tweaking or disabling Nagle's alogrithm. Disabling "nagling" allows for very small packets to be transferred immediately without delay. Note that is only recommended for some games, and it may have negative impact on file transfers/throughput. The default state (Nagling enabled) improves performance by allowing several small packets to be combined together into a single, larger packet for more efficient transmission. While this improves overall performance and reduces TCP/IP overhead, it may briefly delay transmission of smaller packets. Keep in mind that disabling Nagle's algorithm may have some negative effect on file transfers, and can only help reduce delay in some games. To implement this tweak, in the registry editor (Start>Run>regedit) find:
 
This setting configures the maximum number of outstanding ACKs in Windows XP/2003/Vista/2008:
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\{NIC-id}
There will be multiple NIC interfaces listed there, for example: {1660430C-B14A-4AC2-8F83-B653E83E8297}. Find the correct one with your IP address listed. Under this {NIC-id} key, create a new DWORD value:
TcpAckFrequency=1 (DWORD value, 1=disable, 2=default, 2-n=send ACKs if outstanding ACKs before timed interval. Setting not present by default).
 
For gaming performance, recommended is 1 (disable). For pure throughput and data streaming, you can experiment with values over 2. If you try larger values, just make sure TcpAckFrequency*MTU is less than RWIN, since the sender may stop sending data if RWIN fills without an acknowledgement.
 
Also, find the following key (if present):
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSMQ\Parameters
Add a new DWORD value:
TCPNoDelay=1 (DWORD value, 0 to enable Nagle's algorithm, 1 to disable, not present by default)
 
To configure the ACK interval timeout (only has effect if nagling is enabled), find the following key:
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\{NIC-id}
TcpDelAckTicks=0  (DWORD value, default=2, 0=disable nagling, 1-6=100-600 ms). Note you can also set this to 1 to reduce the nagle effect from the default of 200ms without disabling it.
 
For Windows NT SP4, the TcpDelAckTicks path is:
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\{NIC-id}\Parameters\Tcpip
TcpDelAckTicks=0 (Default=2, 0=disables nagling, 1-6=100-600 ms) 

XP/2003 needs hotfix or SP2 for it to work (MS KB 815230)
Vista needs hotfix or SP1 for it to work (MS KB 935458)

ToDo
----

- Is SetEndpoint strictly necessary?
