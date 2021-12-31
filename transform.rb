#require 'rdf/raptor'
require 'linkeddata'
require 'sparql'
require 'sinatra'
require 'rest-client'
require 'json'
require 'erb'
require 'open3'


  MAPPING = {
    'application/ld+json' => 'jsonld',
	  'text/n3'=> 'n3' ,
    'application/n-quads' => 'nquads',
	  "application/n-triples" => 'ntriples',
	  "application/xhtml+xml" => 'rdfa',
	  "application/rdf+xml" => 'rdfxml',
	  "text/turtle" => 'turtle'
	   }

get '/' do
  erb :index, { :locals => params, :layout => :layout, :content_type => :html }
  
end

post '/' do
  transform
  erb :renderme, {:layout => false, :content_type => @accept}
end


def transform
  @prefixes = 'foaf:http://xmlns.com/foaf/0.1/,  dc:http://purl.org/dc/terms/,  spar:http://purl.org/spar/datacite/,  sio:http://semanticscience.org/resource/,  dcat:http://www.w3.org/ns/dcat#,  re:http://www.re3data.org/schema/3-0#,  fdp:http://rdf.biosemantics.org/ontologies/fdp-o#,  ldp:http://www.w3.org/ns/ldp#,  rdf:http://www.w3.org/1999/02/22-rdf-syntax-ns#,  rdfs:http://www.w3.org/2000/01/rdf-schema#,obo:http://purl.obolibrary.org/obo/'
  $stderr.puts request.env
  @content = request.env["CONTENT_TYPE"]
  @accept = request.env["HTTP_ACCEPT"]
  
  
  $stderr.puts "Content: #{@content} ACCEPT #{@accept}"
  
  @intype = map(@content)
  @outtype = map(@accept)

  $stderr.puts "Content: #{@intype} ACCEPT #{@outtype}"
  
  if @intype and @outtype
    rundistiller
  else 
    @rdfdata = ""
  end
  
end

def rundistiller
  body = request.body.read
  File.open("temp.rdf", "w") {|f| f.write(body)}
  distiller = "rdf serialize --input-format #{@intype} --output-format #{@outtype} --prefixes '#{@prefixes}' temp.rdf"

  $stderr.puts distiller
  
  @rdfdata, s = Open3.capture2(distiller); s = s
  $stderr.puts @rdfdata
    
end


def map(thistype)
  return "" unless thistype
  thistype= thistype.downcase
  disttype = MAPPING[thistype]
  return disttype
end