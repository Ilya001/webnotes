<template>
  <div class="wrapper">
    <div class="note__label">
      <DxTextBox v-model:value="noteTitle" class="input label-input" />
      <div class="note__label__buttons">
        <DxButton class="button" text="Назад" @click="back" />
        <DxButton class="button" text="Удалить заметку" @click="deleteNote" />
      </div>
    </div>
    <div class="note__data">
      <DxHtmlEditor class="input" v-model:value="noteHtml" height="400px">
        <DxToolbar>
          <DxItem format-name="undo" />
          <DxItem format-name="redo" />
          <DxItem format-name="separator" />
          <DxItem :format-values="sizeValues" format-name="size" />
          <DxItem :format-values="fontValues" format-name="font" />
          <DxItem :format-values="headerValues" format-name="header" />
          <DxItem format-name="separator" />
          <DxItem format-name="bold" />
          <DxItem format-name="italic" />
          <DxItem format-name="strike" />
          <DxItem format-name="underline" />
          <DxItem format-name="separator" />
          <DxItem format-name="alignLeft" />
          <DxItem format-name="alignCenter" />
          <DxItem format-name="alignRight" />
          <DxItem format-name="alignJustify" />
          <DxItem format-name="separator" />
          <DxItem format-name="color" />
          <DxItem format-name="background" />
        </DxToolbar>
      </DxHtmlEditor>
    </div>
  </div>
</template>

<script>
import DxButton from "devextreme-vue/button";
import DxTextBox from "devextreme-vue/text-box";
import { DxHtmlEditor, DxToolbar, DxItem } from "devextreme-vue/html-editor";

export default {
  name: "Note",
  components: {
    DxHtmlEditor,
    DxToolbar,
    DxItem,
    DxButton,
    DxTextBox,
  },
  data() {
    return {
      sizeValues: ["8pt", "10pt", "12pt", "14pt", "18pt", "24pt", "36pt"],
      fontValues: [
        "Arial",
        "Courier New",
        "Georgia",
        "Impact",
        "Lucida Console",
        "Tahoma",
        "Times New Roman",
        "Verdana",
      ],
      headerValues: [false, 1, 2, 3, 4, 5],
      noteId: Number(this.$route.params.id),
      noteTitle: null,
      noteHtml: null,
    };
  },
  created: function () {
    let isAuth = this.$store.getters.isAuth;
    if (isAuth != null) {
      isAuth
        .then((status) => {
          if (status == true) {
            if (
              this.$store.state.token == null &&
              this.$store.state.ukey == null
            ) {
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
  mounted: function () {
    this.$fetch("http://localhost:8081/api/notes/get_notes/", {
      method: "POST",
      body: JSON.stringify({
        params: [this.$store.state.token, this.$store.state.ukey, this.noteId],
      }),
    })
      .then((response) => {
        if (!response.ok) throw Error(response.statusText);
        return response.json();
      })
      .then((data) => {
        if (data.result != null) {
          this.noteTitle = data.result[0].name;
          this.noteHtml = data.result[0].html;
        }
      });
  },
  watch: {
    noteTitle: function () {
      this.$fetch("http://localhost:8081/api/notes/update_note/", {
        method: "POST",
        body: JSON.stringify({
          params: [
            this.$store.state.token,
            this.$store.state.ukey,
            this.noteId,
            this.noteTitle,
            this.noteHtml,
          ],
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
    noteHtml: function () {
      this.$fetch("http://localhost:8081/api/notes/update_note/", {
        method: "POST",
        body: JSON.stringify({
          params: [
            this.$store.state.token,
            this.$store.state.ukey,
            this.noteId,
            this.noteTitle,
            this.noteHtml,
          ],
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
  },
  methods: {
    back() {
      this.$router.push("/home/");
    },
    deleteNote() {
      this.$fetch("http://localhost:8081/api/notes/delete_note/", {
        method: "POST",
        body: JSON.stringify({
          params: [
            this.$store.state.token,
            this.$store.state.ukey, 
            this.noteId
          ],
        }),
      })
        .then((response) => {
          if (!response.ok) throw Error(response.statusText);
          return response.json();
        })
        .then((data) => {
          if (data.result[0] == true) {
            this.$router.push("/home");
          } else {
            throw Error(data);
          }
        });
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

.note__label {
  display: flex;
  align-items: center;
  justify-content: space-around;
}

.label-input {
  font-size: 20px;
  width: 70%;
}

.note__label__buttons {
  display: flex;

  .button {
    margin: 0 1em;

    @media (max-width: 575.98px) {
      margin: 0.3em 1em;
    }
  }

  @media (max-width: 575.98px) {
    flex-direction: column;
  }
}

.note__data {
  margin-top: 2em;
}
</style>