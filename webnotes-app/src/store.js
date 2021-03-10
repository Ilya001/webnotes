import {
    createStore
} from 'vuex'
import {
    fetch
} from 'whatwg-fetch';

const store = createStore({
    state() {
        return {
            token: localStorage.getItem("token") || null,
            ukey: localStorage.getItem("ukey") || null,
        }
    },
    mutations: {
        delete_data(state) {
            state.token = null;
            state.ukey = null;

            delete localStorage.token;
            delete localStorage.ukey;
        },
        update_data(state) {
            state.token = localStorage.getItem("token");
            state.ukey = localStorage.getItem("ukey");
        },
    },
    actions: {
        register(_, data) {
            return new Promise((resolve, reject) => {
                fetch("http://localhost:8081/api/auth/registration/", {
                        method: "POST",
                        body: JSON.stringify({
                            params: [data["login"], data["password"]],
                        }),
                    })
                    .then((response) => {
                        if (!response.ok) throw Error(response.statusText);
                        return response.json();
                    })
                    .then((response_data) => {
                        if (response_data.result[0] == true) {
                            resolve(true)
                        } else {
                            reject(false)
                        }
                    });
            });
        },
        login({
            commit
        }, data) {
            return new Promise((resolve, reject) => {
                fetch("http://localhost:8081/api/auth/login/", {
                        method: "POST",
                        body: JSON.stringify({
                            params: [data["login"], data["password"]],
                        }),
                    })
                    .then((response) => {
                        if (!response.ok) throw Error(response.statusText);
                        return response.json();
                    })
                    .then((data) => {
                        if (data.result[0] != false) {
                            localStorage.setItem("token", data.result[0]);
                            localStorage.setItem("ukey", data.result[1]);
                            commit("update_data")
                            resolve(true)
                        } else {
                            reject(false)
                        }
                    });
            });
        },
        logout({
            commit
        }, data) {
            fetch("/api/auth/logout/", {
                    method: "POST",
                    body: JSON.stringify({
                        params: [data["token"]],
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
            commit("delete_data")
        },
        delete_bad_auth_data({
            commit
        }) {
            commit("delete_data")
        }
    },
    getters: {
        isAuth: state => {
            if (state.token != null && state.ukey != null) {
                return new Promise((resolve, reject) => {
                    fetch("http://localhost:8081/api/auth/check_session/", {
                            method: "POST",
                            body: JSON.stringify({
                                params: [state.token]
                            })
                        })
                        .then((response) => {
                            if (!response.ok) throw Error(response.statusText);
                            return response.json();
                        })
                        .then((data) => {
                            if (data.result[0] == true) {
                                resolve(true)
                            } else {
                                reject(false)
                            }
                        })
                })
            } else {
                return null
            }
        },
        isAuthState: state => {
            if (state.token != null && state.ukey != null) {
                return true
            } else {
                return false
            }
        }
    }
});

export default store