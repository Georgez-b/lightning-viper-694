# ---------- Base image ----------
FROM node:22-alpine

# ---------- Install dependencies ----------
RUN apk add --no-cache \
    git \
    ffmpeg \
    libwebp-tools \
    python3 \
    make \
    g++

# ---------- Clone the bot ----------
RUN echo "$(date)" && \
    git clone -b main https://github.com/souravkl11/raganork-md /rgnk

WORKDIR /rgnk

RUN mkdir -p temp

ENV TZ=Asia/Kolkata

# ---------- Install Node globals and dependencies ----------
RUN npm install -g --force yarn pm2 express
RUN yarn install

# ---------- Start Express keep-alive server + bot ----------
CMD node -e "const express=require('express');const app=express();app.get('/',(req,res)=>res.send('✅ Raganork-MD is alive!'));app.get('/healthz',(req,res)=>res.send('ok'));const PORT=process.env.PORT||3000;app.listen(PORT,'0.0.0.0',()=>console.log('🌐 Keep-alive running on',PORT));" & npm start
