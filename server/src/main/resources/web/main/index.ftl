<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>kkFileView演示首页</title>
    <link rel="icon" href="./favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="css/loading.css"/>
    <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="bootstrap-table/bootstrap-table.min.css"/>
    <link rel="stylesheet" href="css/theme.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"/>
    <script type="text/javascript" src="js/jquery-3.6.1.min.js"></script>
    <script type="text/javascript" src="js/jquery.form.min.js"></script>
    <script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="bootstrap-table/bootstrap-table.min.js"></script>
    <script type="text/javascript" src="js/base64.min.js"></script>
    <style>
        <#-- 删除文件密码弹窗居中 -->
        .alert {
            width: 50%;
        }
        <#-- 删除文件验证码弹窗居中 -->
        .modal {
            width:100%;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            -ms-transform: translate(-50%, -50%);
        }
    </style>
</head>

<body>

<#-- 删除文件验证码弹窗  -->
<#if deleteCaptcha >
<div id="deleteCaptchaModal" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-sm" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">删除文件</h4>
            </div>
            <br>
            <input type="text" id="deleteCaptchaFileName" style="display: none">
            <div class="modal-body input-group">
                <span style="display: table-cell; vertical-align: middle;">
                    <img id="deleteCaptchaImg" alt="deleteCaptchaImg" src="">
                    &nbsp;&nbsp;&nbsp;&nbsp;
                </span>
                <input type="text" id="deleteCaptchaText" class="form-control" placeholder="请输入验证码">
            </div>
            <div class="modal-footer" style="text-align: center">
                <button type="button" id="deleteCaptchaConfirmBtn" class="btn btn-danger">确认删除</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>
</#if>

<!-- Fixed navbar -->
<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container">
        <div class="navbar-header">
            <a class="navbar-brand" href="https://kkview.cn" target='_blank'>kkFileView</a>
        </div>
        <ul class="nav navbar-nav">
            <li class="active"><a href="./index">首页</a></li>
            <li><a href="./integrated">接入说明</a></li>
            <li><a href="./record">版本发布记录</a></li>
            <li><a href="./sponsor">赞助开源</a></li>
        </ul>
    </div>
</nav>

