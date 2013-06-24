///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
//
//  Folders.js
//
///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

var RootDrive = {
 obj:null,
 objs:new Array(),
 pos:new Point(0,0),
 lastViewed:null,
 imgHeight:16
}

///////////////////////////////////////////////////////////////////////////////////////////////

var Images = {
 getImage:Images_getImage,
 directory:'images/',
 ROOT:'root.gif',
 FOLDER:'folder.gif',
 OPEN_FOLDER:'openfolder.gif',
 BLANK:'blank.gif',
 COLLAPSE:'collapse.gif',
 COLLAPSE_LAST:'collapse_last.gif',
 EXPAND:'expand.gif',
 EXPAND_LAST:'expand_last.gif',
 LINK_LAST:'1.gif',
 LINK_VERT:'3.gif',
 LINK_MORE:'2.gif'
}

// pre-load images
for(var i in Images){
 var objImage=new Image();
 objImage.src='images/'+eval('Images.'+i)
}

///////////////////////////////////////////////////////////////////////////////////////////////

var FileView=parent.frames[1];

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  OBJECT : Point(x,y)
//
///////////////////////////////////////////////////////////////////////////////////////////////

function Point(x,y){
 this.x=x;
 this.y=y
}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  OBJECT : Drive(label)
//
///////////////////////////////////////////////////////////////////////////////////////////////

function Drive(label){
 this.label=label;
 this.id=null;
 this.pos=new Point(10,10);
 this.folders=new Array();
 this.files=new Array();
 this.addFolder=DriveFolder_addFolder;
 this.addFile=new Function('f','this.files.push(f)');
 this.build=Drive_build;
 this.refresh=Drive_refresh;
 this.showFolder=Drive_showFolder;
 this.view=DriveFolder_viewFolder;
}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  OBJECT : Folder(name,secure)
//
///////////////////////////////////////////////////////////////////////////////////////////////

function Folder(name,secure){
 this.name=name;
 this.id=null;
 this.image=Images.FOLDER;
 this.expanded=false;
 this.secure=secure;
 this.last=true;
 this.parent=null;
 this.folders=new Array();
 this.files=new Array();
 this.addFile=new Function('f','this.files.push(f)');
 this.addFolder=DriveFolder_addFolder;
 this.build=Folder_build;
 this.refresh=Folder_refresh;
 this.cascade=Folder_cascade;
 this.setExpandImage=Folder_setExpandImage;
 this.view=DriveFolder_viewFolder;
}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  OBJECT : File(name,type,directory)
//
///////////////////////////////////////////////////////////////////////////////////////////////

function File(name,type,directory){
 this.name=name;
 this.type=(type==null)?FileTypes.FILE:type;
 this.directory=directory
}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  DriveFolder_addFolder(f,i)
//
///////////////////////////////////////////////////////////////////////////////////////////////

function DriveFolder_addFolder(objFolder){
 objFolder.parent=this;
 if(this.folders.length>0)
  this.folders[this.folders.length-1].last=false;
 this.folders.push(objFolder)
}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  Drive_build()
//
///////////////////////////////////////////////////////////////////////////////////////////////

function Drive_build(){

 this.files.sort(FCompare);
 this.folders.sort(FCompare);

 var action='javascript:RootDrive.obj.view(0,true)';
 var obj=new FileObj();
 obj.addContent(Images.getImage(Images.ROOT).link(action));
 obj.addContent(this.label.link(action));
 obj.build();
 this.id=obj.getId();

 for(var i in this.folders){
  var objFolder=this.folders[i];
  var more=(i<this.folders.length-1)?true:false;
  objFolder.index=i;
  objFolder.build(more,0)
 }

 RootDrive.obj=this;
 window.onload=Window_onload;

}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  Folder_build(more,depth)
//
///////////////////////////////////////////////////////////////////////////////////////////////

