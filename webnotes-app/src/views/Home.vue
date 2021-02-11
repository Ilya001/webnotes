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
    let ukey = localStorage.getItem("ukey");
    if (token != null && ukey != null) {
      this.$fetch("http://localhost:8081/api/auth/check_session/", {
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
          if (data.result[0] != true) {
            this.$router.push("/home/auth");
          } else {
            this.getNotes();
          }
        });
    } else {
      this.$router.push("/home/auth");
    }
  },
  data() {
    return {
      notesList: null,
      token: localStorage.getItem("token"),
      ukey: localStorage.getItem("ukey"),
      isActive: false,
    };
  },
  methods: {
    open(id) {
      this.$router.push(`/home/note/${id}`);
    },
    getNotes() {
      setInterval(() => {
        this.$fetch("http://localhost:8081/api/notes/get_notes/", {
          method: "POST",
          body: JSON.stringify({
            params: [this.token, this.ukey],
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
      }, 500);
    },
    createNote() {
      this.$fetch("http://localhost:8081/api/notes/create_note/", {
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
      this.$fetch("http://localhost:8081/api/auth/logout/", {
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
          this.isActive = false;
          if (data.result[0] != true) {
            throw Error(data);
          }
          this.$router.push("/home/auth");
        });
      delete localStorage.token;
      delete localStorage.ukey;
    },
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