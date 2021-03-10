<template>
  <header>
    <nav class="nav">
      <a href="/">@WebNotes</a>
    </nav>
    <div class="user-block">
      <template v-if="isAuth == true">
        <a @click="logout">Выйти</a>
      </template>
      <template v-else>
        <a href="/home/auth">Войти</a>
      </template>
    </div>
  </header>
</template>

<script>
export default {
  name: "Header",
  data() {
    return {
      isAuth: this.$store.getters.isAuthState,
    };
  },
  methods: {
    logout() {
      const token = this.$store.state.token;
      this.$store.dispatch("logout", { token });
      this.$router.push("/");
      window.location.reload();
    },
  },
};
</script>

<style lang="scss" scoped>
header {
  margin-top: 0.5em;
  width: 100%;
  background-color: #232330;
  border-radius: 5px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.nav {
  padding: 0.5em;
  display: flex;
  flex-direction: column;
  align-items: center;

  a {
    font-size: 2.2em;
  }
}

.user-block {
  padding: 0.5em;

  a {
    font-size: 1.5em;
  }

  a:hover {
    color: #dc9705 !important;
  }
}
</style>