jQuery(function(){
    jQuery(".btn_email_apply").click(function(){
        var email = jQuery(".apply_email").val();
        $.ajax({
            url: '../remote/test/apply',
            method: 'POST',
            data: {
                "email": email
            },
            success:function(data){
                //alert(data);
                jQuery(".apply_input").hide();
                jQuery(".apply_success").show();
            }
        });
    });

    jQuery(".btn_email_subscribe").click(function(){
        var email = jQuery(".apply_email").val();
        $.ajax({
            url: '../remote/test/subscribe',
            method: 'POST',
            data: {
                "email": email
            },
            success:function(data){
                //alert(data);
                jQuery(".apply_input").hide();
                jQuery(".apply_success").show();
            }
        });
    });


    //********************
    // task = {
    //   name: 'Start taking advantage of WebSockets',
    //   completed: false
    // }

    // dispatcher = new WebSocketRails('localhost:3000/websocket');

    // dispatcher.trigger('tasks.create', "hehehh");

    // dispatcher.bind('tasks.create_success', function(task) {
    //   //console.log('successfully created ' + task.name);
    //   alert(task);
    // });
    //***************

    // if(typeof(EventSource) !== "undefined") {
    //     var source = new EventSource("http://localhost:3001/spread/send/status");
    //     source.onmessage = function(event) {
    //         jQuery("#send_email_message").val(event.data);
    //         //document.getElementById("result").innerHTML += event.data + "<br>";
    //     };
    // } else {
    //     document.getElementById("result").innerHTML = "Sorry, your browser does not support server-sent events...";
    //     jQuery("#send_email_message").val("error");
    // }

    // var source = new EventSource("http://localhost:3001/spread/send/status");
    // source.onmessage = function(event) {
    //     //alert(event.data);
    //     jQuery("#send_email_message").val("hello");
    //     //document.getElementById("result").innerHTML += event.data + "<br>";
    // };

    // source.onopen = function () {
    //   //alert("dddd");
    //   jQuery("#send_email_message").val("open");
    // };

    // source.addEventListener('update', function(e){
    //     jQuery("#send_email_message").val("update");
    // }, false);

    //*****************
    // connect to server like normal
    // var dispatcher = new WebSocketRails('localhost:3001/websocket');

    // // subscribe to the channel
    // var channel = dispatcher.subscribe('channel_shanwa');

    // // You can also pass an object to the subscription event
    // // var channel = dispatcher.subscribe({channel: 'channel_name', foo: 'bar'});

    // // bind to a channel event
    // channel.bind('event_shanwa', function(data) {
    //   var message = jQuery("#send_email_message").val();
    //   var this_message = "\r\n"+ data;

    //   jQuery("#send_email_message").val(this_message)
    // });
    //********************


    jQuery("#d_clip_button").click(function(){
      jQuery(this).text("Share link has been copied.");
    });

    var clip = new ZeroClipboard($("#d_clip_button"));


    jQuery(".btn_share_job").click(function(){
        RemoteGenerateShareLink(this);
    });

    jQuery(".btn_apply_job").click(function(){
        RemoteCheckResume();
    });

    jQuery(".btn_save_resume").bind('ajax:success', function(evt, data, status, xhr) {
        jQuery(".play_content").hide();
        jQuery(".apply-success").show();
    });
});

