<script setup lang="ts">
    //imports
    import type SparqlJsQuery from './Model/sparqlJsQuery.js';
    import {unref , watchEffect, ref} from 'vue'
    
    //props
    interface Properties {
        query: SparqlJsQuery;
        labelRecherche: string ;
        firstType: string;
    }

    //variables
    const properties = defineProps<Properties>();
    const query = unref(properties.query);
    const result = ref< {}[]>([]);
    const uri=ref<string>("");
    const mapToDisplay=ref<Map<string, string[]>>(new Map());

    //watcher pour recuperer les ressources
    watchEffect(ressourceRequest);
    async function ressourceRequest() {
        mapToDisplay.value.clear();
        var query= properties.query.getInfosOeuvre(properties.labelRecherche, properties.firstType)
        result.value=(await properties.query.query(query)).results.bindings
        result.value.forEach(line => {
            Object.keys(line).forEach(key => {
            let value = line[key];
            if (mapToDisplay.value.get(key)){
                if (!mapToDisplay.value.get(key).includes(value.value)){
                    mapToDisplay.value.get(key).push(value.value);
                }
            } else {
                mapToDisplay.value.set(key, [value.value]);
            }});
        });
    }
</script>

<template>
    <div class="container-is-centered">
        <div v-for="[key, value] in mapToDisplay">
            <div v-if=" key == 'label' ">
                <p style="font-size: xx-large">{{ value[0] }}</p>
            </div>
            <div v-else class="">{{key}} : 
                <p v-for="v in value"> 
                    <n-tag :bordered="true" size="large" type="default">{{ v }}</n-tag>
                </p>
            </div>
        </div>
    </div>
</template>