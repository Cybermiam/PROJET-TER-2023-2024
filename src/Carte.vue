<template>
  <div v-if="!chargement">
    <div style="height:100vh; width:100vw">
      <l-map ref="map" v-model:zoom="zoom" :center="[45.571079, 6.342806]"  :use-global-leaflet="false">
        <l-tile-layer
          url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
          layer-type="base"
          name="OpenStreetMap"
        ></l-tile-layer>
        <l-geo-json  :geojson="tabPoints" @ready="onReady">
        </l-geo-json> 
      </l-map>
    </div>
  </div>
</template>

<script setup lang="ts" >
  //imports
  import { ref, watchEffect } from 'vue'
  import type SparqlJsQuery from './Model/sparqlJsQuery.js'
  import { LMap, LTileLayer, LGeoJson,LPopup } from "@vue-leaflet/vue-leaflet"
  import "leaflet/dist/leaflet.css";
  import { defineEmits } from 'vue'

  //props
  interface Properties {
      query: SparqlJsQuery
  } 

  //variables
  const properties = defineProps<Properties>()
  const query = properties.query
  const req = ref<any>()
  const result = ref<any[]>([])
  const tabPoints: { type: string; geometry: any; properties: { name: any} } [] = [] // chaque objet à l'interieur doit etre du type : type: string; geometry: any; properties: { name: any}, il est initialisé à vide
  const emit = defineEmits(['propertyChanged'])
  const chargement = ref<boolean>(false)
  const zoom = ref(9);

  //functions
  //fonction pour afficher la carte
  const onReady = (sites: any) => { 
    console.log('fonction ready, paramètre :', sites);
    // pour chaque calque de la carte (point), on lui associe une popup
    sites.eachLayer((layer: any) => { 
      layer.bindPopup(layer.feature.properties.name);
      layer.on('click', () => {
        emit('propertyChanged', layer.feature.properties.name);
      });
    });
  };

  //watcher pour recuperer les points
  watchEffect(execution)
  async function execution() {
      chargement.value = true
      req.value = query.getCoordonnees()
      const results = (await query.query(req.value)).results.bindings // pour exécuter la requête
      console.log ('lesresulatst de la requete :',results)
      result.value = results.map((element: any) => {  // transformation en map
        console.log(element.label.value)
        console.log('sans parse', element.coord.value)
        console.log('avec parse', JSON.parse(element.coord.value))
          return { // pour chaque element de results
              label: element.label.value, // 
              coord: JSON.parse(element.coord.value)
          }
      })
      console.log ('les resulats en map ', results)
      tabPoints.length = 0; // vider le tableau au cas ou la fonction est exécuté plusieur fois avant de le remplir
      for (let elem of result.value) { // pour chaque element de result
          let objet = { // on crée un objet conforme au format geoson pour plus tard
              type : "Feature",
              geometry : elem.coord,
              properties : {name : elem.label}
          }
          tabPoints.push(objet)
      }
      console.log('tabpoints : ',tabPoints)
      chargement.value = false
  }
</script>