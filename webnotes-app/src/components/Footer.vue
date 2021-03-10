<template>
  <footer>
    <div class="logo">
      <a>@webnotes</a>
    </div>
    <nav class="navbar">
      <ul class="navbar__menu">
        <li class="navbar__item">
          <a href="/">Home</a>
        </li>
        <li class="navbar__item">
          <a href="/about">About</a>
        </li>
        <li class="navbar__item">
          <a href="/reviews">Reviews</a>
        </li>
      </ul>
    </nav>
  </footer>
</template>

<style lang="scss" scoped>
footer {
  margin-bottom: 0.5em;
  width: 100%;
  background-color: #232330;
  border-radius: 5px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-shrink: 0;
}

.logo {
  padding: 0.5em;

  a {
    font-size: 1.5em;
  }
}

.navbar {
  padding: 0.5em;
}

.navbar__menu {
  list-style: none;
  display: flex;
}

.navbar__item {
  margin: 0 0.2em;

  a:hover {
    color: #dc9705 !important;
  }
}
</style>