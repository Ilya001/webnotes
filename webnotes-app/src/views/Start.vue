<template>
  <div class="wrapper">
    <h3 class="wrapper__title"></h3>
    <div class="button-wrapper">
      <DxButton class="button" text="Продолжить" @click="redirect" />
    </div>
  </div>
</template>

<script>
import DxButton from "devextreme-vue/button";
import Typed from "typed.js";

export default {
  name: "Start",
  components: {
    DxButton,
  },
  created: function () {
    let isAuth = this.$store.getters.isAuth;
    if (isAuth != null) {
      isAuth
        .then((status) => {
          if (status == true) {
            this.$router.push("/home");
          }
        })
        .catch((error) => {
          if (error == false) {
            this.$store.dispatch("delete_bad_auth_data");
            throw Error("Your auth token is not valid!");
          }
        });
    }
  },
  mounted: function () {
    new Typed(".wrapper__title", {
      strings: [
        "Самое лучшее приложение для создания заметок",
        "Чтобы начать нажми кнопку продолжить",
      ],
      typeSpeed: 150,
    });
  },
  methods: {
    redirect() {
      this.$router.push("/home");
    },
  },
};
</script>

<style lang="scss" scoped>
.wrapper {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  border-radius: 5px;
  height: 100%;

  h3 {
    font-size: 40px;
  }
}

.button-wrapper {
  margin-top: 2em;
}
</style>