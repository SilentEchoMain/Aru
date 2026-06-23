param(
    [int]$Port = 8017,
    [string]$Bind = "127.0.0.1"
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot

function Fail($message) {
    Write-Error $message
    exit 1
}

if (!(Get-Command node -ErrorAction SilentlyContinue)) {
    Fail "Node.js is required to serve the Aru site."
}

$normalizedRoot = ($root -replace "\\", "/")
$code = @"
const http = require('http');
const fs = require('fs');
const path = require('path');

const root = '$normalizedRoot';
const rootDir = path.resolve(root);
const port = $Port;
const bind = '$Bind';
const types = {
  '.html': 'text/html; charset=utf-8',
  '.tsv': 'text/tab-separated-values; charset=utf-8',
  '.md': 'text/plain; charset=utf-8',
  '.ps1': 'text/plain; charset=utf-8',
  '.yml': 'text/plain; charset=utf-8'
};

const server = http.createServer((request, response) => {
  const url = new URL(request.url, 'http://' + bind + ':' + port);
  let pathname = decodeURIComponent(url.pathname);
  if (pathname === '/') pathname = '/index.html';

  const relative = pathname.replace(/^\/+/, '');
  const file = path.resolve(rootDir, relative);
  if (file !== rootDir && !file.startsWith(rootDir + path.sep)) {
    response.writeHead(403, { 'Content-Type': 'text/plain; charset=utf-8' });
    response.end('Forbidden');
    return;
  }

  fs.readFile(file, (error, data) => {
    if (error) {
      response.writeHead(404, { 'Content-Type': 'text/plain; charset=utf-8' });
      response.end('Not found');
      return;
    }
    response.writeHead(200, { 'Content-Type': types[path.extname(file)] || 'application/octet-stream' });
    response.end(data);
  });
});

server.listen(port, bind, () => {
  console.log('Aru site: http://' + bind + ':' + port + '/');
});
"@

Write-Output "Serving Aru at http://$Bind`:$Port/"
& node -e $code
