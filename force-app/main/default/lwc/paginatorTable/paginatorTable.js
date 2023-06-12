import { LightningElement, api } from 'lwc';

export default class PaginatorTable extends LightningElement {
    /** The current page number. */
    @api pageNumber;
    /** The number of items on a page. */
    @api pageSize;
    /** The total number of items in the list. */
    @api totalItemCount;

    handlePrevious() {
        this.dispatchEvent(new Event('previous'));
    }

    handleNext() {
        this.dispatchEvent(new Event('next'));
    }

    get currentPageNumber() {
        window.console.log(this.totalItemCount);
        window.console.log(this.pageNumber);
        return this.totalItemCount === 0 ? 0 : this.pageNumber;
    }

    get isFirstPage() {
        return this.pageNumber === 1;
    }
    get isLastPage() {
        window.console.log(this.totalPages);
        return this.pageNumber >= this.totalPages;
    }
    get totalPages() {
        return Math.ceil(this.totalItemCount / this.pageSize);
    }
}