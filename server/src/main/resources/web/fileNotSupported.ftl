<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8"/>
    <style type="text/css">
        body {
            margin: 0 auto;
            width: 900px;
            background-color: #CCB;
        }

        .container {
            width: 700px;
            height: 700px;
            margin: 0 auto;
        }

        img {
            width: auto;
            height: auto;
            max-width: 100%;
            max-height: 100%;
            padding-bottom: 36px;
        }

        span {
            display: block;
            font-size: 20px;
            color: blue;
        }
    </style>
</head>

<body>
<div class="container">
    <a name="download" title="点击下载文件"><img src="images/sorry.jpg"/></a>
    <span>
        该(${fileType})<a name="download" title="点击下载文件">文件</a>，系统暂不支持在线预览，具体原因如下：
        <p style="color: red;">${msg}</p>
    </span>
    <span>
        你可以&nbsp;<a name="download" title="点击下载文件">下载</a>&nbsp;文件（&nbsp;<a id="file" name="download" title="点击下载文件"></a>&nbsp;）本地查看。
    </span>
    <p>有任何疑问，请加入kk开源社区知识星球咨询：<a href="https://t.zsxq.com/09ZHSXbsQ">https://t.zsxq.com/09ZHSXbsQ</a><br></p>
</div>
<script type="text/javascript">
    document.addEventListener('DOMContentLoaded', function () {
        var downloads = document.querySelectorAll('[name="download"]');
        downloads.forEach(function (download) {
            download.href = atob(decodeURI(new URL(location.href).searchParams.get('url')));
            if(download.id === 'file'){
                download.innerText = download.href;
            }
        });
    });
</script>
</body>
</html>
