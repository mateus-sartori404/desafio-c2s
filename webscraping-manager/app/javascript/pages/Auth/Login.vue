<template>
  <main style="padding:24px; max-width:420px;">
    <h1>Login</h1>

    <form @submit.prevent="submit" style="display:grid; gap:12px; margin-top:16px;">
      <label>
        <div>E-mail</div>
        <input v-model="form.email" type="email" required style="width:100%; padding:8px;" />
      </label>

      <label>
        <div>Senha</div>
        <input v-model="form.password" type="password" required style="width:100%; padding:8px;" />
      </label>

      <button :disabled="form.processing" type="submit" style="padding:10px;">
        {{ form.processing ? "Entrando..." : "Entrar" }}
      </button>

      <a href="/register">Criar conta</a>
    </form>
  </main>
</template>

<script setup>
import { useForm } from "@inertiajs/vue3"

const form = useForm({
  email: "",
  password: "",
})

function submit() {
  form.post("/login")
}
</script>
