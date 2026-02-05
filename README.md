## Lucas Araujo Ramos - Test CI 2.0##
## Test validaçao CI matrix

# 🚀 Portfólio Profissional - Landing Page + Pipeline CI/CD

Uma landing page moderna, responsiva e automatizada com pipeline CI/CD para apresentar suas habilidades técnicas, projetos e redes sociais.

## 📋 Requisitos Atendidos

- ✅ Arquivo `index.html` na raiz do projeto
- ✅ Folha de estilos `style.css`
- ✅ Pasta `/images` dedicada para armazenar imagens
- ✅ Listagem de habilidades técnicas (DevOps, Desenvolvimento, Infraestrutura, Ferramentas)
- ✅ Links para redes sociais (GitHub, LinkedIn, Twitter, Email)
- ✅ Descrições de projetos em destaque
- ✅ Código limpo sem comentários desnecessários
- ✅ Design responsivo (mobile, tablet, desktop)
- ✅ Otimizado para produção

## Instruções para Imagens

As imagens devem ser otimizadas para web. Recomendações:

### Foto de Perfil (profile.jpg)
- Dimensões: 150x150 pixels
- Formato: JPG ou PNG
- Tamanho máximo: 50KB
- Proporção: Quadrada

### Imagens de Projetos (project1.jpg, project2.jpg, project3.jpg, project4.jpg)
- Dimensões: 800x600 pixels (proporção 4:3)
- Formato: JPG otimizado
- Tamanho máximo: 100KB cada
- Deve representar o projeto ou ser um screenshot

## Boas Práticas Implementadas

1. **HTML Semântico**: Uso de tags semânticas (header, nav, section, footer)
2. **Meta Tags**: Charset UTF-8, viewport responsivo, descrição
3. **CSS Modular**: Variáveis CSS, estrutura clara e reutilizável
4. **Responsividade**: Breakpoints para mobile (480px), tablet (768px) e desktop
5. **Acessibilidade**: Atributos alt em imagens, contraste adequado
6. **Performance**: Código minificado, sem dependências externas
7. **Links Externos**: Atributos target="_blank" e rel="noopener noreferrer"
8. **SEO Básico**: Meta description, estrutura heading correta


## 🔐 Pipeline CI/CD

Este projeto inclui uma pipeline de **Integração Contínua (CI)** que valida automaticamente cada Pull Request.

### ✅ Validações Implementadas

- [x] Verificação de `index.html` na raiz
- [x] Bloqueio de arquivos maiores que 500KB
- [x] Varredura de TODO, FIXME e termos sensíveis
- [x] Validação HTML com W3C standards
- [x] Verificação de URLs e caminhos de imagens

### 🚀 Como Usar

#### **Validação Local (Antes de fazer Push)**

Windows:
```powershell
.\validate.ps1
```

Linux/Mac:
```bash
chmod +x validate.sh
./validate.sh
```

#### **Fluxo de Desenvolvimento**

```bash
# 1. Crie uma branch
git checkout -b feature/sua-funcionalidade

# 2. Faça suas mudanças
# ... edite arquivos ...

# 3. Valide localmente
.\validate.ps1  # ou ./validate.sh

# 4. Commit e Push
git add .
git commit -m "Descrição da mudança"
git push origin feature/sua-funcionalidade

# 5. Abra um Pull Request no GitHub
# A pipeline será executada automaticamente
```

### 📊 Configurando Proteção de Branch

Para bloquear merge quando testes falham:

1. Vá para **Settings** > **Branches**
2. Clique em **Add rule**
3. Digite: `main`
4. Ative:
   - [x] Require a pull request before merging
   - [x] Require status checks to pass before merging
   - [x] Require branches to be up to date

**Leia**: [BRANCH_PROTECTION.md](BRANCH_PROTECTION.md)

---

## Validação de Liga para Produção

Antes de fazer o deploy:

- [ ] Todas as imagens estão otimizadas (< 100KB)
- [ ] Todos os links externos funcionam corretamente
- [ ] Verificar com F12 que não há erros no console
- [ ] Testar responsividade em diferentes telas
- [ ] Remover qualquer comentário de desenvolvimento
- [ ] Validar HTML com W3C Validator
- [ ] Testar velocidade com PageSpeed Insights

## Tecnologias Utilizadas

- HTML5
- CSS3 (Flexbox, Grid, Media Queries)
- Sem dependências externas
- Cross-browser compatible