<div class="container theme-showcase" role="main">
    <#--  接入说明  -->
    <div class="page-header">
        <h1>支持的文件类型</h1>
        我们一直在扩展支持的文件类型，不断优化预览的效果，如果您有什么建议，欢迎在kk开源社区留意反馈：<a target='_blank' href="https://t.zsxq.com/09ZHSXbsQ">https://t.zsxq.com/09ZHSXbsQ</a>。
    </div>
    <div >
        <ol>
            <li>支持 doc, docx, xls, xlsx, xlsm, ppt, pptx, csv, tsv, dotm, xlt, xltm, dot, dotx, xlam, xla, pages 等 Office 办公文档</li>
            <li>支持 wps, dps, et, ett, wpt 等国产 WPS Office 办公文档</li>
            <li>支持 odt, ods, ots, odp, otp, six, ott, fodt, fods 等OpenOffice、LibreOffice 办公文档</li>
            <li>支持 vsd, vsdx 等 Visio 流程图文件</li>
            <li>支持 wmf, emf 等 Windows 系统图像文件</li>
            <li>支持 psd, eps 等 Photoshop 软件模型文件</li>
            <li>支持 pdf ,ofd, rtf 等文档</li>
            <li>支持 xmind 软件模型文件</li>
            <li>支持 bpmn 工作流文件</li>
            <li>支持 eml 邮件文件</li>
            <li>支持 epub 图书文档</li>
            <li>支持 obj, 3ds, stl, ply, gltf, glb, off, 3dm, fbx, dae, wrl, 3mf, ifc, brep, step, iges, fcstd, bim 等 3D 模型文件</li>
            <li>支持 dwg, dxf, dwf, iges , igs, dwt, dng, ifc, dwfx, stl, cf2, plt  等 CAD 模型文件</li>
            <li>支持 txt, xml(渲染), md(渲染), java, php, py, js, css 等所有纯文本</li>
            <li>支持 zip, rar, jar, tar, gzip, 7z 等压缩包</li>
            <li>支持 jpg, jpeg, png, gif, bmp, ico, jfif, webp 等图片预览（翻转，缩放，镜像）</li>
            <li>支持 tif, tiff 图信息模型文件</li>
            <li>支持 tga 图像格式文件</li>
            <li>支持 svg 矢量图像格式文件</li>
            <li>支持 mp3,wav,mp4,flv 等音视频格式文件</li>
            <li>支持 avi,mov,rm,webm,ts,rm,mkv,mpeg,ogg,mpg,rmvb,wmv,3gp,ts,swf 等视频格式转码预览</li>
            <li>支持 dcm 等医疗数位影像预览</li>
            <li>支持 drawio 绘图预览</li>
        </ol>
    </div>
    <#--  输入下载地址预览文件  -->
    <div class="panel panel-success">
        <div class="panel-heading">
            <h3 class="panel-title">输入下载地址预览</h3>
        </div>
        <div class="panel-body">
            <form>
                <div class="row">
                    <div class="col-md-10">
                        <div class="form-group">
                            <input type="url" class="form-control" id="_url" placeholder="请输入预览文件 url">
                        </div>
                    </div>
                    <div class="col-md-2">
                        <button id="previewByUrl" type="button" class="btn btn-success">预览</button>
                    </div>
                </div>

                <div class="alert alert-danger alert-dismissable hide" role="alert" id="previewCheckAlert">
                    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <strong>请输入正确的url</strong>
                </div>

            </form>
        </div>
    </div>

    <#--  预览测试  -->
    <div class="panel panel-success">
        <div class="panel-heading">
            <h3 class="panel-title">上传本地文件预览</h3>
        </div>
        <div class="panel-body">
            <#if fileUploadDisable == false>
                <form enctype="multipart/form-data" id="fileUpload">
                    <input type="file" id="file" name="files" style="float: left; margin: 0 auto; font-size:22px;" placeholder="请选择文件" multiple/>
                    <input type="button" id="fileUploadBtn" class="btn btn-success" value=" 上 传 "/>
                </form>
            <#else>
                <div style="padding: 20px; margin: 10px 0; background-color: #f8f9fa; border: 1px solid #dee2e6; border-radius: 4px;">
                    <p style="margin: 0; color: #6c757d; font-size: 16px;">
                        文件上传功能默认已禁用。如需开启，请通过以下方式配置：
                        <br/>
                        • 配置文件：<code>file.upload.disable=false</code>
                        <br/>
                        • 环境变量：<code>KK_FILE_UPLOAD_DISABLE=false</code>
                        <br/>
                        <strong style="color: #dc3545;">请注意：文件上传限开发环境调试使用，生产环境建议保持关闭状态，避免非法上传导致的安全隐患。</strong>
                    </p>
                </div>
            </#if>
            <div style="margin-top: 20px; margin-bottom: 10px;">
                <button id="batchDeleteBtn" class="btn btn-danger" disabled>批量删除</button>
            </div>
            <table id="table" data-pagination="true"></table>
        </div>
    </div>
</div>

<div class="loading_container" style="position: fixed;">
    <div class="spinner">
        <div class="spinner-container container1">
            <div class="circle1"></div>
            <div class="circle2"></div>
            <div class="circle3"></div>
            <div class="circle4"></div>
        </div>
        <div class="spinner-container container2">
            <div class="circle1"></div>
            <div class="circle2"></div>
            <div class="circle3"></div>
            <div class="circle4"></div>
        </div>
        <div class="spinner-container container3">
            <div class="circle1"></div>
            <div class="circle2"></div>
            <div class="circle3"></div>
            <div class="circle4"></div>
        </div>
    </div>
</div>
<#if beian?? && beian != "default">
    <div style="display: grid; place-items: center;">
        <div>
            <a target="_blank"  href="https://beian.miit.gov.cn/">${beian}</a>
        </div>
    </div>
