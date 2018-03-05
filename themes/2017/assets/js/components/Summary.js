class Summary {
    /**
     * @param {Element} article
     * @param {Element} element
     * @param {Element[]} titles
     */
    constructor(article, element, titles) {
        this.article = article;
        this.element = element;
        this.titles = titles;
        this.limit = this.article.offsetTop;
        this.position = document.documentElement.scrollTop;
        this.fixed = null;

        this.titles.forEach(title => this.element.appendChild(this.createLink(title)));

        this.onScroll = this.onScroll.bind(this);
        this.onResize = this.onResize.bind(this);

        addEventListener('resize', this.onResize);
        addEventListener('scroll', this.onScroll);

        this.update();
    }

    createLink(title) {
        const { id, innerText, tagName } = title;
        const link = document.createElement('a');

        link.href = `#${id}`;
        link.innerText = innerText;
        link.className = tagName.toLowerCase();

        return link;
    }

    onScroll(event) {
        this.position = document.documentElement.scrollTop;
        this.update();
    }

    onResize(event) {
        this.limit = this.article.offsetTop;
        this.update();
    }

    update() {
        this.setFixed(this.position >= this.limit);
    }

    setFixed(fixed) {
        if (fixed === this.fixed) {
            return;
        }

        this.fixed = fixed;

        if (this.fixed) {
            this.element.classList.add('fixed');
            this.element.top = this.position;
        } else {
            this.element.classList.remove('fixed');
        }
    }
}

module.exports = Summary;
