<template>
  <div class="note">
    <div class="note__data_wrapper">
      <h3 class="note__title">{{ note.name }}</h3>
    </div>
    <div class="note__buttons__wrapper">
      <DxButton class="button note__button" text="Удалить"  @click="$emit('deleteNote', note.id)" />
      <DxButton class="button note__button" text="Открыть"  @click="$emit('openNote', note.id)" />
    </div>
  </div>
</template>

<script>
import DxButton from "devextreme-vue/button";

export default {
  name: "OneNote",
  props: ["note"],
  components: {
    DxButton,
  },
  methods: {}
};
</script>

<style lang="scss" scoped>
.note {
  background-color: #232330;
  margin-bottom: 2em;
  padding: 1em;
  border-radius: 5px;
  display: flex;
  justify-content: space-between;
  align-items: center;

  &:hover {
    background-color: #2c2c35;
    cursor: pointer;
  }

  @media (max-width: 575.98px) {
    flex-direction: column;
  }
}

.note__tags {
  padding-top: 0.3em;
  color: #3c5ab2;
  display: flex;
  flex-wrap: wrap;
}

.note__tag-item {
  margin-right: 1rem;
}

.note__buttons__wrapper {
  display: flex;
  flex-direction: column;
  justify-content: space-between;

  @media (max-width: 575.98px) {
    margin-top: 1em;
    flex-direction: initial;
    width: 100%;
  }

  @media (min-width: 1199.98px) {
    flex-direction: initial;
    align-items: center;
    width: 20%;
  }
}

.note__button {
  margin: 0.17em 0;
}
</style>