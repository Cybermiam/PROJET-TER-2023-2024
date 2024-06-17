<script setup lang="ts">
    //imports
    import SideMenu from './SideMenu.vue'
    import type {Repository, Resource} from 'st-sparql-explorer'
    import SparqlJsQuery from './Model/sparqlJsQuery.js'
    import { unref } from 'vue'

    //props
    interface Properties {
        explorer: Repository
        types: ArrayLike<Resource>&Iterable<Resource>

    }

    //variables
    const query = new SparqlJsQuery('http://localhost:7200/repositories/newPatrimalp')
    const properties     = defineProps<Properties>()
    const explorer       = unref(properties.explorer)
    const types          = unref(properties.types)
</script>

<template>
    <n-loading-bar-provider>
        <n-message-provider>
            <n-notification-provider>
                <n-modal-provider>
                    <n-dialog-provider>
                        <side-menu :explorer="explorer" :query="query" :types="types" />
                    </n-dialog-provider>
                </n-modal-provider>
            </n-notification-provider>
        </n-message-provider>
    </n-loading-bar-provider>  
</template>
