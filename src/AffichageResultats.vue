<script setup lang="ts">
    //imports
    import type { ListProps, SelectOption } from 'naive-ui';
    import type SparqlJsQuery from './Model/sparqlJsQuery.js';
    import { defineEmits } from 'vue'
    import {unref , nextTick, ref, watchEffect} from 'vue'

    //props
    interface Properties {
        query: SparqlJsQuery;
        filtersMap: Map<string, SelectOption[]>;
        firstType: string;
    }

    //variables
    const properties = defineProps<Properties>();
    const query = unref(properties.query);
    const emit = defineEmits(['propertyChanged']);
    const result = ref<{label: string, value:string}[]>([]);
    const listOptions : ListProps = {
        themeOverrides : {
            colorHover: "rgba(10,200,90,0.2)",
        }
    }

    //functions

    //watcher pour mettre a jour les resultats
    watchEffect(update);
    async function update() {
        var laQuery= query. queryContrsuctResultat(properties.firstType, properties.filtersMap)
        result.value=(await properties.query.query(laQuery)).results.bindings
    }

    //fonction pour envoyer l'element selectionné
    function envoieAffichage(element:string){
	    emit('propertyChanged' ,element );
    }
</script>

<template>
    <div class="container is-centered">
        <h1> Résultats pour les {{firstType + "s"}} </h1>
        <n-list hoverable clickable show-divider  :theme-overrides="listOptions.themeOverrides"  style="background-color: seashell;">
            <div v-for="line in result" style="max-width: fit-content;">
                <div v-for="element in line">
                    <n-list-item>
                        <n-thing class="cell" id="thing" @click="envoieAffichage(element.value)">{{element.value}}
                            <n-space size="small" style ="margin-top : 4px">
                                <n-tag :bordered="false" size="small" type="info">{{firstType}}</n-tag>
                            </n-space>
                        </n-thing>  
                    </n-list-item> 
                </div>
            </div>                  
        </n-list>   
    </div>
</template>