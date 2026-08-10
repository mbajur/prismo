import {Controller} from "@hotwired/stimulus"
import Tagify from '@yaireo/tagify'
import {get, post} from '@rails/request.js'
import debounce from "debounce"

export default class extends Controller {
  static targets = ['urlInput', 'titleInput', 'fetchTitleBtn', 'tagsInput', 'tagsPhantomInput']

  connect() {
    this._initTags()
  }

  async fetchTitle(e) {
    e.preventDefault()

    if (this.fetchTitleBtnDisabled) return false
    this.loading = true

    let resp = await post('/posts/scrap_url', {query: {url: this.url}, responseKind: 'json'})

    if (resp.ok) {
      let data = await resp.json
      this.title = data.title
      this.url = data.url
    } else {
      let data = await resp.json
      alert(data.errors[0])
    }

    this.loading = false
  }

  handleUrlChange() {
    this.urlDisabled = this.urlInputTarget.value.length == 0
  }

  _initTags() {
    let _this = this

    this.tagify = new Tagify(this.tagsPhantomInputTarget, {
      delimiters: ',| ',
      maxTags: this.tagsPhantomInputTarget.dataset.maxTags,
      whitelist: [],
      dropdown: {enabled: 0},
      transformTag(tag) {tag.value = tag.value.replace('#', '')}
    })

    this.tagify.on('add', () => {this._updateTagsInput()})
    this.tagify.on('remove', () => {this._updateTagsInput()})

    let fetchTags = debounce((e) => {this._fetchTags(e.detail.value, true)}, 300)
    this.tagify.on('input', (e) => fetchTags(e))

    this._fetchTags('')
  }

  _updateTagsInput() {
    let val = this.tagify.value.map((tag) => {return tag.value}).join(',')
    this.tagsList = val
  }

  async _fetchTags(value, showDropdown = false) {
    let resp = await get('/tags', {query: {q: value}, responseKind: 'json'})

    if (resp.ok) {
      let data = await resp.json
      this.tagify.whitelist = data.map((tag) => {return tag.name})
      if (showDropdown) this.tagify.dropdown.show.call(this.tagify, value)
    }
  }

  get url() {
    return this.urlInputTarget.value
  }

  get fetchTitleBtnDisabled() {
    return this.fetchTitleBtnTarget.classList.contains('btn--disabled')
  }

  set title(title) {
    this.titleInputTarget.value = title
  }

  set url(url) {
    this.urlInputTarget.value = url
  }

  set urlDisabled(disable) {
    disable ?
      this.fetchTitleBtnTarget.setAttribute('disabled', 'true') :
      this.fetchTitleBtnTarget.removeAttribute('disabled')
  }

  set tagsList(value) {
    this.tagsInputTarget.setAttribute('value', value)
  }

  set loading(value) {
    value ?
      this.fetchTitleBtnTarget.setAttribute('disabled', 'true') :
      this.fetchTitleBtnTarget.removeAttribute('disabled')
  }
}
