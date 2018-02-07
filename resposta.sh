mkdir mapa-ninja
cd mapa-ninja

npm install shapefile


npm install shapefile

#converte o arquivo .shp em .json
./node_modules/shapefile/bin/shp2json < shapeParaiba.shp > shapeParaiba.json

#deixando o shapefile ja projetado, para diminuir custos
npm install d3-geo-projection

./node_modules/d3-geo-projection/bin/geoproject 'd3.geoOrthographic().rotate([54, 14, -2]).fitSize([1000, 600], d)' < shapeParaiba.json > pb-ortho.json

#visualizando a projeção
./node_modules/d3-geo-projection/bin/geo2svg -w 1000 -h 600 < pb-ortho.json > pb-ortho.svg

#instalando o ndjson-split
npm install ndjson-cli

#convertendo o arquivo original em um json delimitado por linhas
./node_modules/ndjson-cli/ndjson-split 'd.features' < pb-ortho.json > pb-ortho.ndjson


npm install d3-dsv

#convertendo o arquivo com os dados do censo para ndjson
./node_modules/d3-dsv/bin/dsv2json -r ';' -n < Responsavel01_PB.csv > pb-censo.ndjson


#transformando o arquivo ndjson

#mesclando arquivos com os dados ao mapa



responsavel 1, mulheres responsaveis pelo domicilio





