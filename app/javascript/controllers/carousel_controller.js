import { Controller } from "@hotwired/stimulus"

// Accessible carousel controller
export default class extends Controller {
  static targets = ["track", "item", "prev", "next"]
  static values = { autoplay: Boolean, interval: Number }

  connect() {
    this.items = this.itemTargets && this.itemTargets.length ? this.itemTargets : Array.from(this.trackTarget.children)
    this.currentIndex = 0
    this.isPlaying = !!this.autoplayValue
    this.interval = this.intervalValue || 3000

    this.update() // set initial state

    if (this.isPlaying) this.startAutoplay()

    // pause on hover / focus
    this.element.addEventListener('mouseenter', () => this.pause())
    this.element.addEventListener('mouseleave', () => this.resume())
    this.element.addEventListener('focusin', () => this.pause())
    this.element.addEventListener('focusout', () => this.resume())

    // keyboard navigation
    this.keyHandler = this.keyHandler.bind(this)
    this.element.addEventListener('keydown', this.keyHandler)
    // allow track to be announced as a list
    this.trackTarget.setAttribute('role', 'list')
    this.items.forEach((it) => it.setAttribute('role', 'listitem'))
  }

  disconnect() {
    this.stopAutoplay()
    this.element.removeEventListener('keydown', this.keyHandler)
  }

  keyHandler(e) {
    if (e.key === 'ArrowRight') {
      e.preventDefault()
      this.next()
    } else if (e.key === 'ArrowLeft') {
      e.preventDefault()
      this.prev()
    } else if (e.key === 'Home') {
      e.preventDefault(); this.goTo(0)
    } else if (e.key === 'End') {
      e.preventDefault(); this.goTo(this.items.length - 1)
    }
  }

  prev() { this.goTo(Math.max(0, this.currentIndex - 1)) }
  next() { this.goTo(Math.min(this.items.length - 1, this.currentIndex + 1)) }

  goTo(index) {
    this.currentIndex = index
    const node = this.items[this.currentIndex]
    if (!node) return
    // align the track so current item is at left edge
    const offset = node.offsetLeft
    this.trackTarget.style.transform = `translateX(-${offset}px)`
    this.update()
  }

  update() {
    this.items.forEach((it, i) => {
      const isCurrent = i === this.currentIndex
      it.setAttribute('aria-hidden', isCurrent ? 'false' : 'true')
      it.tabIndex = isCurrent ? 0 : -1
    })

    if (this.hasPrevTarget) this.prevTarget.disabled = this.currentIndex <= 0
    if (this.hasNextTarget) this.nextTarget.disabled = this.currentIndex >= this.items.length - 1
  }

  startAutoplay() {
    if (this.autoplayTimer) return
    this.autoplayTimer = setInterval(() => {
      if (this.currentIndex < this.items.length - 1) this.next()
      else this.goTo(0)
    }, this.interval)
  }

  stopAutoplay() {
    if (this.autoplayTimer) { clearInterval(this.autoplayTimer); this.autoplayTimer = null }
  }

