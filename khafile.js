let project = new Project('TexturePacker Test');
project.addAssets('Assets/**');
project.addShaders('Shaders/**');
project.addSources('src');
//project.addParameter('-dce no');
project.windowOptions.width = 1024;
project.windowOptions.height = 768;
resolve( project );