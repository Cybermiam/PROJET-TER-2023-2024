//imports
import { createApp } from 'vue'
import App from './App.vue'
import {Repository} from 'st-sparql-explorer'

//variables
const explorer = new Repository(new URL("http://localhost:8080/patrimalp/"))
const types =[
	{iri:"http://patrimalp.org/ontologies/patrimalp#Site", label:'Site'},
	{iri:"http://patrimalp.org/ontologies/patrimalp#Statue", label : 'Statue'}
]

//mounting the app
createApp(App,{explorer,types}).mount('#app')