function SetUpEDM(){
    jQuery("#div1").html(jQuery("#txt1").val());
    jQuery("#txt1").keyup(function() {
        jQuery("#div1").html(jQuery("#txt1").val());
        if (GetLength(jQuery("#txt1").val()) > 64000){
            alert("Please make sure your HTML is slim.");
        }
    });

    if (jQuery(".template_header_input").val() == "")
    {
        ShowTemplateHTML();
        jQuery(".template_header_input").show();
        jQuery(".template_header_title").hide();
        jQuery(".btn_save_template").val("Create Template");
    }else
    {
        ShowTemplatePreview();
        jQuery(".template_header_input").hide();
        jQuery(".template_header_title").show();
        jQuery(".btn_save_template").val("Update Template");
    }

    jQuery(".btn_template_edit").click(function(){
        jQuery(".btn_save_template").show();
        ShowTemplateHTML();
    });
    

    jQuery(".btn_template_preview").click(function(){
        ShowTemplatePreview();
    });

    jQuery(".btn_template_html").click(function(){
        ShowTemplateHTML();
    });

    jQuery(".btn_template_split").click(function(){
        ShowTemplateSplit();
    });

    jQuery(".template_header").click(function(){
        jQuery(".template_header_input").show();
        jQuery(".template_header_title").hide();
        event.stopPropagation();
    });

    jQuery("body").click(function(){
        if (jQuery(".template_header_input").val() != "")
        {
            jQuery(".template_header_input").hide();
            jQuery(".template_header_title").show();
            jQuery(".template_header_title h3").text(jQuery(".template_header_input").val());
        }
    });

    jQuery(".template form").on("ajax:success", function(e, data, status, xhr){
        if (data.email_name != ""){
            ShowTemplatePreview();
            var url = "../edm/" + data.id;
            window.open(url,'_self')
        }
    });

    jQuery(".file_upload_submit").click(function(){
            event.preventDefault();
            uploadFiles('../file', document.querySelector('input[type="file"]').files);
    }); 

    jQuery(".file_upload_cancel , .file_upload_remove").click(function(){
         event.preventDefault();
         // jQuery("#file_upload").val("");
         // jQuery(".file_upload_box").hide();
         ShowFileNoFile();
    });

    jQuery("#file_upload").change(function(){
        jQuery("#file_upload").val();
        var file = document.getElementById("file_upload").files[0];
        // jQuery(".file_name").text(file.name);
        // jQuery(".file_size").text(file.size/1024 + "KB");
        // jQuery(".file_info").show();
        // jQuery(".file_upload_box").show();
        // jQuery(".progress-bar").width("0%");
        // jQuery(".send_email_message").text("");
        // jQuery(".send_email_line").hide();
        ShowFileOnLoaded(file);
    });

    if (!window.skip){
        //RemoteEmailStatus();
    }

    jQuery(".btn_send_email").click(function(){
        event.preventDefault();
        jQuery(".send_email_message").text("Sending emails...");
        $.ajax({
                    url: '../send',
                    method: 'POST',
                    data: {
                        "template_id": jQuery("#email_template_id").val()
                    }
        });
        window.skip = false;
        RemoteEmailStatus();
    })
}

function RemoteEmailStatus(){
        setTimeout(function(){
            $.ajax({
                    url: '../send/status',
                    method: 'GET',
                    success: function(data){
                        var message = data.count + " emails has been sent!"
                        jQuery(".send_email_message").text(message);
                        if (data.email == "finished"){
                            window.skip = true;
                            jQuery(".send_email_message").text("Finished email sending!");
                        }
                    }
            });
            if (!window.skip){
                RemoteEmailStatus();
            }
        }, 2000);
}

function uploadFiles(url, files) {
          var formData = new FormData();

          for (var i = 0, file; file = files[i]; ++i) {
            formData.append("upfile", file);
          }

          var xhr = new XMLHttpRequest();
          xhr.open('POST', url, true);
          xhr.onload = function(e) {
            //console.log((ev.loaded/ev.total)+'%');
          };
          // xhr.upload.addEventListener('progress',function(ev){
          //       console.log((ev.loaded/ev.total)+'%');
          //   }, false);

          //var progressBar = document.querySelector('progress');
          xhr.upload.onprogress = function(e) {
            if (e.lengthComputable) {
             // progressBar.value = (e.loaded / e.total) * 100;
              //progressBar.textContent = progressBar.value; // Fallback for unsupported browsers.
              jQuery(".progress").show();
              var percent = (e.loaded / e.total) * 100 + "%";
              jQuery(".progress-bar").width(percent);

              if (percent == "100%"){
                //jQuery(".progress").hide();
                //jQuery(".send_email_line").show();
                ShowFileUploaded();
              }
            }
          };

          xhr.send(formData);  
}

function GetLength(str) {
    ///<summary>获得字符串实际长度，中文2，英文1</summary>
    ///<param name="str">要获得长度的字符串</param>
    var realLength = 0, len = str.length, charCode = -1;
    for (var i = 0; i < len; i++) {
        charCode = str.charCodeAt(i);
        if (charCode >= 0 && charCode <= 128) realLength += 1;
        else realLength += 2;
    }
    return realLength;
}

function ShowTemplatePreview(){
    jQuery(".text_template_html").hide();
    jQuery(".text_template_preview").show();
    jQuery("#div1").html(jQuery("#txt1").val());
    jQuery(".html_mode button").css("background-color","#5bc0de");
    jQuery(".btn_template_preview").css("background-color","#31b0d5");
}

function ShowTemplateHTML(){
    jQuery(".text_template_html").show();
    jQuery(".text_template_preview").hide();
    jQuery(".html_mode button").css("background-color","#5bc0de");
    jQuery(".btn_template_html").css("background-color","#31b0d5");
}

