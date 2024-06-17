<template>
  <n-carousel  class="carousel">
    <img
      class="carousel-img"
      src="https://patrimalp.univ-grenoble-alpes.fr/sites/default/files/2023-09/test-carrousel3.jpg"
    >
    <img
      class="carousel-img"
      src="https://naive-ui.oss-cn-beijing.aliyuncs.com/carousel-img/carousel2.jpeg"
    >
  </n-carousel>
  <br/><br/><h1 class= "titre">Bienvenue sur Patrimalp Explorer ! </h1> 
</template>

<style scoped>
  .carousel {
    height: 315px; /* adjust this value as needed */
  }
  .carousel-img {
    width: 100%;
    height: 315px;
    object-fit: cover;
  }
  .titre{
  color: #289373;
  text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.1); 
  font-size: 2.5em; 
  font-family: 'Arial Rounded MT', sans-serif; 
  margin-left: 20px;
  }
</style>