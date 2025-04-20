// Función para mostrar una página específica
function showPage(pageId) {
    // Ocultar todas las páginas
    const pages = document.querySelectorAll('.page');
    pages.forEach(page => {
      page.classList.remove('active');
    });
    
    // Mostrar la página seleccionada
    const selectedPage = document.getElementById(pageId);
    if (selectedPage) {
      selectedPage.classList.add('active');
    }
    
    // Actualizar el menú activo
    const navItems = document.querySelectorAll('.nav-item');
    navItems.forEach(item => {
      item.classList.remove('active');
      if (item.dataset.page === pageId) {
        item.classList.add('active');
      }
    });
  }
  
  // Función para abrir un modal
  function openModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
      modal.classList.add('active');
      document.body.style.overflow = 'hidden';
    }
  }
  
  // Función para cerrar un modal
  function closeModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
      modal.classList.remove('active');
      document.body.style.overflow = '';
    }
  }
  
  // Función para manejar el inicio de sesión
  function handleLogin(event) {
    event.preventDefault();
    
    // Obtener los valores del formulario
    const username = document.getElementById('username').value.trim();
    const password = document.getElementById('password').value.trim();
    
    // Validar campos
    let isValid = true;
    
    if (!username) {
      document.getElementById('username').classList.add('invalid');
      isValid = false;
    } else {
      document.getElementById('username').classList.remove('invalid');
    }
    
    if (!password) {
      document.getElementById('password').classList.add('invalid');
      isValid = false;
    } else {
      document.getElementById('password').classList.remove('invalid');
    }
    
    if (!isValid) {
      return;
    }
    
    // Mostrar estado de carga
    const loginButton = document.getElementById('login-button');
    loginButton.classList.add('loading');
    loginButton.disabled = true;
    
    // Enviar el formulario
    event.target.submit();
  }
  
  // Configurar eventos de clic para los elementos del menú
  document.addEventListener('DOMContentLoaded', function() {
    // Configurar menú móvil
    const mobileMenuButton = document.getElementById('mobile-menu-button');
    if (mobileMenuButton) {
      mobileMenuButton.addEventListener('click', function() {
        const sidebar = document.querySelector('.sidebar');
        if (sidebar.style.display === 'block') {
          sidebar.style.display = 'none';
        } else {
          sidebar.style.display = 'block';
        }
      });
    }
  
    // Configurar eventos de los modales
    document.querySelectorAll('.modal-close').forEach(button => {
      button.addEventListener('click', function() {
        const modal = this.closest('.modal-overlay');
        if (modal) {
          modal.classList.remove('active');
          document.body.style.overflow = '';
        }
      });
    });
  
    // Cerrar modal al hacer clic fuera del contenido
    document.querySelectorAll('.modal-overlay').forEach(modal => {
      modal.addEventListener('click', function(e) {
        if (e.target === this) {
          this.classList.remove('active');
          document.body.style.overflow = '';
        }
      });
    });
  
    // Validación de formularios
    document.querySelectorAll('form').forEach(form => {
      form.addEventListener('submit', function(e) {
        let isValid = true;
        const requiredFields = this.querySelectorAll('[required]');
        
        requiredFields.forEach(field => {
          if (!field.value.trim()) {
            field.classList.add('invalid');
            isValid = false;
          } else {
            field.classList.remove('invalid');
          }
        });
        
        if (!isValid) {
          e.preventDefault();
          alert('Por favor complete todos los campos obligatorios');
        }
      });
    });
  });
  
  // Función para mostrar el formulario de recuperación de contraseña
  function showForgotPassword(event) {
    event.preventDefault();
    alert('Funcionalidad de recuperación de contraseña no implementada en esta versión.');
  }