<template>
    <div class="row">
        <p class="text">
            Добро пожаловать! В приложение новое приложение для созданяи заметок!<br>
            Нажмите на кнопку чтобы продолжить
        </p>
    </div>
    <div class="row">
        <DxButton 
            text="Продолжить"
            @click="nextpage"
        />
    </div>
</template>

<script>
import DxButton from 'devextreme-vue/button';

export default {
    name: "Start",
    components: {
        DxButton
    },
    created: function() {
        let token = localStorage.getItem('token')
        if (token != null){
            this.$router.push('/home')
        }
    },
    methods: {
        nextpage(){
            this.$router.push('/home')
        }
    }
}
</script>

<style scoped>

</style>
