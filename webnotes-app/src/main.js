import "devextreme/dist/css/dx.common.css";
import "devextreme/dist/css/dx.darkviolet.css";
import {
    createApp
} from 'vue'
import App from './App.vue'
import router from './router'
import {
    fetch
} from 'whatwg-fetch'
import store from "./store";

const app = createApp(App)
app.use(router)
app.use(store)
app.mount('#app')
app.config.globalProperties.$fetch = fetch;