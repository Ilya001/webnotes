<template>
    <div class="row">
        <DxValidationGroup :width="500">
            <h3>Зарегистрироваться</h3>
            <DxTextBox v-model:value="login" placeholder="Логин">
                <DxValidator>
                    <DxRequiredRule message="Имя пользователя обязательно" />
                    <DxCustomRule 
                        message="Данное имя пользователя занято" 
                        :validation-callback="checkUsername"
                    />
                </DxValidator>
            </DxTextBox>
            <br>
            <DxTextBox v-model:value="password" mode="password" placeholder="Пароль">
                <DxValidator>
                    <DxRequiredRule message="Необходимо ввести пароль" />
                </DxValidator>
            </DxTextBox>
    
            <DxValidationSummary />
            <p>{{ registerMessage }}</p>
            <br>
            <DxButton @click="validate" text="Зарегистрироваться" />
        </DxValidationGroup>
    </div>
    <div class="row">

    </div>
    <div class="row">
        <DxValidationGroup :width="500">
            <h3>Войти</h3>
            <DxTextBox v-model:value="loginAuth" placeholder="Логин">
                <DxValidator>
                    <DxRequiredRule message="Имя пользователя обязательно" />
                </DxValidator>
            </DxTextBox>
            <br>
            <DxTextBox v-model:value="passwordAuth" mode="password" placeholder="Пароль">
                <DxValidator>
                    <DxRequiredRule message="Необходимо ввести пароль" />
                </DxValidator>
            </DxTextBox>
    
            <DxValidationSummary />
            <p>{{ loginMessage }}</p>
            <br>
            <DxButton @click="validateLogin" text="Войти" />
        </DxValidationGroup>
    </div>
</template>
 
<script>
import DxTextBox from 'devextreme-vue/text-box';
import DxValidator, {
    DxRequiredRule,
    DxCustomRule
} from 'devextreme-vue/validator';
import DxValidationGroup from 'devextreme-vue/validation-group';
import DxValidationSummary from 'devextreme-vue/validation-summary';
import DxButton from 'devextreme-vue/button';

 
export default {
    components: {
        DxTextBox,
        DxValidator,
        DxRequiredRule,
        DxCustomRule,
        DxValidationGroup,
        DxValidationSummary,
        DxButton
    },
    created: function() {
        let token = localStorage.getItem('token')
        if (token != null){
            this.$router.push('/home')
        }
    },
    data() {
        return {
            login: undefined,
            password: undefined,
            loginAuth: undefined,
            passwordAuth: undefined,
            registerMessage: "",
            loginMessage: ""
        }
    },
    methods: {
        validateLogin(params){
            let result = params.validationGroup.validate();
            if (result.isValid){
                const login = result.validators[0]._validationInfo.result.value
                const password = result.validators[1]._validationInfo.result.value
                this.$fetch('/api/auth/login/', {
                    method: 'POST',
                    body: JSON.stringify({
                        params: [login, password]
                    })
                })
                .then(response => {
                    if (!response.ok) throw Error(response.statusText);
                    return response.json();
                })
                .then(data => {
                    let token = data.result[0]
                    if (token != false){
                        localStorage.setItem('token', token)
                        this.$router.push('/home')
                    }
                    else{
                        this.loginMessage = "Неверный логин или пароль"
                    }
                })
            }
        },
        validate(params) {
            let result = params.validationGroup.validate();
            if (result.isValid) {
                const login = result.validators[0]._validationInfo.result.value
                const password = result.validators[1]._validationInfo.result.value
                this.$fetch('/api/auth/registration/', {
                    method: 'POST',
                    body: JSON.stringify({
                        params: [login, password]
                    })
                })
                .then(response => {
                    if (!response.ok) throw Error(response.statusText);
                    return response.json();
                })
                .then(data => {
                    if (data.result[0] == 200){
                        this.registerMessage = "Пользователь успешно зарегистрирован"
                    }
                    else{ 
                        this.registerMessage = "Такой пользователь уже существует"
                    }
                })
                params.validationGroup.reset()
            }
        },
        checkUsername(e){
            // Использую синхронные запросы!!!
            let xhr = new XMLHttpRequest()
            xhr.open('POST', '/api/auth/check_username/', false)
            xhr.send(JSON.stringify({params: [e.value]}))
            let response = JSON.parse(xhr.responseText)
            if (response.result[0] == true){
                return true
            }
            else{
                return false
            }
        }
    }
}
</script>

<style scoped>
    .row{
        display: flex;
        justify-content: center;
        margin: 2em;
    }
</style>