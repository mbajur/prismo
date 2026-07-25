import {Application} from "@hotwired/stimulus"
import Timeago from '@stimulus-components/timeago'
import {MarksmithController, ListContinuationController} from '@avo-hq/marksmith'

const application = Application.start()

application.register('timeago', Timeago)
application.register('marksmith', MarksmithController)
application.register('list-continuation', ListContinuationController)

// Configure Stimulus development experience
application.debug = false
window.Stimulus = application

export {application}
