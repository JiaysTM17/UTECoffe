Set-Location 'D:\A - Học Tập\Lập Trình Web\Đ.Án\apps\backend'
New-Item -ItemType Directory -Force 'package_war/assets/css' | Out-Null
New-Item -ItemType Directory -Force 'package_war/WEB-INF/classes/static/css' | Out-Null

Copy-Item -Recurse -Force 'target/classes/*' 'package_war/WEB-INF/classes/'
Copy-Item -Recurse -Force 'src/main/resources/static/css/*' 'package_war/WEB-INF/classes/static/css/'
Copy-Item -Recurse -Force 'src/main/webapp/WEB-INF/views/*' 'package_war/WEB-INF/views/'
Copy-Item -Recurse -Force 'src/main/webapp/assets/*' 'package_war/assets/'

& jar -uf app.war -C package_war WEB-INF
& jar -uf app.war -C package_war assets
Write-Output ">>> WAR UPDATE COMPLETED <<<"
