<template>
  <div class="wrapper">
    <div class="wrapper__form">
      <DxValidationGroup class="form">
        <div class="form__section center__section">
          <h3>Регистрация</h3>
        </div>
        <div class="form__section">
          <DxTextBox
            class="input"
            v-model:value="loginInputRegister"
            placeholder="Логин"
          >
            <DxValidator>
              <DxRequiredRule message="Имя пользователя обязательно" />
              <DxCustomRule
                message="Данное имя пользователя занято"
                :validation-callback="checkUsername"
              />
            </DxValidator>
          </DxTextBox>
        </div>
        <div class="form__section">
          <DxTextBox
            class="input"
            v-model:value="passwordInputRegister"
            mode="password"
            placeholder="Пароль"
          >
            <DxValidator>
              <DxRequiredRule message="Необходимо ввести пароль" />
            </DxValidator>
          </DxTextBox>
        </div>
        <div class="form__section center__section">
          <DxValidationSummary />
          <!-- TODO Сделать стили для текста об успешной регистрации -->
          <span class="errorText">{{ registerMessage }}</span>
        </div>
        <div class="form__section center__section">
          <DxButton
            @click="validateRegister"
            class="button"
            text="Зарегистрироваться"
          />
        </div>
      </DxValidationGroup>
      <DxValidationGroup class="form">
        <div class="form__section center__section">
          <h3>Войти</h3>
        </div>
        <div class="form__section">
          <DxTextBox
            class="input"
            v-model:value="loginInputLogin"
            placeholder="Логин"
          >
            <DxValidator>
              <DxRequiredRule message="Имя пользователя обязательно" />
            </DxValidator>
          </DxTextBox>
        </div>
        <div class="form__section">
          <DxTextBox
            class="input"
            v-model:value="passwordInputLogin"
            mode="password"
            placeholder="Пароль"
          >
            <DxValidator>
              <DxRequiredRule message="Необходимо ввести пароль" />
            </DxValidator>
          </DxTextBox>
        </div>
        <div class="form__section center__section">
          <DxValidationSummary />
          <span class="errorText">{{ loginMessage }}</span>
        </div>
        <div class="form__section center__section">
          <DxButton @click="validateLogin" class="button" text="Войти" />
        </div>
      </DxValidationGroup>
    </div>
  </div>
</template>

<script>
import DxTextBox from "devextreme-vue/text-box";
import DxValidator, {
  DxRequiredRule,
  DxCustomRule,
} from "devextreme-vue/validator";
import DxValidationGroup from "devextreme-vue/validation-group";
import DxValidationSummary from "devextreme-vue/validation-summary";
import DxButton from "devextreme-vue/button";

export default {
  name: "Auth",
  components: {
    DxTextBox,
    DxValidator,
    DxRequiredRule,
    DxValidationGroup,
    DxValidationSummary,
    DxButton,
    DxCustomRule,
  },
  created: function () {
    let isAuth = this.$store.getters.isAuth;
    if (isAuth != null) {
      isAuth
        .then((status) => {
          if (status == true) {
            this.$router.push("/home");
          }
        })
        .catch((error) => {
          if (error == false) {
            this.$store.dispatch("delete_bad_auth_data");
            throw Error("Your token is not valid!");
          }
        });
    }
  },
  data() {
    return {
      loginInputRegister: undefined,
      passwordInputRegister: undefined,
      loginInputLogin: undefined,
      passwordInputLogin: undefined,
      registerMessage: "",
      loginMessage: "",
    };
  },
  methods: {
    validateRegister(params) {
      let result = params.validationGroup.validate();
      if (result.isValid) {
        const login = result.validators[0]._validationInfo.result.value;
        const password = result.validators[1]._validationInfo.result.value;
        this.$store
          .dispatch("register", { login, password })
          .then(() => {
            this.registerMessage = "Пользователь успешно зарегистрирован";
          })
          .catch(() => {
            this.registerMessage = "Такой пользователь уже существует";
          });
        params.validationGroup.reset();
      }
    },
    validateLogin(params) {
      let result = params.validationGroup.validate();
      if (result.isValid) {
        const login = result.validators[0]._validationInfo.result.value;
        const password = result.validators[1]._validationInfo.result.value;
        this.$store
          .dispatch("login", { login, password })
          .then((status) => {
            if (status == true) {
              this.$router.push("/home");
              window.location.reload();
            }
          })
          .catch((error_status) => {
            if (error_status == false) {
              this.loginMessage = "Не верно введен логин или пароль!";
            }
          });
      }
    },
    checkUsername(e) {
      // TODO Найти способ пофиксить это
      let xhr = new XMLHttpRequest();
      xhr.open("POST", "http://localhost:8081/api/auth/check_username/", false);
      xhr.send(JSON.stringify({ params: [e.value] }));
      let response = JSON.parse(xhr.responseText);
      if (response.result[0] == true) {
        return true;
      } else {
        return false;
      }
    },
  },
};
</script>

<style lang="scss" scoped>
.wrapper {
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.wrapper__form {
  display: flex;
  width: 100%;
  justify-content: space-around;

  @media (max-width: 575.98px) {
    flex-direction: column;
    justify-content: center;
    align-items: center;
  }
}

.form {
  margin: 0 1em;
  padding: 1em;
  background-color: #232330;
  border-radius: 5px;
  width: 60vh;

  @media (max-width: 575.98px) {
    margin: 2em 0;
    width: 60%;
  }
}

.form__section {
  margin: 1em 0;
}

.center__section {
  display: flex;
  justify-content: center;
}

.errorText {
  color: #a50e39;
}
</style>