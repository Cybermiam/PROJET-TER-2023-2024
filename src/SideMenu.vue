<script setup lang="ts">
  //imports
  import {  h, ref, unref, computed, reactive } from 'vue'
  import type { Component} from 'vue'
  import { NIcon } from 'naive-ui'
  import type { MenuOption, SwitchProps } from 'naive-ui'
  import type { SelectOption } from 'naive-ui'
  import {
    MapOutline as carteIcon,
    GitMergeOutline as grapheIcon,
    FilterOutline as filtresIcon,
    CodeSlashOutline as sparIcon,
    HomeOutline as homeIcon,
    ReceiptOutline as affichageResultatsIcon,
    InformationCircleOutline as InfosOeuvre
  } from '@vicons/ionicons5'
  import Filters from './Filters.vue'
  import type SparqlJsQuery from './Model/sparqlJsQuery.js'
  import type {Repository, Resource} from 'st-sparql-explorer'
  import Carte from './Carte.vue'
  import Graphe from './Graphe.vue'
  import Sparnatural from './Sparnatural.vue'
  import Home from './Home.vue'
  import AffichageResultats from './AffichageResultats.vue'
  import infoRessource from './InfoRessource.vue'
  import {NSplit,  type SplitProps} from 'naive-ui'

  //props
  interface Properties {
      query: SparqlJsQuery;
      explorer: Repository;
      types: ArrayLike<Resource> & Iterable<Resource>;
    }

  //variables
  const splitOptions : SplitProps ={
      themeOverrides : {
          resizableTriggerColor: '#289373',
          resizableTriggerColorHover: ' #289373',
      }
  }
  const switchStyle : SwitchProps = {
      themeOverrides: {
      railColorActive : ' #289373 ',
    }
  }

  const properties = defineProps<Properties>();
  const explorer = unref(properties.explorer);
  const types = unref(properties.types);
  const query = unref(properties.query);
  const filtersMap = ref<Map<string, SelectOption[]>>(new Map());
  const firstType = ref<string>("Site");
  const labelRecherche = ref<string>("");
  const showPopconfirm = ref(false)

  type VisibleCompoType = { //pour défniir le type composants visibles
    home: boolean;
    carte: boolean;
    graphe: boolean;
    sparnatural: boolean;
    filters: boolean;
    affichageResultats: boolean;
    infoRessource: boolean;
    [key: string]: boolean; // peut avoir n'imporet quelle autres clé de type string : boolean
  };

  const visibleCompo = ref<VisibleCompoType>({ // visible compo est de type VisibleCompoType, on initialise chaque clé
    home : true,
    carte: false,
    graphe: false,
    sparnatural: false,
    filters: false,
    affichageResultats: false,
    infoRessource: false
  });

  const menuOptions: MenuOption[] = [
    { label: renderLabel('Accueil', 'home'), key: 'home', icon: renderIcon(homeIcon, 'home')},
    { label: renderLabel('Carte', 'carte'), key: 'carte', icon: renderIcon(carteIcon, 'carte')} ,
    { label: renderLabel('Graphe', 'graphe'), key: 'graphe', icon: renderIcon(grapheIcon , 'graphe')},
    { label: renderLabel('Filters', 'filters'), key: 'filters', icon: renderIcon(filtresIcon  , 'filters')},
    { label: renderLabel('Sparnatural', 'sparnatural'), key: 'sparnatural', icon: renderIcon(sparIcon , 'sparnatural')},
    { label: renderLabel('Affichage des résultats', 'affichageResultats'), key: 'affichageResultats', icon: renderIcon(affichageResultatsIcon , 'affichageResultats')},
    { label: renderLabel('Détails d\'une ressource', 'infoRessource'), key: 'infoRessource', icon: renderIcon(InfosOeuvre, 'infoRessource')}

  ]

  //functions
  function renderIcon(icon: Component, key: keyof VisibleCompoType) {
    return () => h(NIcon, { 
    color: visibleCompo.value[key] ? ' #289373  ' : '',
    style: visibleCompo.value[key] ? 'background-color: #c8e2cc  ;' : ''
  }, { default: () => h(icon) });
  }

  function renderLabel (label: string, key: keyof VisibleCompoType) {
    return () => h('div', { style: visibleCompo.value[key] ? 'color:    #289373   ; font-weight: 650; ' : '' }, label)

  }

  const visibleCompoListe = computed(() => {
    let keys = Object.keys(visibleCompo.value).filter(key => visibleCompo.value[key]);
    let composants = []
    for (let key of keys) { // pour toutes les clés de la liste des clés active
      switch (key) {
        case 'home':
          composants.push({compo: Home, props : {essai:'je suis lessai'}, event : {click : fonctionTestEvent}});
        break;
        case 'filters':
          composants.push({compo : Filters, props : {explorer:explorer, types :types , query:query}, event: {propertyChanged : handlePropertyChanged }});
        break;
        case 'sparnatural':
          composants.push({compo : Sparnatural , props : {}, event :{}});
        // var props = {firstType}; var emits = {"propertyChanged":handlePropertyChanged};
        break;
        case 'affichageResultats':
          composants.push(reactive({compo : AffichageResultats, props :{query:query, firstType:firstType, filtersMap:filtersMap}, event : {propertyChanged : handleAffichage}}));
        break;
        case 'infoRessource':
          composants.push(reactive({compo : infoRessource , props : {query: query, labelRecherche: labelRecherche, firstType: firstType}, event : {}}));
        break;
        case 'carte':
          composants.push({compo :Carte, props : {query: query}, event : {propertyChanged : handleMapClick}});
        break;
        case 'graphe':
          composants.push({compo : Graphe, props : {}, event :{}});
        break;
        
        
      }
    }
    console.log ('voici les composants dans visibleCompoListe : ',composants)
    return composants
  });

  const collapsed = ref(true)

  const visibleCount = computed(() => { 
    return Object.keys(visibleCompo.value).reduce((count, key) => {  // créer un tableau de toutes les clés de visibleCompo et les réduit
      return count + (visibleCompo.value[key] ? 1 : 0); // parcourt toutes les clés du tableau visibleCompo et incrémente count de 1 si la clé est à true
    }, 0); // on initialise count à 0
  });

  const fonctionTestEvent = () => {
    console.log('je suis la fonction test Event ')
  }

  const updateMenu = (item: keyof VisibleCompoType) => { // item doit être une clé de VisibleCompoType
    console.log('updateMenu', item)
    if (Object.keys(visibleCompo.value).includes(item as string)) { // si item est une clé de visibleCompo
      if ('home' === item) { // si l'item est l'accueil
        visibleCompo.value = { // on rend tous les composants invisibles et home à true 
          home: true,
          carte: false,
          graphe: false,
          sparnatural: false,
          filters: false,
          affichageResultats: false,
          infoRessource: false
        }
      }
      else { // si l'item cliqué n'est pas home
        visibleCompo.value.home = false; // on rend home invisible
        if (visibleCompo.value[item] === true) {  // si le composant cliqué est déjà affiché, on doit le fermer
            visibleCompo.value[item] = false; // on la rend invisible
            if (visibleCount.value === 0) { // si jamais ce composant est le dernier à true, il faut faire affiché home
              console.log('voici le visible count de update',visibleCount)
              visibleCompo.value.home = true; // on rend le menu visible 
            }
          }
        else { // si le composant cliqué n'est pas affiché, on doit l'ouvrir
          if (visibleCount.value === 4) { // si le nombre de composants à true (affichés) est égal à 4 (max autorisé)
            // alert('Vous ne pouvez pas afficher plus de 4 composants à la fois, merci de désélectionner au moins un composant'); // on alerte l'utilisateur
            showPopconfirm.value = true;
          }
          else {
            if ('filters' === item) { // si le composant a affiché est filters
              visibleCompo.value['affichageResultats'] = true; // on rend affichage des résultats viisible automatiquement
            }
            visibleCompo.value[item] = true; // sinon on rend le composant visible
          }
        }
      }
    }
    console.log ('voici visibleCompo', visibleCompo.value)
    console.log ('voici visibleCount', visibleCount.value) 
    console.log ('voici visiblecompoListe', visibleCompoListe.value) 
  }

  function handlePropertyChanged(filtersDisplayMap: Map<string, SelectOption[]>, type: string) {
      console.log(' handlePropertyChangedfiltersMap', filtersMap.value, 'type : ', type)
      filtersMap.value = filtersDisplayMap; 
      firstType.value = type;
  }

  function handleAffichage( label: string) {
    labelRecherche.value = label;
      console.log('handleAffichage', labelRecherche)
  }

  function handleMapClick(label : string) {
    firstType.value = "Site";
    labelRecherche.value = label;
  }

