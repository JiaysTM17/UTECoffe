Set-Location 'D:\A - Học Tập\Lập Trình Web\Đ.Án\apps\backend'
Copy-Item -Recurse -Force 'target/classes/*' 'package_war/WEB-INF/classes/'
Copy-Item -Recurse -Force 'src/main/webapp/WEB-INF/views/*' 'package_war/WEB-INF/views/'
& jar -uf app.war -C package_war WEB-INF
Write-Output ">>> WAR UPDATE COMPLETED <<<"
