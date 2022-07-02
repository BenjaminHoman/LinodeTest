from http.server import HTTPServer, BaseHTTPRequestHandler
import sys

class MyHandler(BaseHTTPRequestHandler):
	def do_GET(self):
		self.send_response(200)
		self.end_headers()
		self.wfile.write("Hello From Linode".encode("utf-8"))

port = None
try:
	port = int(sys.argv[1])
except:
	print("Error setting port from arg")
	sys.exit(1)

print("Running HTTP Server on PORT", port)
httpd = HTTPServer(('',  port), MyHandler)
httpd.serve_forever()
