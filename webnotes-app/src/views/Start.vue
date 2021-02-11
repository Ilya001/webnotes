<template>
  <div class="row">
    <p class="text">
      Добро пожаловать! В приложение новое приложение для созданяи заметок!<br />
      Нажмите на кнопку чтобы продолжить
    </p>
  </div>
  <div class="row">
    <DxButton text="Продолжить" @click="nextpage" />
  </div>
</template>

<script>
import DxButton from "devextreme-vue/button";

export default {
  name: "Start",
  components: {
    DxButton,
  },
  created: function () {
    let token = localStorage.getItem("token");
    if (token != null) {
      this.$fetch("/api/auth/check_session/", {
        method: "POST",
        body: JSON.stringify({
          params: [token],
        }),
      })
        .then((response) => {
          if (!response.ok) throw Error(response.statusText);
          return response.json();
        })
        .then((data) => {
          if (data.result[0] == true) {
            this.$router.push("/home");
          }
        });
    }
  },
  methods: {
    nextpage() {
      this.$router.push("/home");
    },
  },
};
</script>

<style scoped>
</style>
