<template>
  <div id="app">
    <div class="container">
      <Header></Header>
      <main>
        <router-view />
      </main>
      <Footer></Footer>
    </div>
  </div>
</template>

<script>
import Header from "@/components/Header.vue";
import Footer from "@/components/Footer.vue";

export default {
  name: "App",
  components: {
    Header,
    Footer,
  },
};
</script>

<style lang="scss">
@import url("https://fonts.googleapis.com/css2?family=Source+Code+Pro:wght@500;700&display=swap");

* {
  margin: 0;
  padding: 0;
}

body {
  color: white;
  font-size: 15px;
  display: flex;
  flex-direction: column;
  font-family: "Source Code Pro", monospace !important;
}

#app {
  height: 100vh;
}

a {
  text-decoration: none;
  color: white !important;
}

.container {
  padding: 0 15px;
  display: flex;
  flex-direction: column;
  height: 100%;

  @media (min-width: 575.98px) {
    max-width: 540px;
    margin: auto;
    padding: 0;
  }

  @media (min-width: 767.98px) {
    max-width: 720px;
  }

  @media (min-width: 991.98px) {
    max-width: 960px;
  }

  @media (min-width: 1199.98px) {
    max-width: 1140px;
  }
}

main {
  flex: 1 0 auto;
  margin: 1em 0;
}

.button {
  border-radius: 5px;
  font-family: "Source Code Pro", monospace !important;

  &:hover {
    color: #dc9705 !important;
  }
}

.input {
  border-radius: 5px !important;
  font-family: "Source Code Pro", monospace !important;
}

.preloader {
  position: relative;
  min-height: 60px;
}
.preloader:before {
  content: "";
  position: absolute;
  z-index: 1;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  height: 100%;
  width: 100%;
  display: block !important;
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  user-select: none;
}
.preloader:after {
  content: "";
  position: absolute;
  z-index: 2;
  top: 50%;
  left: 50%;
  margin-left: -15px;
  margin-top: -15px;
  width: 30px;
  height: 30px;
  border: 4px rgba(0, 0, 0, 0.25) solid;
  border-top: 4px #1071b6 solid;
  border-radius: 50%;
  -webkit-animation: preloader 0.6s infinite linear;
  animation: preloader 0.6s infinite linear;
}
@-webkit-keyframes preloader {
  0% {
    -webkit-transform: rotate(0deg);
    transform: rotate(0deg);
  }
  to {
    -webkit-transform: rotate(359deg);
    transform: rotate(359deg);
  }
}
@keyframes preloader {
  0% {
    -webkit-transform: rotate(0deg);
    transform: rotate(0deg);
  }
  to {
    -webkit-transform: rotate(359deg);
    transform: rotate(359deg);
  }
}
</style>