function Folder_build(more,depth){

 this.files.sort(FCompare);
 this.folders.sort(FCompare);

 var expImg=(more)?(this.folders.length>0)?Images.EXPAND:Images.LINK_MORE
                  :(this.folders.length>0)?Images.EXPAND_LAST:Images.LINK_LAST;
 var obj=new FileObj();
 var expAction=(this.folders.length>0)?'javascript:RootDrive.obj.showFolder('+RootDrive.objs.length+')':'javascript:void(1)';
 var fldAction='javascript:RootDrive.objs['+RootDrive.objs.length+'].view('+RootDrive.objs.length+')';

 for(var i=0;i<depth-1;i++)obj.addContent(Images.getImage(Images.LINK_VERT));
 if(depth>0)obj.addContent(Images.getImage(((this.parent.last)?Images.BLANK:Images.LINK_VERT)));

 obj.addContent(Images.getImage(expImg,obj.getId()+'Exp').link(expAction));
 obj.addContent(Images.getImage(this.image,obj.getId()+'Fld').link(fldAction));
 obj.addContent(this.name.link(fldAction));
 obj.build();
 this.index=RootDrive.objs.length;
 this.id=obj.getId();
 RootDrive.objs.push(this);

 for(var i in this.folders){
  var objFolder=this.folders[i];
  var more=(i<this.folders.length-1)?true:false;
  objFolder.index=i;
  objFolder.build(more,depth+1);
 }

}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  Images_getImage(name,action,id)
//
///////////////////////////////////////////////////////////////////////////////////////////////

function Images_getImage(name,id){
 id=(id==null)?'':'name="'+id+'"';
 return '<img '+id+' src="'+this.directory+name+'" alt="" height="'+RootDrive.imgHeight+'" border="0" />';
}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  Drive_refresh()
//
///////////////////////////////////////////////////////////////////////////////////////////////

function Drive_refresh(){

 var objDoc=getFileObj(this.id);
 objDoc.setVisible(true);
 objDoc.setPos(this.pos.x,this.pos.y);

 RootDrive.pos.y=0;
 for(var i in this.folders){
  var objFolder=this.folders[i]; 
  var objDoc=getFileObj(objFolder.id);
  objDoc.setPos(RootDrive.obj.pos.x,this.pos.y+(RootDrive.imgHeight*(1+RootDrive.pos.y++)));
  objDoc.setVisible(true);
  objFolder.refresh();
 }

}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  Folder_refresh()
//
///////////////////////////////////////////////////////////////////////////////////////////////

function Folder_refresh(){

 for(var i in this.folders){
  var objFolder=this.folders[i];
  var objDoc=getFileObj(objFolder.id);
  if(this.expanded)objDoc.setPos(RootDrive.obj.pos.x,RootDrive.obj.pos.y+(RootDrive.imgHeight*(1+RootDrive.pos.y++)));
  objDoc.setVisible(this.expanded);
  objFolder.refresh();
 }

}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  Folder_cascade()
//
///////////////////////////////////////////////////////////////////////////////////////////////

function Folder_cascade(){

 for(var i in this.folders){
  var objFolder=this.folders[i];
  objFolder.expanded=false;
  if(objFolder.folders.length>0)objFolder.setExpandImage();
  objFolder.cascade()
 }

}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  Folder_setExpandImage()
//
///////////////////////////////////////////////////////////////////////////////////////////////

function Folder_setExpandImage(){
  var objDocImg=eval('document.'+this.id+'Exp');
  objDocImg.src=Images.directory+((this.expanded)?((this.last)?Images.COLLAPSE_LAST:Images.COLLAPSE)
                                                 :((this.last)?Images.EXPAND_LAST:Images.EXPAND));
}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  Drive_showFolder(index)
//
///////////////////////////////////////////////////////////////////////////////////////////////

function Drive_showFolder(index,dontCollapse){
 if(!dontCollapse){
  var obj=RootDrive.objs[index];
  obj.expanded=!obj.expanded;
  obj.setExpandImage();
  if(!obj.expanded){
   obj.cascade();
   obj.view(index)
  }
  RootDrive.obj.refresh();
 }
}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  FCompare(a,b)
//
///////////////////////////////////////////////////////////////////////////////////////////////

function FCompare(x,y){
 var a=x.name.toUpperCase()
 var b=y.name.toUpperCase()
 if(a<b)return -1;
 if(a>b)return 1;
 return 0;
}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  DriveFolder_viewFolder(index,isRoot)
//
///////////////////////////////////////////////////////////////////////////////////////////////

function DriveFolder_viewFolder(index,isRoot){
 FileView.showFolder(this,index,isRoot)
 if(RootDrive.lastViewed!=null){
  document[RootDrive.lastViewed.id+'Fld'].src=Images.directory+Images.FOLDER
 }
 if(!isRoot){
  document[this.id+'Fld'].src=Images.directory+Images.OPEN_FOLDER;
  RootDrive.lastViewed=this;
 }
}

///////////////////////////////////////////////////////////////////////////////////////////////
//
//  Window_onload()
//
///////////////////////////////////////////////////////////////////////////////////////////////

function Window_onload(){

 RootDrive.obj.refresh();
 FileView.location.reload()

}

///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////