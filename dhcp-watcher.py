import pyinotify, time, os

wm = pyinotify.WatchManager()  # Watch Manager
mask = pyinotify.IN_MODIFY  # watched events

class EventHandler(pyinotify.ProcessEvent):
    def process_IN_MODIFY(self, event):
	time.sleep(3)
	os.system('clear')
	f = file('/tmp/dhcp.leases')        
	print f.read()
	f.close()

handler = EventHandler()
notifier = pyinotify.Notifier(wm, handler)
wdd = wm.add_watch('/tmp/dhcp.leases', mask, rec=True)

f = file('/tmp/dhcp.leases')        
print f.read()
f.close()

notifier.loop()
