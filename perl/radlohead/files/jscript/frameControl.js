/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
//
//  frameControl.js
//
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////
//
//  detectFrames()
//
/////////////////////////////////////////////////////////////////////

function detectFrames() {

  if (top.location != self.location) {
    self.location = top.location;
  }

}

/////////////////////////////////////////////////////////////////////