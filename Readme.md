# RDF Syntax Transformer

Uses Kellogg's Ruby Distiller (https://github.com/ruby-rdf/) to transform an incoming RDF syntax into a different RDF syntax.  Useful for languages that don't have full support for all syntaxes.  Uses HTTP Headers (content-type and accept) to define the transformation.  POST body contains input, response body contains output.

For example:

`curl -L -X POST --data-binary @dataset.xml -H "Accept: text/turtle" -H "Content-type: application/rdf+xml" http://localhost:4567`

# Usage

Docker compose:

```
version: "3"
services:

  rdf-transform:
    image: markw/rdf-transform:0.0.1
    restart: always
    hostname: rdf-transform
    ports:
      - 4567:4567
```

# Acceptable types

```
'application/ld+json' => 'jsonld',
'text/n3'=> 'n3' ,
'application/n-quads' => 'nquads',
"application/n-triples" => 'ntriples',
"application/xhtml+xml" => 'rdfa',
"application/rdf+xml" => 'rdfxml',
"text/turtle" => 'turtle'
```

# Known Prefixes

By default, Distiller will create "random" prefixes for all namespaces, unless they are otherwise defined.  In this image, the following prefixes are defined:

```
foaf:http://xmlns.com/foaf/0.1/,  
dc:http://purl.org/dc/terms/,  
spar:http://purl.org/spar/datacite/,  
sio:http://semanticscience.org/resource/,  
dcat:http://www.w3.org/ns/dcat#,  
re:http://www.re3data.org/schema/3-0#,  
fdp:http://rdf.biosemantics.org/ontologies/fdp-o#, 
 ldp:http://www.w3.org/ns/ldp#,  
rdf:http://www.w3.org/1999/02/22-rdf-syntax-ns#,  
rdfs:http://www.w3.org/2000/01/rdf-schema#,
obo:http://purl.obolibrary.org/obo/
```

At this time, there is no way to enhance this list... add an issue or pull request to the GitHub if you want additional ones
