const express = require('express')

const app = express()
const port =  process.env.PORT || 3000

const onePixel = './1x1.png';
const twoPixels = './2x2.png';
const orangesImage = './oranges.jpg'
// const __dirname = dirname(__filename);

app.get('/', (req, res) => {
  res.send('Hello World!')
})

app.get('/1x1', (req, res) => {
     console.log('1x1 pixel image at ' + Date.now());
    return res.sendFile(onePixel, {root: __dirname} );
})

app.get('/2x2', (req, res) => {
     console.log('2x2 pixel image at ' + Date.now());
    return res.sendFile(twoPixels, {root: __dirname} );
})

app.get('/oranges', (req, res) => {
     console.log('oranges at ' + Date.now());
    return res.sendFile(orangesImage, {root: __dirname} );
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})
