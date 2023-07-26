var jsNoisyLetter = (function (jspsych) {
  "use strict";

  const info = {
		name: 'noisyLetter',
		parameters: {
			image: {
					type: jspsych.ParameterType.IMAGE,
					default: '',
				},
			context_image: {
				type: jspsych.ParameterType.IMAGE,
				default: ''
			},
			context_string: {
				type: jspsych.ParameterType.STRING,
				default: ' B LT'
			},
			pixel_size_factor: {
				type: jspsych.ParameterType.INT,
				default: 3,
				description: 'the actual width in pixels of every pixel in the image'
			},
      max_p: {
        type: jspsych.ParameterType.FLOAT,
        default: 0.5,
        description: 'the maximum visibility'
      },
      latency: {
        type: jspsych.ParameterType.INT,
        default: 20,
        description: 'number of frames to reach max_p/2'
      },
      present: {
        type: jspsych.ParameterType.INT,
        default: 1,
        description: 'is the letter present (1) or absent (0)'
      },
      flat: {
        type: jspsych.ParameterType.BOOL,
        default: true,
        description: 'if true, the letter does not slowly emerge from the background but just appears immediately at max_p'
      },
			// p_function: {
			// 	type: jspsych.ParameterType.FUNCTION,
			// 	default: (frame_index)=>{return 0.3},
			// 	description: 'probability of showing true value as a function of frame_index'
			// },
			frame_rate: {
				type: jspsych.ParameterType.INT,
				pretty_name: "Frame rate",
				default: 15,
				description: "Frame rate (Hz)"
			},
      choices: {
        type: jspsych.ParameterType.STRING,
        pretty_name: "Choices",
        description: "Choice keys. The first item corresponds to no letter, the second to letter",
        default: ['f','g']
      },
      post_click_delay: {
        type: jspsych.ParameterType.INT,
        pretty_name: "Post click delay",
        default: 200,
        description: "Time to display choice before moving to the feebdack screen (ms)"
      },
      steepness: {
        type: jspsych.ParameterType.FLOAT,
        pretty_name: "steepness",
        default: 0.1,
      },
      hide_proportion: {
        type: jspsych.ParameterType.FLOAT,
        pretty_name: "hide proportion",
        default: 0,
        description: "proportion of pixels to hide"
      },
      hide_color: {
        type: jspsych.ParameterType.STRING,
        pretty_name: "the color of hidden pixels",
        default: '#000000'
      }
		}
	}

  /**
   * **PLUGIN-NAME**
   *
   * SHORT PLUGIN DESCRIPTION
   *
   * @author MATAN MAZOR
   * @see {@link https://DOCUMENTATION_URL DOCUMENTATION LINK TEXT}
   */
  class NoisyLetterPlugin {
    constructor(jsPsych) {
      this.jsPsych = jsPsych;
    }
    trial(display_element, trial) {

      display_element.innerHTML = '<div id="p5_loading" style="font-size:60px">+</div>';

      //open a p5 sketch
      let sketch = (p) => {

        const du = p.min([window.innerWidth, window.innerHeight, 600])*7/10 //drawing unit

        p.preload = () => {
    			this.img = p.loadImage(trial.image);
    		}

        const p_function = trial.flat? (frame_number)=>{return (trial.present*trial.max_p)} : (frame_number)=>{return (trial.present*trial.max_p)/(1+Math.exp(-trial.steepness*(frame_number-trial.latency)))}

        var draw_choices = (response) => {

            p.textFont('Noto Sans Mono');
            if (trial.choices[0]=='f') {
            p.push()
            p.translate(-window.innerWidth/4,0)
            p.textSize(20)
            p.fill(response=='f'? 255 : 200)
            p.text('just noise',0,0)
            p.fill(response=='g'? 255 : 200)
            p.translate(window.innerWidth/2,0)
            p.text('letter in noise',0,0)
            p.pop()
          } else if (trial.choices[0]=='g') {
            p.push()
            p.translate(-window.innerWidth/4,0)
            p.textSize(20)
            p.fill(response=='f'? 255 : 200)
            p.text('letter in noise',0,0)
            p.translate(window.innerWidth/2,0)
            p.fill(response=='g'? 255 : 200)
            p.text('just noise',0,0)
            p.pop()
          }

          p.push()
          p.textSize(15)
          p.fill(200);
          p.translate(-window.innerWidth/4,40)
          p.text('press F',0,0)
          p.translate(window.innerWidth/2,0)
          p.text('press G',0,0)
          p.pop()
          p.pop()

      }

        //sketch setup
        p.setup = () => {
          p.createCanvas(window.innerWidth, window.innerHeight);
          p.fill(255); //white
          p.strokeWeight(0)
          p.background(128); //gray
          p.frameRate(trial.frame_rate);
          p.textFont('Noto Sans Mono');
          p.textAlign(p.CENTER, p.CENTER)
          p.rectMode(p.TOP, p.LEFT);
          p.imageMode(p.CENTER);
          p.noCursor();

          trial.response  = NaN;
          trial.RT = window.myresponses.RT[window.click_number];
          trial.nframes = window.myresponses.nframes[window.click_number]
          console.log(trial.present)
          window.clicked=0

          draw_choices(trial.response)
          this.img.loadPixels();

          window.img_pixel_data = [];
          window.presented_pixel_data = [];

          for (let y = 0; y < this.img.height; y++) {
            var row = [];
            for (let x = 0; x < this.img.width; x++) {
              row.push(this.img.get(x,y))
            }
            window.img_pixel_data.push(row);
          }

          // determine which pixels to hide

          var total_number_of_pixels = this.img.height*this.img.width;

          var number_of_pixels_to_hide = Math.round(total_number_of_pixels*trial.hide_proportion)
          trial.hidden_pixels = p.shuffle([...Array(total_number_of_pixels).keys()]).slice(0,number_of_pixels_to_hide)

          p.textSize(this.img.height*trial.pixel_size_factor);

          // determine top left point of image
          window.ref_x = p.innerWidth/2;
          window.ref_y = p.innerHeight/2;

          window.frame_number = 0;

          window.start_time = p.millis()
        }

        p.draw = () => {
          // if (p.millis()-window.start_time < trial.RT + trial.post_click_delay) {
          if (window.frame_number<=trial.nframes) {
            p.background(128); //gray
            p.text(trial.context_string,p.width/2,p.height/2);
            var presented_frame = [];
            for (let y = 0; y < this.img.height; y++) {
              var presented_row = [];
              for (let x = 0; x < this.img.width; x++) {
                p.push()
                if (trial.hidden_pixels.includes(y*this.img.width+x)) {
                  p.fill(trial.hide_color)
                  presented_row.push(NaN);
                } else {
                  // var color = window.img_pixel_data[y][x]
                  if (Math.random() <= p_function(window.frame_number)) {
                    p.fill(window.img_pixel_data[y][x]);
                    //Saving only the R channel! to save all four channels, delete the [0] from the next line
                    presented_row.push(window.img_pixel_data[y][x][0]);
                  } else {
                    var random_x = Math.floor(Math.random()*this.img.width);
                    var random_y = Math.floor(Math.random()*this.img.height);
                    p.fill(window.img_pixel_data[random_y][random_x]);
                    //Saving only the R channel! to save all four channels, delete the [0] from the next line
                    presented_row.push(window.img_pixel_data[random_y][random_x][0]);
                  }
                }
                p.translate(p.width/2+x*trial.pixel_size_factor - this.img.width/2*trial.pixel_size_factor,
                  p.height/2+y*trial.pixel_size_factor - this.img.height/2*trial.pixel_size_factor)
                p.rect(0,0,trial.pixel_size_factor,trial.pixel_size_factor)
                p.pop()
              }
              presented_frame.push(presented_row);
            }
            window.presented_pixel_data.push(presented_frame);
            window.frame_number++

            p.push();
            p.translate(window.innerWidth/2,window.innerHeight/2)

            draw_choices(trial.response)

            // emulate responses
            if ((p.millis()-window.start_time >= trial.RT) & window.clicked==0) {
              window.clicked=1
              trial.response=window.myresponses.response[window.click_number]
              window.click_number++
              window.trial_data = {
                presented_pixel_data: window.presented_pixel_data,
                RT: trial.RT,
                response: trial.response,
                context_string: trial.context_string,
                context_img: trial.context_image,
                max_p: trial.max_p,
                hide_proportion: trial.hide_proportion,
                descend: trial.descend
              };
            }

          } else {
            p.remove()
            // end trial
            this.jsPsych.finishTrial(window.trial_data);
          }
        }

    };



      let myp5 = new p5(sketch);
    }
  }
  NoisyLetterPlugin.info = info;

  return NoisyLetterPlugin;
})(jsPsychModule);
