Set-Location 'D:\A - Học Tập\Lập Trình Web\Đ.Án\apps\backend'
New-Item -ItemType Directory -Force 'package_war/assets' | Out-Null
New-Item -ItemType Directory -Force 'package_war/WEB-INF/classes/static' | Out-Null

Copy-Item -Recurse -Force 'target/classes/*' 'package_war/WEB-INF/classes/'
Copy-Item -Recurse -Force 'src/main/resources/static/*' 'package_war/WEB-INF/classes/static/'
Copy-Item -Recurse -Force 'src/main/webapp/WEB-INF/*' 'package_war/WEB-INF/'
Copy-Item -Recurse -Force 'src/main/webapp/assets/*' 'package_war/assets/'

& 'C:\Program Files\Eclipse Adoptium\jdk-21.0.12.101-hotspot\bin\jar.exe' -uf app.war -C package_war WEB-INF
& 'C:\Program Files\Eclipse Adoptium\jdk-21.0.12.101-hotspot\bin\jar.exe' -uf app.war -C package_war assets
Write-Output ">>> WAR UPDATE COMPLETED <<<"
