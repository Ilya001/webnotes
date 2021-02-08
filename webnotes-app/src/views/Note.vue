<template>
  <div class="row">
    <div class="buttons-div">
      <DxTextBox v-model:value="noteName" width="300px" />
      <DxButton @click="back" text="Назад" />
      <DxButton @click="deleteNote" text="Удалить заметку" />
    </div>
    <DxHtmlEditor v-model:value="noteHtml" :height="300">
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
</template>

<script>
import { DxHtmlEditor, DxToolbar, DxItem } from "devextreme-vue/html-editor";
import DxButton from "devextreme-vue/button";
import DxTextBox from "devextreme-vue/text-box";

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
      token: localStorage.getItem("token"),
      noteId: Number(this.$route.params.id),
      noteName: null,
      noteHtml: null,
    };
  },
  created() {
    let token = localStorage.getItem("token");
    if (token == null) {
      this.$router.push("/home/auth");
    }
  },
  mounted() {
    this.$fetch("http://localhost:8081/api/notes/get_notes/", {
      method: "POST",
      body: JSON.stringify({
        params: [this.token, this.noteId],
      }),
    })
      .then((response) => {
        if (!response.ok) throw Error(response.statusText);
        return response.json();
      })
      .then((data) => {
        if (data.result[0] != null) {
          this.noteName = data.result[0].name;
          this.noteHtml = data.result[0].text;
        }
      });
  },
  watch: {
    noteName() {
      this.$fetch("http://localhost:8081/api/notes/update_note/", {
          method: "POST",
          body: JSON.stringify({
            params: [this.token, this.noteId, this.noteName, this.noteHtml],
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
          })
    },
    noteHtml() {
      this.$fetch("http://localhost:8081/api/notes/update_note/", {
          method: "POST",
          body: JSON.stringify({
            params: [this.token, this.noteId, this.noteName, this.noteHtml],
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
          })
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
          params: [this.token, this.noteId],
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

<style scoped>
.buttons-div {
  margin-bottom: 1.5em;
  display: flex;
  justify-content: center;
}
</style>