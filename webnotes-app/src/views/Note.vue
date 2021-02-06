<template>
  <div class="row">
    <template v-if="isActive">
      <div class="buttons-div">
        <DxTextBox v-model:value="noteName" width="300px" @click="click" />
        <DxButton @click="back" text="Назад" />
        <DxButton @click="deleteNote" text="Удалить заметку" />
      </div>
      <DxHtmlEditor height="300px" v-model:value="noteHtml" @click="click">
        <DxMediaResizing :enabled="true" />
        <DxToolbar :multiline="isMultiline">
          <DxItem format-name="undo" />
          <DxItem format-name="redo" />
          <DxItem format-name="separator" />
          <DxItem :format-values="sizeValues" format-name="size" />
          <DxItem :format-values="fontValues" format-name="font" />
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
          <DxItem format-name="orderedList" />
          <DxItem format-name="bulletList" />
          <DxItem format-name="separator" />
          <DxItem :format-values="headerValues" format-name="header" />
          <DxItem format-name="separator" />
          <DxItem format-name="color" />
          <DxItem format-name="background" />
          <DxItem format-name="separator" />
          <DxItem format-name="link" />
          <DxItem format-name="image" />
          <DxItem format-name="separator" />
          <DxItem format-name="clear" />
          <DxItem format-name="codeBlock" />
          <DxItem format-name="blockquote" />
          <DxItem format-name="separator" />
          <DxItem format-name="insertTable" />
          <DxItem format-name="deleteTable" />
          <DxItem format-name="insertRowAbove" />
          <DxItem format-name="insertRowBelow" />
          <DxItem format-name="deleteRow" />
          <DxItem format-name="insertColumnLeft" />
          <DxItem format-name="insertColumnRight" />
          <DxItem format-name="deleteColumn" />
        </DxToolbar>
      </DxHtmlEditor>
      <div class="options">
        <div class="caption">Настройки</div>
        <div class="option">
          <DxCheckBox
            v-model:value="isMultiline"
            text="Многострочный toolbar"
          />
        </div>
      </div>
    </template>
    <template v-else>
      <div class="preloader"></div>
    </template>
  </div>
</template>

<script>
import {
  DxHtmlEditor,
  DxToolbar,
  DxMediaResizing,
  DxItem,
} from "devextreme-vue/html-editor";
import { DxCheckBox } from "devextreme-vue/check-box";
import DxButton from "devextreme-vue/button";
import DxTextBox from "devextreme-vue/text-box";

export default {
  name: "Note",
  components: {
    DxHtmlEditor,
    DxMediaResizing,
    DxToolbar,
    DxItem,
    DxCheckBox,
    DxButton,
    DxTextBox,
  },
  created: function () {
    let token = localStorage.getItem("token");
    if (token == null) {
      this.$router.push("/home/auth");
    } else {
      this.getNote();
    }
  },
  watch: {
    noteName: function () {
      if (this.onClick && this.noteName != this.noteNameCash) {
        this.getter = false;
        this.$fetch("http://localhost:8081/api/notes/update_note/", {
          method: "POST",
          body: JSON.stringify({
            params: [this.token, this.id, this.noteName, this.noteHtml],
          }),
        })
          .then((response) => {
            if (!response.ok) throw Error(response.statusText);
            return response.json();
          })
          .then((data) => {
            if (data.result[0] == true) {
              this.getter = true;
            }
          });
      }
    },
    noteHtml: function () {
      if (this.onClick && this.noteHtml != this.noteNameCash) {
        this.getter = false;
        this.$fetch("http://localhost:8081/api/notes/update_note/", {
          method: "POST",
          body: JSON.stringify({
            params: [this.token, this.id, this.noteName, this.noteHtml],
          }),
        })
          .then((response) => {
            if (!response.ok) throw Error(response.statusText);
            return response.json();
          })
          .then((data) => {
            if (data.result[0] == true) {
              this.getter = true;
            }
          });
      }
    },
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
      isMultiline: true,
      token: localStorage.getItem("token"),
      id: Number(this.$route.params.id),
      isActive: false,
      getter: true,
      onClick: false,
      noteName: null,
      noteNameCash: null,
      noteHtml: null,
      noteHmtlCash: null,
    };
  },
  methods: {
    click() {
      this.onClick = true;
      this.noteNameCash = this.noteName;
      this.noteHmtlCash = this.noteHtml;
    },
    back() {
      this.$router.push("/home");
    },
    getNote() {
      setInterval(() => {
        if (this.getter == true) {
          this.$fetch("http://localhost:8081/api/notes/get_notes/", {
            method: "POST",
            body: JSON.stringify({
              params: [this.token, this.id],
            }),
          })
            .then((response) => {
              if (!response.ok) throw Error(response.statusText);
              return response.json();
            })
            .then((data) => {
              if (this.noteName != null && this.noteHtml) {
                if (this.noteName != data.result[0].name) {
                  this.noteName = data.result[0].name;
                }
                if (this.noteHtml != data.result[0].text) {
                  this.noteHtml = data.result[0].text;
                }
              } else {
                this.noteName = data.result[0].name;
                this.noteHtml = data.result[0].text;
              }
            });
          if (this.noteName != null && this.noteHtml != null) {
            this.isActive = true;
          }
        }
      }, 500);
    },
    deleteNote() {
      this.getter = false;
      this.$fetch("http://localhost:8081/api/notes/delete_note/", {
        method: "POST",
        body: JSON.stringify({
          params: [this.token, this.id],
        }),
      })
        .then((response) => {
          if (!response.ok) throw Error(response.statusText);
          return response.json();
        })
        .then((data) => {
            if (data.result[0] == true){
                this.$router.push('/home')
            }
            else{
                throw Error(data);
            }
        });
    },
  },
};
</script>

<style scoped>
.dx-htmleditor-content img {
  vertical-align: middle;
  padding-right: 10px;
}

.dx-htmleditor-content table {
  width: 50%;
}

.options {
  padding: 20px;
  background-color: rgba(191, 191, 191, 0.15);
  margin-top: 20px;
}

.caption {
  font-size: 18px;
  font-weight: 500;
}

.option {
  margin-top: 10px;
}

.buttons-div {
  margin-bottom: 1.5em;
  display: flex;
  justify-content: center;
}
</style>