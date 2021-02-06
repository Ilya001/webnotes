<template>
  <div class="row">
    <DxButton text="Выйти" @click="logout" />
  </div>
  <div class="row">
    <template v-if="isActive">
      <DxList>
        <DxItem v-for="note in notesList" :key="note.id" @click="open(note.id)">
          <template #default>
            {{ note.name }}
          </template>
        </DxItem>
      </DxList>
    </template>
    <template v-else>
      <div class="preloader"></div>
    </template>
  </div>
  <div class="row">
    <DxButton text="Создать новую заметку" @click="createNote" />
  </div>
</template>
 
<script>
import DxList, { DxItem } from "devextreme-vue/list";
import DxButton from "devextreme-vue/button";

export default {
  components: {
    DxList,
    DxItem,
    DxButton,
  },
  created: function () {
    let token = localStorage.getItem("token");
    if (token == null) {
      this.$router.push("/home/auth");
    } else {
      this.getNotes();
    }
  },
  data() {
    return {
      notesList: null,
      token: localStorage.getItem("token"),
      isActive: false,
    };
  },
  methods: {
    open(id) {
      this.$router.push(`/home/note/${id}`);
    },
    getNotes() {
      setInterval(() => {
        this.$fetch("/api/notes/get_notes/", {
          method: "POST",
          body: JSON.stringify({
            params: [this.token],
          }),
        })
          .then((response) => {
            if (!response.ok) throw Error(response.statusText);
            return response.json();
          })
          .then((data) => {
            if (this.notesList != null) {
              let last_data_count = this.notesList.length;
              if (last_data_count != data.result[0].length) {
                this.isActive = false;
                this.notesList = data.result[0];
              }
            } else {
              this.notesList = data.result[0];
            }
          });
        if (this.notesList != null) {
          this.isActive = true;
        }
      }, 500);
    },
    createNote() {
      this.$fetch("/api/notes/create_note/", {
        method: "POST",
        body: JSON.stringify({
          params: [this.token],
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
    logout() {
      this.$fetch("/api/auth/logout/", {
        method: "POST",
        body: JSON.stringify({
          params: [this.token],
        }),
      })
        .then((response) => {
          if (!response.ok) throw Error(response.statusText);
          return response.json();
        })
        .then((data) => {
          if (data.result[0] != true){
            throw Error(data)
          }
          this.$router.push('/home/auth')
        });
      delete localStorage.token
    }
  },
};
</script>

<style scoped>
.isActiveFalse {
  display: none;
}
.row {
  margin: 2em;
}
</style>