function ShowTemplateSplit(){
    jQuery(".text_template_html").show();
    jQuery(".text_template_preview").show();
    jQuery(".html_mode button").css("background-color","#5bc0de");
    jQuery(".btn_template_split").css("background-color","#31b0d5");
}

function ShowFileOnLoaded(file){
    jQuery(".file_name").text(file.name);
    jQuery(".file_size").text(file.size/1024 + "KB");
    jQuery(".file_info").show();
    jQuery(".file_upload_box").show();
    jQuery(".progress-bar").width("0%");
    jQuery(".send_email_message").text("");
    jQuery(".send_email_line").hide();
    jQuery(".file_upload_remove_div").hide();
    jQuery(".file_upload_cancel_div").show();
    jQuery(".file_upload_submit_div").show();
}

function ShowFileUploaded(){
    jQuery(".send_email_line").show();
    jQuery(".file_upload_remove_div").show();
    jQuery(".file_upload_cancel_div").hide();
    jQuery(".file_upload_submit_div").hide();
}

function ShowFileNoFile(){
    jQuery("#file_upload").val("");
    jQuery(".file_upload_box").hide();
    jQuery(".progress-bar").width("0%");
    jQuery(".send_email_line").hide();
}

function RemoteCheckResume(){
    var phone = jQuery("#node_phone").val();
    var node_id = jQuery('#node_id').val();
    var job_id = jQuery('#job_id').val();
    if (phone != ""){
        $.ajax({
            url: '../remote/check/resume',
            method: 'POST',
            data: {
                "telephone": phone,
                "node_id": node_id,
                "job_id": job_id
            },
            
            success: function(data) {
                if (!data.has_resume)
                {
                    NewResumeView();
                } else 
                {
                    if (!data.has_application)
                    {
                        HasResumeView();
                    }else
                    {
                        HasApplicationView();
                    }
                }
            },
            error: function(data) {
            }

        });
    }else{
        jQuery("#node_phone").attr("placeholder",jQuery("#node_phone").attr("placeholder") + " could not be empty!");
    }
}

function NewResumeView(){
    jQuery(".has_resume").hide();
    jQuery(".new_resume").show();
    jQuery(".has_application").hide();    

    $('#myModal').modal('show');

    jQuery(".modal_btn").click(function(){
        jQuery(".play_content").show();
        jQuery(".play_user_infor").hide();
        window.scrollTo(0,jQuery(".play_content").offset().top-20);

        jQuery("#resume_name").val(jQuery("#node_name").val());
        jQuery("#resume_phone_number").val(jQuery("#node_phone").val());
    });
}

function HasResumeView(){
    //jQuery(".play_user_infor").hide();
    jQuery(".has_resume").show();
    jQuery(".new_resume").hide();
    jQuery(".has_application").hide();

    $('#myModal').modal('show');
    jQuery(".modal_btn").click(function(){
        RemoteApplyJob();
    });
    
}

function HasApplicationView(){
   // jQuery(".play_user_infor").hide();
    jQuery(".has_resume").hide();
    jQuery(".new_resume").hide();
    jQuery(".has_application").show();

    $('#myModal').modal('show');
}

function RemoteApplyJob(){
    var phone = jQuery("#node_phone").val();
    var node_id = jQuery('#node_id').val();
    var job_id = jQuery('#job_id').val();

    if ( node_id != "" && phone != "" && job_id != "")
    {
        $.ajax({
            url: '../remote/apply',
            method: 'POST',
            data: {
                "node_id": node_id,
                "job_id": job_id,
                "telephone": phone
            },
            
            success: function(data) {
            },
            error: function(data) {
            }

        });

    }
}

function RemoteGenerateShareLink(this_button){

    var node_id = jQuery("#node_id").val();
    var node_job_id = jQuery("#node_job_id").val();
    var node_name = jQuery("#node_name").val();
    var node_phone = jQuery("#node_phone").val();

    if (node_phone != "")
    {
        $.ajax({
            url: './remote/share',
            method: 'POST',
            data: {
                "node_id": node_id,
                "job_id": node_job_id,
                "name": node_name,
                "telephone": node_phone
            },
            
            success: function(data) {
                var share_link = window.location.origin + "/spread/job/" + node_job_id + "?node_id=" + data.node_id;
                jQuery("#share_link_text").val(share_link);

                jQuery(".play_user_infor").hide();
                jQuery("#maskLayer").show();
                jQuery(".mask_remder").show();
            },
            error: function(data) {
            }

        });
    }else{
        //jQuery("#node_phone").parent().addClass("has-error");
        jQuery("#node_phone").attr("placeholder",jQuery("#node_phone").attr("placeholder") + " could not be empty!");
    }  

}