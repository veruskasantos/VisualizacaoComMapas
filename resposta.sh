mkdir mapa-ninja
cd mapa-ninja

npm install shapefile


npm install shapefile

#converte o arquivo .shp em .json
./node_modules/shapefile/bin/shp2json 25SEE250GC_SIR.shp -o shapeParaiba.json

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

#VOLTAR: O QUE EH ISSO? CADE ESSES ATRIBUTOS?
#transformando arquivo ndjson, adicionando chave Cod_setor
./node_modules/ndjson-cli/ndjson-map 'd.Cod_setor = d.properties.CD_GEOCODI, d' < pb-ortho.ndjson > saida-ortho-sector.ndjson

#mesclando arquivos dos dados ao mapa
./node_modules/ndjson-cli/ndjson-join 'd.Cod_setor' saida-ortho-sector.ndjson pb-censo.ndjson > censo-mapa.ndjson

#organizando o arquivo e deixando um objeto por linha
./node_modules/ndjson-cli/ndjson-map 'd[0].properties = {responsaveis: Number(d[1].V094.replace(",", "."))}, d[0]' < censo-mapa.ndjson > pb-ortho-comdado.ndjson

npm install topojson

#compactando o arquivo
./node_modules/topojson/node_modules/topojson-server/bin/geo2topo -n tracts=pb-ortho-comdado.ndjson > pb-tracts-topo.json

#simplificando ainda mais e quantizando a geometria do json
./node_modules/topojson/node_modules/topojson-simplify/bin/toposimplify -p 1 -f < pb-tracts-topo.json | ./node_modules/topojson/node_modules/topojson-client/bin/topoquantize 1e5 > pb-quantized-topo.json

npm install d3
npm install d3-scale-chromatic

#gerando <FINALMENTE> o gráfico svg
./node_modules/topojson/node_modules/topojson-client/bin/topo2geo tracts=- < pb-quantized-topo.json | ./node_modules/ndjson-cli/ndjson-map -r d3 'z = d3.scaleSequential(d3.interpolateViridis).domain([0, 6]), d.features.forEach(f => f.properties.fill = z(f.properties.responsaveis)), d' | ./node_modules/ndjson-cli/ndjson-split 'd.features' | ./node_modules/d3-geo-projection/bin/geo2svg -n --stroke none -w 1000 -h 600 > pb-tracts-threshold-light.svg

#</end>