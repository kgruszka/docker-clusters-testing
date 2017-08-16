const http = require('http')
const HOST = '0.0.0.0'
const PORT = 3000

const requestHandler = (req, res) => {
    console.log(`Request received:`)
    let req_data = ""
    let json
    req.on('data', data => req_data += data)

    req.on('end', () => {
        json = JSON.parse(req_data)
        console.log('json', req_data)

        res.statusCode = 200
        res.end()
    })
}

const server = http.createServer(requestHandler)

server.listen(PORT, HOST, err => {
    if (err) return console.log('Error occured.', err)

    console.log(`Server is listening on ${PORT}`)
})

