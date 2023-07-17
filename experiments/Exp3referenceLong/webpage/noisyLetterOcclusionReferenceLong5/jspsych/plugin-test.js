var jsPsychTest = (function (jspsych) {
  "use strict";

  const info = {
		name: 'p5Text',
		parameters: {}
	};

  /**
   * **PLUGIN-NAME**
   *
   * SHORT PLUGIN DESCRIPTION
   *
   * @author MATAN MAZOR
   * @see {@link https://DOCUMENTATION_URL DOCUMENTATION LINK TEXT}
   */
  class TestPlugin {
    constructor(jsPsych) {
      this.jsPsych = jsPsych;
    }
    trial(display_element, trial) {

      display_element.innerHTML = ''

      //open a p5 sketch
      let sketch = function(p) {

        //sketch setup
        p.setup = function() {
          p.createCanvas(window.innerWidth, window.innerHeight);
          p.background(128);
        }.bind(this)

        p.draw = function ()  {
        }.bind(this)

        p.mouseClicked = function() {
          p.remove()
          var trial_data = {}
          jsPsych.finishTrial(trial_data);
        }.bind(this)

      }.bind(this)
      let myp5 = new p5(sketch);
    }
  }
  TestPlugin.info = info;

  return TestPlugin;
})(jsPsychModule);
