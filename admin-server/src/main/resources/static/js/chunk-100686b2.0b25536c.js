(window["webpackJsonp"]=window["webpackJsonp"]||[]).push([["chunk-100686b2"],{"57f2":function(t,a,n){var e,r;!function(i,o){e=o,r="function"===typeof e?e.call(a,n,a,t):e,void 0===r||(t.exports=r)}(0,(function(t,a,n){var e=function(t,a,n,e,r,i){for(var o=0,u=["webkit","moz","ms","o"],s=0;s<u.length&&!window.requestAnimationFrame;++s)window.requestAnimationFrame=window[u[s]+"RequestAnimationFrame"],window.cancelAnimationFrame=window[u[s]+"CancelAnimationFrame"]||window[u[s]+"CancelRequestAnimationFrame"];window.requestAnimationFrame||(window.requestAnimationFrame=function(t,a){var n=(new Date).getTime(),e=Math.max(0,16-(n-o)),r=window.setTimeout((function(){t(n+e)}),e);return o=n+e,r}),window.cancelAnimationFrame||(window.cancelAnimationFrame=function(t){clearTimeout(t)});var l=this;for(var m in l.options={useEasing:!0,useGrouping:!0,separator:",",decimal:".",easingFn:null,formattingFn:null},i)i.hasOwnProperty(m)&&(l.options[m]=i[m]);""===l.options.separator&&(l.options.useGrouping=!1),l.options.prefix||(l.options.prefix=""),l.options.suffix||(l.options.suffix=""),l.d="string"==typeof t?document.getElementById(t):t,l.startVal=Number(a),l.endVal=Number(n),l.countDown=l.startVal>l.endVal,l.frameVal=l.startVal,l.decimals=Math.max(0,e||0),l.dec=Math.pow(10,l.decimals),l.duration=1e3*Number(r)||2e3,l.formatNumber=function(t){var a,n,e,r;if(t=t.toFixed(l.decimals),t+="",a=t.split("."),n=a[0],e=a.length>1?l.options.decimal+a[1]:"",r=/(\d+)(\d{3})/,l.options.useGrouping)for(;r.test(n);)n=n.replace(r,"$1"+l.options.separator+"$2");return l.options.prefix+n+e+l.options.suffix},l.easeOutExpo=function(t,a,n,e){return n*(1-Math.pow(2,-10*t/e))*1024/1023+a},l.easingFn=l.options.easingFn?l.options.easingFn:l.easeOutExpo,l.formattingFn=l.options.formattingFn?l.options.formattingFn:l.formatNumber,l.version=function(){return"1.7.1"},l.printValue=function(t){var a=l.formattingFn(t);"INPUT"===l.d.tagName?this.d.value=a:"text"===l.d.tagName||"tspan"===l.d.tagName?this.d.textContent=a:this.d.innerHTML=a},l.count=function(t){l.startTime||(l.startTime=t),l.timestamp=t;var a=t-l.startTime;l.remaining=l.duration-a,l.options.useEasing?l.countDown?l.frameVal=l.startVal-l.easingFn(a,0,l.startVal-l.endVal,l.duration):l.frameVal=l.easingFn(a,l.startVal,l.endVal-l.startVal,l.duration):l.countDown?l.frameVal=l.startVal-(l.startVal-l.endVal)*(a/l.duration):l.frameVal=l.startVal+(l.endVal-l.startVal)*(a/l.duration),l.countDown?l.frameVal=l.frameVal<l.endVal?l.endVal:l.frameVal:l.frameVal=l.frameVal>l.endVal?l.endVal:l.frameVal,l.frameVal=Math.round(l.frameVal*l.dec)/l.dec,l.printValue(l.frameVal),a<l.duration?l.rAF=requestAnimationFrame(l.count):l.callback&&l.callback()},l.start=function(t){return l.callback=t,l.rAF=requestAnimationFrame(l.count),!1},l.pauseResume=function(){l.paused?(l.paused=!1,delete l.startTime,l.duration=l.remaining,l.startVal=l.frameVal,requestAnimationFrame(l.count)):(l.paused=!0,cancelAnimationFrame(l.rAF))},l.reset=function(){l.paused=!1,delete l.startTime,l.startVal=a,cancelAnimationFrame(l.rAF),l.printValue(l.startVal)},l.update=function(t){cancelAnimationFrame(l.rAF),l.paused=!1,delete l.startTime,l.startVal=l.frameVal,l.endVal=Number(t),l.countDown=l.startVal>l.endVal,l.rAF=requestAnimationFrame(l.count)},l.printValue(l.startVal)};return e}))},7031:function(t,a,n){"use strict";n.r(a);var e=function(){var t=this,a=t.$createElement,n=t._self._c||a;return n("div",[n("p",{class:t.className,style:{textAlign:"center",color:t.color,fontSize:t.countSize,fontWeight:t.countWeight}},[n("span",{attrs:{id:t.idName}},[t._v(t._s(t.startVal))]),n("span",[t._v(t._s(t.unit))])]),t._t("intro")],2)},r=[],i=(n("c5f6"),n("57f2")),o=n.n(i);function u(t){var a=0,n="";return t<1e3?a=t:t>=1e3&&t<1e6?(a=parseInt(t/1e3),n="K+"):t>=1e6&&t<1e10?(a=parseInt(t/1e6),n="M+"):(a=parseInt(t/1e9),n="B+"),{val:a,unit:n}}var s={data:function(){return{unit:"",demo:{}}},name:"countUp",props:{idName:String,className:String,startVal:{type:Number,default:0},endVal:{type:Number,required:!0},decimals:{type:Number,default:0},duration:{type:Number,default:2},delay:{type:Number,default:500},options:{type:Object,default:function(){return{useEasing:!0,useGrouping:!0,separator:",",decimal:"."}}},color:String,countSize:{type:String,default:"30px"},countWeight:{type:Number,default:700},introText:[String,Number]},mounted:function(){var t=this;this.$nextTick((function(){setTimeout((function(){var a=u(t.endVal),n=a.val;t.unit=a.unit;var e={};t.demo=e=new o.a(t.idName,t.startVal,n,t.decimals,t.duration,t.options),e.error||e.start()}),t.delay)}))},watch:{endVal:function(t){var a=u(t);a.val;this.unit=a.unit}}},l=s,m=n("2877"),c=Object(m["a"])(l,e,r,!1,null,null,null);a["default"]=c.exports}}]);