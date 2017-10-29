const http = require('http')
const STORAGE_HOST = process.env.STORAGE_HOST
const STORAGE_PORT = process.env.STORAGE_PORT
const STORAGE_PATH = process.env.STORAGE_PATH
const STORAGE_AUTH = process.env.STORAGE_AUTH
const HOST = '0.0.0.0'
const PORT = 3000

const requestHandler = (req, res) => {
    console.log(`Request received:`)
    let req_data = ""
    let json
    req.on('data', data => req_data += data)

    req.on('end', () => {
        console.log('json', req_data)
        saveTestResult(req_data, (e) => {
            res.status = e ? 500 : 200
            res.end()
        })
    })
}

function saveTestResult(data, cb) {
    const postData = JSON.stringify({
        timestamp: Date.now(),
        data: JSON.parse(data)
    });

    const options = {
        hostname: STORAGE_HOST,
        port: STORAGE_PORT,
        path: `/${STORAGE_PATH}`,
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Content-Length': Buffer.byteLength(postData),
            'Authorization': 'Basic ' + STORAGE_AUTH
        }
    };

    const req = http.request(options, (res) => {
        console.log(`STATUS: ${res.statusCode}`);
        console.log(`HEADERS: ${JSON.stringify(res.headers)}`);
        res.setEncoding('utf8');
        res.on('data', (chunk) => {
            console.log(`BODY: ${chunk}`);
        });
        res.on('end', () => {
            console.log('No more data in response.');
            cb();
        });
    });

    req.on('error', (e) => {
        console.error(`problem with request: ${e.message}`);
        cb(e);
    });

    req.write(postData);
    req.end();
}

const server = http.createServer(requestHandler)

server.listen(PORT, HOST, err => {
    if (err) return console.log('Error occured.', err)

    console.log(`Server is listening on ${PORT}`)
})

