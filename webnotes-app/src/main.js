import 'devextreme/dist/css/dx.common.css';
import 'devextreme/dist/css/dx.light.css';
import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import { fetch } from 'whatwg-fetch'


const app = createApp(App)
app.use(router)
app.mount('#app')
app.config.globalProperties.$fetch = fetch;