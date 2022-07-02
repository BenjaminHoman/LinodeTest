from http.server import HTTPServer, BaseHTTPRequestHandler
import sys

class MyHandler(BaseHTTPRequestHandler):
	def do_GET(self):
		self.send_response(200)
		self.end_headers()
		self.wfile.write(bytes("Hello From Linode"))


print("Running HTTP Server on PORT 8000")
httpd = HTTPServer(('localhost',  8000), MyHandler)
httpd.serve_forever()
