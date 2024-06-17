//imports
import { createApp } from 'vue'
import Main from './Main.vue'
import naive from 'naive-ui'
import {Repository} from 'st-sparql-explorer'

//variables
const explorer = new Repository(new URL("http://localhost:8080/newPatrimalp/"))
const types =[
	{iri:"http://patrimalp.org/ontologies/patrimalp#Site", label:'Site'},
	{iri:"http://patrimalp.org/ontologies/patrimalp#Sculpture", label : 'Sculpture'},
	{iri:"http://patrimalp.org/brocarts/onto#Brocade", label : 'Brocade'}
]

//mounting the app
createApp(Main,{explorer,types}).use(naive).mount('#app')
