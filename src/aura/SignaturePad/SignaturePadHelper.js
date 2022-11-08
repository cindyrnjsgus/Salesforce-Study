({
    doInit : function(component, event, helper) {
        var canvas1, ctx, flag = false,
        prevX = 0,
        currX = 0,
        prevY = 0,
        currY = 0,
        dot_flag = false;

        var x = "black",
            y = 2,
            w,h;

        canvas1=component.find('installer').getElement();

        var ratio = Math.max(window.devicePixelRatio || 1, 1);
        w = canvas1.width*ratio;
        h = canvas1.height*ratio;
        ctx = canvas1.getContext("2d");
        console.log('ctx:='+ctx);

        canvas1.addEventListener("mousemove", function (e) {
            findxy('move', e)
        }, false);
        canvas1.addEventListener("mousedown", function (e) {
            findxy('down', e)
        }, false);
        canvas1.addEventListener("mouseup", function (e) {
            findxy('up', e)
        }, false);
        canvas1.addEventListener("mouseout", function (e) {
            findxy('out', e)
        }, false);

        // Set up touch events for mobile, etc
        canvas1.addEventListener("touchstart", function (e) {
            var touch = e.touches[0];
            console.log('touch start:='+touch);
            var mouseEvent = new MouseEvent("mousedown", {
                clientX: touch.clientX,
                clientY: touch.clientY
            });
            canvas1.dispatchEvent(mouseEvent);
             e.preventDefault();
        }, false);
        canvas1.addEventListener("touchend", function (e) {
            var mouseEvent = new MouseEvent("mouseup", {});
            canvas1.dispatchEvent(mouseEvent);
        }, false);
        canvas1.addEventListener("touchmove", function (e) {
            var touch = e.touches[0];
            var mouseEvent = new MouseEvent("mousemove", {
                clientX: touch.clientX,
                clientY: touch.clientY
            });
            canvas1.dispatchEvent(mouseEvent);
             e.preventDefault();

        }, false);


        // Get the position of a touch relative to the canvas
        function getTouchPos(canvasDom, touchEvent) {
            var rect = canvasDom.getBoundingClientRect();
            return {
                x: touchEvent.touches[0].clientX - rect.left,
                y: touchEvent.touches[0].clientY - rect.top
            };
        }

        function findxy(res, e){
            const rect = canvas1.getBoundingClientRect();
            if (res == 'down') {
                prevX = currX;
                prevY = currY;
                currX = e.clientX - rect.left ;
                currY = e.clientY -  rect.top;

                flag = true;
                dot_flag = true;
                if (dot_flag) {
                    ctx.beginPath();
                    ctx.fillStyle = x;
                    ctx.fillRect(currX, currY, 2, 2);
                    ctx.closePath();
                    dot_flag = false;
                }
            }
            if (res == 'up' || res == "out") {
                flag = false;
            }
            if (res == 'move') {
                if (flag) {
                    prevX = currX;
                    prevY = currY;
                    currX = e.clientX -  rect.left;
                    currY = e.clientY - rect.top;
                    draw(component,ctx);
                }
            }
        }
        function draw() {
            ctx.beginPath();
            ctx.moveTo(prevX, prevY);
            ctx.lineTo(currX, currY);
            ctx.strokeStyle = x;
            ctx.lineWidth = y;
            ctx.stroke();
            ctx.closePath();
        }
    },

    doErase : function(component, event, helper){
        var installer = component.find('installer').getElement();
        var ctx1 = installer.getContext("2d");
        var w = installer.width;
        var h = installer.height;
        ctx1.clearRect(0, 0, w, h);
    },

    isCanvasEmpty : function(canvas){
        const blankCanvas = document.createElement('canvas');
        blankCanvas.width = canvas.width;
        blankCanvas.height = canvas.height;
        return canvas.toDataURL() === blankCanvas.toDataURL();
    },

    doSave : function(component, event, helper){

        var pad1 = component.find('installer').getElement();
        var dataUrl1 = pad1.toDataURL();
        var strDataURI1 = dataUrl1.replace(/^data:image\/(png|jpg);base64,/, "");
        var action = component.get("c.saveSignature");

        action.setParams({
            signatureBody : strDataURI1,
            recordId : component.get("v.recordId"),
            sObjectName : component.get("v.sObjectName")
        });

        action.setCallback(this,function(response){

            var returnVal = response.getReturnValue();
            var strStatus = returnVal.strStatus;

            console.log('returnval 테스트 :'+returnVal);

            if(strStatus === "SUCCESS"){
                component.find("notifLib").showToast({
                       "variant":"success",
                       "title": "success",
                       "mode":"dismissable",
                       "message":"저장되었습니다."
                });
                $A.get('e.force:refreshView').fire();
                $A.get("e.force:closeQuickAction").fire();

            } else if(strStatus === "ERROR"){
                component.find("notifLib").showToast({
                       "variant":"error",
                       "title": "error",
                       "mode":"dismissable"
                });
            }
        });
        $A.enqueueAction(action);
    }

});