</#if>
<script>
    <#if deleteCaptcha >
        $("#deleteCaptchaImg").click(function() {
            $("#deleteCaptchaImg").attr("src","${baseUrl}deleteFile/captcha?timestamp=" + new Date().getTime());
        });
        $("#deleteCaptchaConfirmBtn").click(function() {
            var captcha = $("#deleteCaptchaText").val();
            var isBatch = $(this).data("isBatch");
            
            if (!captcha) {
                alert("请输入验证码");
                return;
            }
            
            if (isBatch) {
                // 批量删除处理
                var fileNames = $("#deleteCaptchaModal").data("fileNames");
                if (!fileNames || fileNames.length === 0) {
                    alert("未找到要删除的文件");
                    return;
                }
                
                $.ajax({
                    url: '${baseUrl}batchDeleteFiles',
                    method: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({
                        fileNames: fileNames,
                        password: captcha
                    }),
                    success: function(data) {
                        $("#deleteCaptchaModal").modal("hide");
                        if (data.code !== 0) {
                            alert(data.msg);
                        } else {
                            var result = data.content;
                            var message = "成功删除 " + result.success + " 个文件";
                            if (result.failure > 0) {
                                message += "，" + result.failure + " 个文件删除失败";
                            }
                            alert(message);
                            $('#table').bootstrapTable("refresh", {});
                        }
                    },
                    error: function() {
                        $("#deleteCaptchaModal").modal("hide");
                        alert("删除失败，请联系管理员");
                    }
                });
            } else {
                // 单个文件删除
                var fileName = $("#deleteCaptchaModal").data("fileName");
                if (!fileName) {
                    alert("未找到要删除的文件");
                    return;
                }
                
                $.ajax({
                    url: '${baseUrl}deleteFile?fileName=' + fileName + '&password=' + captcha,
                    success: function(data) {
                        $("#deleteCaptchaModal").modal("hide");
                        if (data.code !== 0) {
                            alert(data.msg);
                        } else {
                            alert("删除成功");
                            $('#table').bootstrapTable("refresh", {});
                        }
                    },
                    error: function() {
                        $("#deleteCaptchaModal").modal("hide");
                        alert("删除失败，请联系管理员");
                    }
                });
            }
        });
        function deleteFile(fileName) {
            $("#deleteCaptchaImg").click();
            $("#deleteCaptchaFileName").val(fileName);
            $("#deleteCaptchaText").val("");
            $("#deleteCaptchaConfirmBtn").data("isBatch", false);
            $("#deleteCaptchaModal").modal("show");
        }
    <#else>
        function deleteFile(fileName) {
            if (window.confirm('你确定要删除文件吗？')) {
                password = prompt("请输入默认密码:123456");
                $.ajax({
                    url: '${baseUrl}deleteFile?fileName=' + fileName +'&password='+password,
                    success: function (data) {
                        if ("删除文件失败，密码错误！" === data.msg) {
                            alert(data.msg);
                        } else {
                            $("#table").bootstrapTable("refresh", {});
                        }
                    }
                });
            } else {
                return false;
            }
        }
    </#if>

    function showLoadingDiv() {
        var height = window.document.documentElement.clientHeight - 1;
        $(".loading_container").css("height", height).show();
    }

    function onFileSelected() {
        var file = $("#fileSelect").val();
        $("#fileName").text(file);
    }

    function checkUrl(url) {
        //url= 协议://(ftp的登录信息)[IP|域名](:端口号)(/或?请求参数)
        var strRegex = '^((https|http|ftp)://)'//(https或http或ftp)
            + '(([\\w_!~*\'()\\.&=+$%-]+: )?[\\w_!~*\'()\\.&=+$%-]+@)?' //ftp的user@  可有可无
            + '(([0-9]{1,3}\\.){3}[0-9]{1,3}' // IP形式的URL- 3位数字.3位数字.3位数字.3位数字
            + '|' // 允许IP和DOMAIN（域名）
            + '(localhost)|'	//匹配localhost
            + '([\\w_!~*\'()-]+\\.)*' // 域名- 至少一个[英文或数字_!~*\'()-]加上.
            + '\\w+\\.' // 一级域名 -英文或数字  加上.
            + '[a-zA-Z]{1,6})' // 顶级域名- 1-6位英文
            + '(:[0-9]{1,5})?' // 端口- :80 ,1-5位数字
            + '((/?)|' // url无参数结尾 - 斜杆或这没有
            + '(/[\\w_!~*\'()\\.;?:@&=+$,%#-]+)+/?)$';//请求参数结尾- 英文或数字和[]内的各种字符
        var re = new RegExp(strRegex, 'i');//i不区分大小写
        //将url做uri转码后再匹配，解除请求参数中的中文和空字符影响
        return re.test(encodeURI(url));
    }

    $(function () {
        $('#table').bootstrapTable({
            url: 'listFiles',
            pageNumber: ${homePageNumber},//初始化加载第一页
            pageSize:${homePageSize}, //初始化单页记录数
            pagination: ${homePagination}, //是否分页
            pageList: [5, 10, 20, 30, 50, 100, 200, 500],
            search: ${homeSearch}, //显示查询框
            sortName: 'uploadTime',  // 默认按上传时间排序
            sortOrder: 'desc',       // 默认降序排序
            sortStable: true,        // 启用稳定排序
            checkboxHeader: true,    // 显示全选复选框
            clickToSelect: true,     // 点击行时选中复选框
            columns: [{
                checkbox: true       // 添加复选框列
            }, {
                field: 'fileName',
                title: '文件名',
                sortable: true
            }, {
                field: 'uploadTime',
                title: '上传时间',
                sortable: true
            }, {
                field: 'operation',
                title: '操作',
                formatter: function(value, row) {
                    // 预览按钮
                    var openBtn = [
                        '<button class="open btn btn-success btn-xs" title="预览">',
                        '<i class="fa fa-eye"></i> 预览',
                        '</button>'
                    ];
                    
                    // 下载按钮
                    var downloadBtn = [
                        '<button class="download btn btn-primary btn-xs" style="margin-left:10px;" title="下载">',
                        '<i class="fa fa-download"></i> 下载',
                        '</button>'
                    ];
                    
                    // 删除按钮
                    var deleteBtn = 
                    <#if enableDelete>
                    [
                        '<button class="delete btn btn-danger btn-xs" style="margin-left:10px;" title="删除">',
                        '<i class="fa fa-trash"></i> 删除',
                        '</button>'
                    ]
                    <#else>
                    [
                        '<button class="delete btn btn-danger btn-xs" style="margin-left:10px;" disabled="disabled" title="删除">',
                        '<i class="fa fa-trash"></i> 删除',
                        '</button>'
                    ]
                    </#if>;
                    // 拼接所有按钮
                    return openBtn.join("") + downloadBtn.join("") + deleteBtn.join("");
                },
                events: {
                    'click .open': function (e, value, row, index) {
                        var filePath = "";
                        if (row.fileName) {
                            // 从fileName解析文件路径，假设fileName包含完整路径
                            filePath = row.fileName;
                            
                            // 如果存在fileDir属性则使用它（向后兼容）
                            if (row.fileDir) {
                                filePath = row.fileDir.replace(/\\/g,"").toString() + 
                                  (row.fileName.indexOf("/") > -1 ? row.fileName.substring(row.fileName.lastIndexOf("/")+1) : row.fileName);
                            }
                        } else {
                            // 兜底逻辑
                            filePath = row.name || "";
                        }

                        window.open('${baseUrl}onlinePreview?url=' + encodeURIComponent(Base64.encode('${baseUrl}' + filePath)));
                    },
                    'click .download': function (e, value, row, index) {
                        var filePath = "";
                        if (row.fileName) {
                            // 从fileName解析文件路径，假设fileName包含完整路径
                            filePath = row.fileName;
                            
                            // 如果存在fileDir属性则使用它（向后兼容）
                            if (row.fileDir) {
                                filePath = row.fileDir + (row.fileName.indexOf("/") > -1 ? row.fileName.substring(row.fileName.lastIndexOf("/")+1) : row.fileName);
                            }
                        } else {
                            // 兜底逻辑
                            filePath = row.name || "";
                        }
                        
                        // 使用新的download接口
                        window.open('${baseUrl}download?urlPath=' + encodeURIComponent(Base64.encode(filePath)));
                    },
                    'click .delete': function (e, value, row, index) {
                        <#if enableDelete>
                            var filePath = row.fileName || (row.name || "");
                            if (row.fileDir) {
                                filePath = row.fileDir + (row.fileName ? row.fileName : row.name);
                            }
                            
                            <#if deleteCaptcha>
                                $("#deleteCaptchaImg").click();
                                // 仅使用Base64编码，不再二次URL编码
                                var encodedFileName = Base64.encode('${baseUrl}' + filePath);
                                $("#deleteCaptchaModal").data("fileName", encodedFileName);
                                $("#deleteCaptchaConfirmBtn").data("isBatch", false);
                                $("#deleteCaptchaText").val("");
                                $("#deleteCaptchaModal").modal("show");
                            <#else>
                                var password = prompt("请输入默认密码:123456");
                                if (!password) {
                                    return;
                                }
                                // 仅使用Base64编码，不再二次URL编码
                                var encodedFileName = Base64.encode('${baseUrl}' + filePath);
                                $.get('${baseUrl}deleteFile?fileName=' + encodedFileName +'&password=' + password, function(data){
                                    if ("删除文件失败，密码错误！" === data.msg) {
                                        alert(data.msg);
                                    } else {
                                        $('#table').bootstrapTable("refresh", {});
                                    }
                                });
                            </#if>
                        </#if>
                    }
                }
            }]
        }).on('pre-body.bs.table', function (e, data) {
            // 移除冗余代码，因为已经在formatter中实现了这个功能
            return data;
        }).on('post-body.bs.table', function (e, data) {
            return data;
        }).on('check.bs.table uncheck.bs.table check-all.bs.table uncheck-all.bs.table', function () {
            // 当选择项变化时，更新批量删除按钮状态
            var selections = $('#table').bootstrapTable('getSelections');
            $('#batchDeleteBtn').prop('disabled', selections.length === 0);
        });

        $('#previewByUrl').on('click', function () {
            var _url = $("#_url").val();
            if (!checkUrl(_url)) {
                $("#previewCheckAlert").addClass("show");
                window.setTimeout(function () {
                    $("#previewCheckAlert").removeClass("show");
                }, 3000);//显示的时间
                return false;
            }

            var b64Encoded = Base64.encode(_url);

            window.open('${baseUrl}onlinePreview?url=' + encodeURIComponent(b64Encoded));
        });

        $("#batchDeleteBtn").click(function() {
            var selections = $('#table').bootstrapTable('getSelections');
            if (selections.length === 0) {
                return;
            }

            if (window.confirm('确定要删除选中的 ' + selections.length + ' 个文件吗？')) {
                <#if deleteCaptcha>
                    $("#deleteCaptchaImg").click();
                    // 存储选中的文件名列表，仅使用Base64编码，不再二次URL编码
                    var encodedFileNames = selections.map(function(item) { 
                        var filePath = item.fileName || (item.name || "");
                        if (item.fileDir) {
                            filePath = item.fileDir + (item.fileName ? item.fileName : (item.name || ""));
                        }
                        return Base64.encode('${baseUrl}' + filePath); 
                    });
                    $("#deleteCaptchaModal").data("fileNames", encodedFileNames);
                    $("#deleteCaptchaText").val("");
                    $("#deleteCaptchaConfirmBtn").data("isBatch", true);
                    $("#deleteCaptchaModal").modal("show");
                <#else>
                    var password = prompt("请输入默认密码:123456");
                    if (!password) {
                        return;
                    }
                    
                    // 确保文件名仅使用Base64编码，不再二次URL编码
                    var encodedFileNames = selections.map(function(item) { 
                        var filePath = item.fileName || (item.name || "");
                        if (item.fileDir) {
                            filePath = item.fileDir + (item.fileName ? item.fileName : (item.name || ""));
                        }
                        return Base64.encode('${baseUrl}' + filePath); 
                    });
                    
                    $.ajax({
                        url: '${baseUrl}batchDeleteFiles',
                        method: 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify({
                            fileNames: encodedFileNames,
                            password: password
                        }),
                        success: function(data) {
                            if (data.code !== 0) {
                                alert(data.msg);
                            } else {
                                var result = data.content;
                                var message = "成功删除 " + result.success + " 个文件";
                                if (result.failure > 0) {
                                    message += "，" + result.failure + " 个文件删除失败";
                                }
                                alert(message);
                                $('#table').bootstrapTable("refresh", {});
                            }
                        },
                        error: function() {
                            alert("删除失败，请联系管理员");
                        }
                    });
                </#if>
            }
        });

        $("#fileUploadBtn").click(function () {
            if ($("#file")[0].files.length === 0) {
                alert("请选择要上传的文件");
                return false;
            }
            
            // 检查每个文件的大小
            var files = $("#file")[0].files;
            for (var i = 0; i < files.length; i++) {
                if (!checkFileSizeByFile(files[i])) {
                    return false;
                }
            }
            
            showLoadingDiv();
            $("#fileUpload").ajaxSubmit({
                success: function (data) {
                    // 上传完成，刷新table
                    if (1 === data.code) {
                        alert(data.msg);
                    } else {
                        var result = data.content;
                        if (result.success && result.success.length > 0) {
                            var successMsg = "成功上传 " + result.success.length + " 个文件";
                            if (result.failure && result.failure.length > 0) {
                                successMsg += "，" + result.failure.length + " 个文件上传失败：\n" + result.failure.join("\n");
                            }
                            alert(successMsg);
                        } else if (result.failure && result.failure.length > 0) {
                            alert("所有文件上传失败：\n" + result.failure.join("\n"));
                        }
                        $('#table').bootstrapTable('refresh', {});
                    }
                    $("#file").val("");
                    $(".loading_container").hide();
                },
                error: function () {
                    alert('上传失败，请联系管理员');
                    $(".loading_container").hide();
                },
                url: 'batchFileUpload', /*设置post提交到的页面*/
                type: "post", /*设置表单以post方法提交*/
                dataType: "json" /*设置返回值类型为文本*/
            });
        });
    });
    
    function checkFileSizeByFile(file) {
        var daxiao= "${size}";
        daxiao= daxiao.replace("MB","");
        var maxsize = daxiao * 1024 * 1024;
        var errMsg = "上传的文件 [" + file.name + "] 不能超过${size}喔！！！";
        
        try {
            if (file.size > 0 && file.size > maxsize) {
                alert(errMsg);
                return false;
            }
        } catch (e) {
            alert("检查文件大小失败，请重试");
            return false;
        }
        return true;
    }
</script>
</body>
</html>
