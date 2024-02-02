// LEVANTAR UN SERVIDOR MUY SENCILLO
const express = require('express')
const app = express()

// PETICIONES/REQUEST
app.get('/' , (req,res) =>{
    res.send('<h2> USAMOS UN VOLUMEN ANONIMO </h2>')
})

const port = process.env.PORT || 3000

app.listen(port, () => 
    console.log('server listening on port: ' , `http://localhost:${port}` )
)