  pause() { this.stopAutoplay(); this.isPlaying = false }
  resume() { if (this.autoplayValue && !this.autoplayTimer) { this.startAutoplay(); this.isPlaying = true } }
}
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["track"]
  static values = {
    interval: { type: Number, default: 3500 },
    autoplay: { type: Boolean, default: true }
  }

  connect() {
    this.index = 0
    this._onResize = this.scrollToIndex.bind(this)
    this._onVisibility = this._handleVisibilityChange.bind(this)

    window.addEventListener('resize', this._onResize)
    document.addEventListener('visibilitychange', this._onVisibility)

    // keyboard navigation
    this.element.setAttribute('tabindex', this.element.getAttribute('tabindex') || '0')
    this._onKeyDown = this._onKeyDown.bind(this)
    this.element.addEventListener('keydown', this._onKeyDown)

    // pointer drag
    this._onPointerDown = this._onPointerDown.bind(this)
    this._onPointerMove = this._onPointerMove.bind(this)
    this._onPointerUp = this._onPointerUp.bind(this)
    this.element.addEventListener('pointerdown', this._onPointerDown)

    // pause on hover
    this.element.addEventListener('mouseenter', () => this.stop())
    this.element.addEventListener('mouseleave', () => this.start())

  // initial alignment
  setTimeout(() => { this.scrollToIndex() }, 50)

    if (this.autoplayValue) this.start()
  }

  disconnect() {
    window.removeEventListener('resize', this._onResize)
    document.removeEventListener('visibilitychange', this._onVisibility)
  this.element.removeEventListener('keydown', this._onKeyDown)
  this.element.removeEventListener('pointerdown', this._onPointerDown)
  this.element.removeEventListener('pointermove', this._onPointerMove)
  this.element.removeEventListener('pointerup', this._onPointerUp)
    this.element.removeEventListener('pointercancel', this._onPointerUp)
    this.stop()
  }

  start() {
    this.stop()
    if (!this.autoplayValue) return
    this.timer = setInterval(() => this.next(), this.intervalValue)
  }

  stop() {
    if (this.timer) { clearInterval(this.timer); this.timer = null }
  }

  next() {
    const len = this._len()
    if (len === 0) return
    this.index = (this.index + 1) % len
    this.scrollToIndex()
  }

  prev() {
    const len = this._len()
    if (len === 0) return
    this.index = (this.index - 1 + len) % len
    this.scrollToIndex()
  }

  goTo(i) {
    const len = this._len()
    if (len === 0) return
    this.index = Math.max(0, Math.min(i, len - 1))
    this.scrollToIndex()
  }

  _len() { return this.trackTarget ? this.trackTarget.children.length : 0 }

  scrollToIndex() {
    const viewport = this.element.querySelector('.carousel-viewport')
    if (!viewport || !this.trackTarget) return
    const item = this.trackTarget.children[this.index]
    if (!item) return

    const viewportWidth = viewport.offsetWidth
    const itemWidth = item.offsetWidth
    const left = item.offsetLeft - Math.max(0, (viewportWidth - itemWidth) / 2)
    // use transform to animate; keep translate as integer to avoid subpixel jitter
    this.trackTarget.style.transform = `translateX(${ -Math.round(left) }px)`
  }

  _handleVisibilityChange() { document.hidden ? this.stop() : this.start() }

  /* ----------------- POINTER / SWIPE HANDLING ----------------- */
  _onPointerDown(e) {
    if (e.isPrimary === false) return
    this._pointerActive = true
    this._startX = e.clientX
    this._startTime = Date.now()
    this._startTransform = this._currentTranslate() || 0
    this.element.setPointerCapture(e.pointerId)
    this.element.addEventListener('pointermove', this._onPointerMove)
    this.element.addEventListener('pointerup', this._onPointerUp)
    this.element.addEventListener('pointercancel', this._onPointerUp)
    this.stop()
  }

  _onPointerMove(e) {
    if (!this._pointerActive) return
    const dx = e.clientX - this._startX
    const translate = this._startTransform + -dx
    this.trackTarget.style.transition = 'none'
    this.trackTarget.style.transform = `translateX(${translate}px)`
  }

  _onPointerUp(e) {
    if (!this._pointerActive) return
    this._pointerActive = false
    this.element.releasePointerCapture && this.element.releasePointerCapture(e.pointerId)
    this.element.removeEventListener('pointermove', this._onPointerMove)
    this.element.removeEventListener('pointerup', this._onPointerUp)
    this.element.removeEventListener('pointercancel', this._onPointerUp)

    const dx = (e.clientX || 0) - (this._startX || 0)
    const dt = Date.now() - (this._startTime || 0)
    const velocity = dx / Math.max(1, dt)
    const threshold = 40
    // prefer velocity+distance
    if (dx > threshold || velocity > 0.3) this.prev()
    else if (dx < -threshold || velocity < -0.3) this.next()
    else {
      // snap back to current
      this.scrollToIndex()
    }

    // restore transition
    this.trackTarget.style.transition = ''
    setTimeout(() => this.start(), 300)
  }

  _currentTranslate() {
    if (!this.trackTarget) return 0
    const m = getComputedStyle(this.trackTarget).transform
    if (!m || m === 'none') return 0
    const values = m.match(/matrix\((.+)\)/)
    if (!values) return 0
    const parts = values[1].split(', ')
    return parseFloat(parts[4]) || 0
  }

  /* ----------------- INDICATORS ----------------- */
  // indicators removed - visual dots are not used per design request

  /* ----------------- KEYBOARD ----------------- */
  _onKeyDown(e) {
    if (e.key === 'ArrowLeft') { e.preventDefault(); this.prev(); this._updateIndicators() }
    else if (e.key === 'ArrowRight') { e.preventDefault(); this.next(); this._updateIndicators() }
  }
}
