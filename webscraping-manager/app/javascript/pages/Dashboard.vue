<template>
  <main style="padding:24px;">
    <h1>Dashboard</h1>
    <p>Logado como: <strong>{{ user?.email }}</strong></p>

    <form method="post" action="/logout" style="margin-top:16px;">
      <input type="hidden" name="_method" value="delete" />
      <button type="submit" style="padding:10px;">Sair</button>
    </form>
  </main>
</template>

<script setup>
defineProps({ user: Object })
</script>
