class Summary {
    /**
     * @param {Element} element
     * @param {Element[]} titles
     */
    constructor(element, titles) {
        this.element = element;
        this.titles = titles;

        this.titles.forEach(title => this.element.appendChild(this.createLink(title)));
    }

    createLink(title) {
        const { id, innerText, tagName } = title;
        const link = document.createElement('a');

        link.setAttribute('href', `#${id}`);
        link.innerText = innerText;
        link.className = tagName.toLowerCase();

        return link;
    }
}

module.exports = Summary;