</script>

<template >
  <n-space vertical>
    <n-switch v-model:value="collapsed" :theme-overrides="switchStyle.themeOverrides"/>
    <n-layout has-sider >
      <n-layout-sider
        bordered
        collapse-mode="width"
        :collapsed-width="64"
        :width="240"
        :height="'100vh'"
        :collapsed="collapsed"
        show-trigger
        @collapse="collapsed = true"
        @expand="collapsed = false"
        style="background-color: seashell; border-right:2px solid #289373 ; "
      >
      <n-menu
        :value="'none'" 
        :collapsed="collapsed"
        :collapsed-width="64"
        :collapsed-icon-size="22"
        :options="menuOptions"
        @update:value="updateMenu"
      /> 
      <n-popconfirm :show="showPopconfirm" :negative-text="null" @positive-click="showPopconfirm = false">
        <template #trigger>
          <n-button size ='tiny' :bordered="false" ></n-button>
        </template>
        Vous ne pouvez pas afficher plus de 4 composants à la fois, merci de désélectionner au moins un composant
      </n-popconfirm>
      </n-layout-sider>
      <n-layout style="background-color: seashell; ">
        <component style="margin-left: 20px;" v-if="visibleCount===1" :is="visibleCompoListe[0].compo" v-bind="visibleCompoListe[0].props" v-on="visibleCompoListe[0].event"/> 
        <n-split  v-if= "visibleCount===2" direction="vertical" :theme-overrides="splitOptions.themeOverrides" style="height:100vh;">
          <template #1>
            <n-scrollbar style="height:100vh; width:100vw ">
              <n-scrollbar x-scrollable style="height:100vh; width:100vw">
                <component :is="visibleCompoListe[0].compo" v-bind="visibleCompoListe[0].props" v-on= "visibleCompoListe[0].event"/>
              </n-scrollbar>
            </n-scrollbar>
          </template>
          <template #2>
            <n-scrollbar >
              <n-scrollbar x-scrollable>
                <component :is="visibleCompoListe[1].compo" v-bind="visibleCompoListe[1].props" v-on= "visibleCompoListe[1].event"/>
              </n-scrollbar> 
            </n-scrollbar>
          </template>
        </n-split>  
        <n-split  v-if= "visibleCount===3" direction="vertical" :theme-overrides="splitOptions.themeOverrides" style="height:100vh;">
          <template #1>
            <n-split direction="horizontal" :theme-overrides="splitOptions.themeOverrides" style="height:100vh;">
              <template #1>
                <n-scrollbar >
                  <n-scrollbar x-scrollable >
                    <component :is="visibleCompoListe[0].compo" v-bind="visibleCompoListe[0].props" v-on= "visibleCompoListe[0].event"  style="margin-left: 20px;" />
                  </n-scrollbar>
                </n-scrollbar>
              </template>
              <template #2>
                <n-scrollbar >
                  <n-scrollbar x-scrollable >
                    <component :is="visibleCompoListe[1].compo" v-bind="visibleCompoListe[1].props" v-on= "visibleCompoListe[1].event"  style="margin-left: 20px;" />
                  </n-scrollbar>
                </n-scrollbar>
              </template>
            </n-split>
          </template>
          <template #2>
             <n-scrollbar>
              <n-scrollbar x-scrollable >
                <component :is="visibleCompoListe[2].compo" v-bind="visibleCompoListe[2].props" v-on= "visibleCompoListe[2].event"  style="margin-left: 20px;" />
              </n-scrollbar>
            </n-scrollbar>
          </template>
        </n-split>
        <n-split  v-if= "visibleCount===4" direction="vertical" :theme-overrides="splitOptions.themeOverrides" style="height:100vh;">
          <template #1>
            <n-split direction="horizontal" :theme-overrides="splitOptions.themeOverrides" style="height:100vh;">
              <template #1>
                <n-scrollbar>
                  <n-scrollbar x-scrollable>
                    <component :is="visibleCompoListe[0].compo" v-bind="visibleCompoListe[0].props" v-on= "visibleCompoListe[0].event" style="margin-left: 20px;" />
                  </n-scrollbar>
                </n-scrollbar>
              </template>
              <template #2>
                <n-scrollbar>
                  <n-scrollbar x-scrollable>
                    <component :is="visibleCompoListe[1].compo" v-bind="visibleCompoListe[1].props" v-on= "visibleCompoListe[1].event" style="margin-left: 20px;" />
                  </n-scrollbar>
                </n-scrollbar>
              </template>
            </n-split>
          </template>
          <template #2>
            <n-split direction="horizontal" :theme-overrides="splitOptions.themeOverrides" style="height:100vh;">
              <template #1>
                <n-scrollbar>
                  <n-scrollbar x-scrollable>
                    <component :is="visibleCompoListe[2].compo" v-bind="visibleCompoListe[2].props" v-on= "visibleCompoListe[2].event"  style="margin-left: 20px;" />
                  </n-scrollbar>
                </n-scrollbar>
              </template>
              <template #2>
                <n-scrollbar>
                  <n-scrollbar x-scrollable>
                    <component :is="visibleCompoListe[3].compo" v-bind="visibleCompoListe[3].props" v-on= "visibleCompoListe[3].event" style="margin-left: 20px;" />
                  </n-scrollbar>
                </n-scrollbar>
              </template>
            </n-split>
          </template>
        </n-split>
      </n-layout>
    </n-layout>
  </n-space>   
</template>

<style scoped>
  .n-layout-sider {
    height: 100vh;
  }
  .blue {
    color: #4a69d9;
  }
  .popup {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
  }
</style>
