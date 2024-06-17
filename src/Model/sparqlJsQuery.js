export default class SparqlJsQuery {

    //constructeur de la classe SparqlJsQuery
    constructor(url) {
        this.url = url;
    }

    //fonction query qui prend en paramètre une requête SPARQL et qui renvoie le résultat de la requête
    async query(query) {
        const response = await fetch(this.url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/sparql-query',
                accept: 'application/sparql-results+json',
            },
            body: query,
        });

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        return await response.json();
        

    }

    //fonction qui renvoie la requête SPARQL pour récupérer les information énumérées liées à un type
    enumPropertyQueryBuilder(type) {
        
        return `PREFIX owl: <http://www.w3.org/2002/07/owl#>
        PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
        PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
        PREFIX brocartsonto: <http://patrimalp.org/brocarts/onto#>
        PREFIX patrimalpo: <http://patrimalp.org/ontologies/patrimalp#>

        select ?p ?o ?enumValue where {
            ?p rdfs:domain patrimalpo:${type};
                rdfs:range skos:Concept;
                rdfs:range ?r.
                FILTER( STRSTARTS(str(?r),
                str("http://patrimalp.org/brocarts/thesaurus#")) )
            ?enumValue a ?r;
                    skos:prefLabel ?o.

        }  ORDER BY ?p ?o`;
    }

    //fonction qui renvoie la requête SPARQL pour récupérer les information litérales liées à un type
    dataPropertyQueryBuilder(type) {
        return `PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

        PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
        PREFIX brocartsonto: <http://patrimalp.org/brocarts/onto#>
        PREFIX edytem: <http://example.org/edytem#>
        
        select  ?p  ?o where {
             ?s rdf:type <http://patrimalp.org/ontologies/patrimalp#${type}>.
             ?s ?p ?o.
            OPTIONAL {?p rdfs:label ?label. FILTER (lang(?label) = 'fr')}
             FILTER isLiteral(?o)
        } ORDER BY ?p`;
    }

    //fonction qui renvoie la requête SPARQL pour afficher les résultats
    queryContrsuctResultat(type, filtersMap) {
        let query=`PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
        PREFIX : <http://patrimalp.org/ontologies/patrimalp#>
        PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
        
        PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
        PREFIX brocartsonto: <http://patrimalp.org/brocarts/onto#>
        PREFIX patrimalpo: <http://patrimalp.org/ontologies/patrimalp#>
        PREFIX edytem: <http://example.org/edytem#>
        
        PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
        
        
        select DISTINCT  ?label where {
            ?s rdf:type patrimalpo:${type}.
            ?s    rdfs:label ?label.`
        filtersMap.forEach((property, key) => {

            if (key != "label"){
                query += `?s brocartsonto:${key} ?${key}.`
            }

            if (key == "creationDate"){
                query += `FILTER (?${key} in (`
                property.forEach((value) => {
                    query += `"${value.value}"^^xsd:date,`
                })
                query = query.slice(0, -1)
                query += `))`
            } else if (key == "material"|key == "denomination"|key == "protectionLevel"){
                query += `FILTER (?${key} in (`
                property.forEach((value) => {
                    query += `<${value.value}>,`
                })
                query = query.slice(0, -1)
                query += `))`
            } else {
                query += `FILTER (?${key} in (`
                property.forEach((value) => {
                    query += `"${value.value}",`
                })
                query = query.slice(0, -1)
                query += `))`
            }
        })
        query+= `}  ORDER BY ?label`
        console.log(query)    
        return query;
    }

    //fonction qui renvoie la requête SPARQL pour afficher les infos d'une oeuvre
    getInfosOeuvre(label,type){
        // console.log("uri : ",uri)
        // console.log("label : ",label)
        let query=`PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
        PREFIX : <http://patrimalp.org/ontologies/patrimalp#>
        PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
        PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
        PREFIX brocartsonto: <http://patrimalp.org/brocarts/onto#>
        PREFIX patrimalpo: <http://patrimalp.org/ontologies/patrimalp#>
        PREFIX edytem: <http://example.org/edytem#>
        PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>


        select DISTINCT   ?label ?creationDate ?materiaux ?dim ?period ?denomLabel ?PLLabel where {
        # http://patrimalp.org/ontologies/patrimalp#Scuplture
        ?s rdf:type patrimalpo:${type}.
        ?s    rdfs:label ?label.
        
        `
        if(type == "Sculpture"){
            query += `?s brocartsonto:creationDate ?creationDate.
            ?s brocartsonto:material ?mat. ?mat skos:prefLabel ?materiaux.
            ?s brocartsonto:dimensions ?dim.
            ?s brocartsonto:period ?period.
            ?s brocartsonto:denomination ?denom.
            ?denom skos:prefLabel ?denomLabel.
            ?s brocartsonto:protectionLevel ?PL.
            ?PL skos:prefLabel ?PLLabel.
            `
        }
        
        query+= `FILTER(?label in ("${label}"))}`

        return query;
    }

    //fonction qui renvoie la requête SPARQL pour récupérer les coordonnées des sites pour la carte
    getCoordonnees(){
        let query = 
        `
            PREFIX :           <http://patrimalp.org/graph/>
            PREFIX geo:        <http://www.opengis.net/ont/geosparql#>
            PREFIX owl:        <http://www.w3.org/2002/07/owl#>
            PREFIX patrimalpo: <http://patrimalp.org/ontologies/patrimalp#>
            PREFIX patrimalpr: <http://patrimalp.org/resource/>
            PREFIX rdf:        <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
            PREFIX rdfs:       <http://www.w3.org/2000/01/rdf-schema#>
            PREFIX wikidata:   <https://www.wikidata.org/entity/>
            PREFIX xsd:        <http://www.w3.org/2001/XMLSchema#>
            SELECT ?label ?coord
            WHERE {
                ?p rdf:type patrimalpo:Site.
                ?p rdfs:label ?label.
                ?p geo:hasGeometry ?hasGeometry.
                ?hasGeometry geo:asGeoJSON ?coord.
            }`
        return query; 
    }

    //fonction qui renvoie le label d'une URI en fonction de la forme link#label
    getLabelFromUri(uri){
        let parts = uri.split('#');
        let label = parts[1];
        return label;
    }

    //fonction qui renvoie une map de filtres pour chaque type
    async getAllfilters(types) {
        //Map de retour dont la structure est : Map<type, Map<propriété, {value: null, options: []}>>
        let allTypesMap = new Map();
        //pour chaque propriété
        for (var type of types) {
            //variables pour chaque type
            let filterProperties = [];
            let filtersMap = new Map();

            //on fait les deux requêtes
            let enumQuery = this.enumPropertyQueryBuilder(type);
            console.log(enumQuery);
            let dataQuery = this.dataPropertyQueryBuilder(type)
            console.log(dataQuery);
            let enumResponse = (await this.query(enumQuery)).results.bindings;
            console.log(enumResponse);
            let dataResponse = (await this.query(dataQuery)).results.bindings;
            console.log(dataResponse);
            let allResponse = enumResponse.concat(dataResponse);

            //on récupère les noms des propriétés
            for (var ligne of allResponse) {
                let propertyLabel = this.getLabelFromUri(ligne["p"].value);
                if (!filterProperties.includes(propertyLabel)) {
                    filterProperties.push(propertyLabel);    
                }
            }
            
            //puis on récupère les valeurs des propriétés
            for (var prop of filterProperties) {

                let selectObject = {value : null, options: []};
    
                for (var ligne of allResponse) {
                    if (this.getLabelFromUri(ligne["p"].value) == prop) {
                        let option;
                        if (ligne["enumValue"]) {
                            option = {label: ligne["o"].value, value: ligne["enumValue"].value}
                        } else {
                            option = {label: ligne["o"].value, value: ligne["o"].value}
                        }
                        if (! selectObject.options.find(o => o.value === option.value)) {
                            selectObject.options.push(option);
                        }
                    }
                }
                
                filtersMap.set(prop, selectObject);
                
            }
            //on stocke les filtres pour le type dans la map de retour
            allTypesMap.set(type, filtersMap);
        }
        return allTypesMap;
    }
}