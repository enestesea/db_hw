{\rtf1\ansi\ansicpg1251\cocoartf2759
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww28600\viewh16380\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 SELECT v.maker, v.model\
FROM vehicle v\
JOIN motorcycle m ON v.model = m.model\
WHERE m.horsepower > 150 \
AND m.price < 20000 \
AND m.type = 'Sport'\
ORDER BY m.horsepower DESC;\
}