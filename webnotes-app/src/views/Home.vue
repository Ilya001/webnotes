<template>
  <div class="wrapper">
    <div class="buttons-wrapper">
      <DxButton
        class="button"
        text="Создать новую заметку"
        @click="createNote"
      />
    </div>
    <template v-if="isActive == true">
      <OneNote
        v-for="note in notesList"
        :note="note"
        :key="note.id"
        v-on:deleteNote="deleteNote"
        v-on:openNote="openNote"
        @click="openNote(note.id)"
      ></OneNote>
    </template>
    <template v-else>
      <div class="preloader"></div>
    </template>
  </div>
</template>

<script>
import OneNote from "@/components/OneNote";
import DxButton from "devextreme-vue/button";

export default {
  name: "Home",
  components: {
    DxButton,
    OneNote,
  },
  data() {
    return {
      notesList: null,
      isActive: false,
    };
  },
  created: function () {
    let isAuth = this.$store.getters.isAuth;
    if (isAuth != null) {
      isAuth
        .then((status) => {
          if (status == true) {
            if (
              this.$store.state.token != null &&
              this.$store.state.ukey != null
            ) {
              this.getNotes();
            } else {
              this.$router.push("/home/auth");
            }
          }
        })
        .catch((error) => {
          if (error == false) {
            this.$router.push("/home/auth");
          }
        });
    } else {
      this.$router.push("/home/auth");
    }
  },
  methods: {
    openNote(id) {
      this.$router.push(`/home/note/${id}`);
    },
    deleteNote(id) {
      this.$fetch("http://localhost:8081/api/notes/delete_note/", {
        method: "POST",
        body: JSON.stringify({
          params: [this.$store.state.token, this.$store.state.ukey, id],
        }),
      })
        .then((response) => {
          if (!response.ok) throw Error(response.statusText);
          return response.json();
        })
        .then((data) => {
          if (data.result[0] != true) {
            throw Error(data);
          }
        });
    },
    createNote() {
      this.$fetch("http://localhost:8081/api/notes/create_note/", {
        method: "POST",
        body: JSON.stringify({
          params: [this.$store.state.token, this.$store.state.ukey],
        }),
      })
        .then((response) => {
          if (!response.ok) throw Error(response.statusText);
          return response.json();
        })
        .then((data) => {
          if (data.result[0] == "Bad data") {
            throw Error(data);
          }
        });
    },
    getNotes() {
      setInterval(() => {
        this.$fetch("http://localhost:8081/api/notes/get_notes/", {
          method: "POST",
          body: JSON.stringify({
            params: [this.$store.state.token, this.$store.state.ukey],
          }),
        })
          .then((response) => {
            if (!response.ok) throw Error(response.statusText);
            return response.json();
          })
          .then((data) => {
            if (this.notesList != null) {
              if (data.result != null) {
                let last_data_count = this.notesList.length;
                if (last_data_count != data.result[0][0][1].length) {
                  this.isActive = false;
                  this.notesList = data.result[0][0][1];
                }
              }
            } else {
              this.notesList = data.result[0][0][1];
            }
          });
        if (this.notesList != null) {
          this.isActive = true;
        }
      }, 1000);
    },
  },
};
</script>

<style lang="scss" scoped>
.wrapper {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.buttons-wrapper {
  margin-bottom: 2em;
  display: flex;
  align-content: center;
  justify-content: center;
}
</style>