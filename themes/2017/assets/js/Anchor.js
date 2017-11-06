class Anchor {
    /**
     * @param {Element} element
     */
    constructor(element) {
        this.element = element;

        if (!this.element.getElementsByClassName('anchor').length) {
            this.element.appendChild(this.createLink());
        }
    }

    createLink() {
        const { id } = this.element;
        const link = document.createElement('a');

        link.setAttribute('href', `#${id}`);
        link.className = 'anchor';

        return link;
    }
}

module.exports = Anchor;
