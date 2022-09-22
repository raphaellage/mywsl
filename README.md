# myWsl

## How to build
### Follow this steps on Powershell
```pwsh
git clone git@github.com:raphaellage/mywsl.git
```
```pwsh
cd mywsl
```
```pwsh
docker build --build-arg USER_PASSWORD={user_password} --build-arg USER={user_name} -t mywsl .
```
```pwsh
docker run -h mywsl -e TZ=America/Sao_Paulo --name mywsl mywsl
```
```pwsh
docker export --output="mywsl.tar" mywsl
```
```pwsh
wsl --set-default mywsl
```

### Windows Terminal setup
After finish the previous steps, close and open windows
terminal again.

Type `Ctrl + Shift + , ` to open the `settings.json` file.

Search on the `profiles > list` for the profile of `mywsl` and change it to:
```json
"commandline": "C:\\Windows\\system32\\wsl.exe ~ -u {user_name} -d mywsl"
```
Replace `{user_name}` with the user name you used on the distro build